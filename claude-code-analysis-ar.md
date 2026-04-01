# تحليل شامل لـ Claude Code - دليل بناء نسخة موبايل

## نظرة عامة

Claude Code هو CLI tool متقدم من Anthropic، مبني بـ TypeScript ويعمل على Bun runtime. الكود المسرب يحتوي على:

- **~1,916 ملف TypeScript**
- **~512,000+ سطر كود**
- **Architecture معقدة** مع React + Ink للـ Terminal UI

---

## 🏗️ البنية المعمارية الأساسية

### 1. Pipeline الرئيسي

```
User Input → CLI Parser → Query Engine → LLM API → Tool Execution Loop → Terminal UI
```

### المكونات الأساسية

| المكون | الملف | الوظيفة |
|--------|------|---------|
| **Entry Point** | `src/main.tsx` | Commander.js parser + React/Ink renderer (4,684 سطر) |
| **Query Engine** | `src/QueryEngine.ts` | محرك الـ LLM - streaming, tool loops, retries (1,297 سطر) |
| **Tool System** | `src/Tool.ts` | نظام الأدوات الأساسي (794 سطر) |
| **Commands** | `src/commands.ts` | نظام الأوامر (758 سطر) |

---

## 🔧 نظام الأدوات (Tools System)

يوجد **~40 أداة** في `src/tools/`، كل أداة في مجلد منفصل:

### أدوات الملفات
- `FileReadTool` - قراءة الملفات (نصوص، صور، PDFs)
- `FileWriteTool` - كتابة/إنشاء ملفات
- `FileEditTool` - تعديل جزئي للملفات
- `GlobTool` - البحث عن ملفات بـ patterns
- `GrepTool` - البحث في محتوى الملفات (ripgrep)

### أدوات التنفيذ
- `BashTool` - تنفيذ أوامر shell
- `AgentTool` - إنشاء sub-agents
- `MCPTool` - Model Context Protocol integration

### أدوات الويب
- `WebSearchTool` - البحث على الإنترنت
- `WebFetchTool` - جلب محتوى من URLs

---

## 🌉 Bridge System - المفتاح للموبايل

**الموقع:** `src/bridge/` (33 ملف)

### البنية

```
┌──────────────────┐         ┌──────────────────────┐
│   IDE Extension  │◄───────►│   Bridge Layer       │
│  (VS Code, JB)   │  JWT    │  (src/bridge/)       │
│                  │  Auth   │                      │
│  - UI rendering  │         │  - Session mgmt      │
│  - File watching │         │  - Message routing   │
│  - Diff display  │         │  - Permission proxy  │
└──────────────────┘         └──────────┬───────────┘
                                        │
                                        ▼
                              ┌──────────────────────┐
                              │   Claude Code Core   │
                              │  (QueryEngine, Tools) │
                              └──────────────────────┘
```

### الملفات الرئيسية للـ Bridge

| الملف | الحجم | الوظيفة |
|------|------|---------|
| `bridgeMain.ts` | 115KB | Main bridge loop - القلب النابض |
| `replBridge.ts` | 100KB | REPL session bridge |
| `remoteBridgeCore.ts` | 39KB | Remote bridge core logic |
| `bridgeMessaging.ts` | 15KB | Message protocol (serialize/deserialize) |
| `sessionRunner.ts` | 18KB | Session execution management |
| `jwtUtils.ts` | 9KB | JWT authentication |

### البروتوكولات

**نسختين من Transport:**

1. **v1 (env-based)**: WebSocket + HTTP POST
2. **v2 (env-less)**: SSE stream + CCRClient

### Authentication Flow

1. OAuth tokens (claude.ai subscription)
2. JWT tokens (`sk-ant-si-` prefix)
3. Trusted Device token
4. Environment secret (base64url encoded)

---

## 📱 خطة بناء نسخة Flutter للموبايل

### المتطلبات الأساسية

#### 1. SSH Connection Layer
```dart
// lib/core/ssh/ssh_manager.dart
class SSHManager {
  SSHClient? _client;
  
  Future<void> connect({
    required String host,
    required int port,
    required String username,
    required String password, // or privateKey
  }) async {
    // استخدام dartssh2 package
    _client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      onPasswordRequest: () => password,
    );
  }
  
  Future<String> executeCommand(String command) async {
    final session = await _client!.execute(command);
    return utf8.decode(await session.stdout.toList().then(
      (chunks) => chunks.expand((chunk) => chunk).toList()
    ));
  }
}
```

#### 2. Bridge Communication
```dart
// lib/core/bridge/bridge_client.dart
class BridgeClient {
  final SSHManager sshManager;
  final WebSocketChannel? wsChannel;
  
  // إرسال رسائل للـ CLI
  Future<void> sendMessage(Map<String, dynamic> message) async {
    final jsonMessage = jsonEncode(message);
    
    if (wsChannel != null) {
      // WebSocket mode
      wsChannel!.sink.add(jsonMessage);
    } else {
      // SSH mode
      await sshManager.executeCommand(
        'echo \'$jsonMessage\' | claude bridge-receive'
      );
    }
  }
  
  // استقبال الرسائل
  Stream<BridgeMessage> receiveMessages() {
    if (wsChannel != null) {
      return wsChannel!.stream.map((data) => 
        BridgeMessage.fromJson(jsonDecode(data))
      );
    } else {
      // SSH polling mode
      return Stream.periodic(Duration(milliseconds: 500), (_) async {
        final output = await sshManager.executeCommand(
          'claude bridge-poll'
        );
        return BridgeMessage.fromJson(jsonDecode(output));
      }).asyncMap((future) => future);
    }
  }
}
```

#### 3. Query Engine Wrapper
```dart
// lib/core/engine/query_engine.dart
class QueryEngine {
  final BridgeClient bridge;
  
  Future<AssistantResponse> query({
    required String prompt,
    List<Message>? history,
    List<Tool>? tools,
  }) async {
    // إرسال الـ query للـ CLI
    await bridge.sendMessage({
      'type': 'user_message',
      'content': prompt,
      'tools': tools?.map((t) => t.toJson()).toList(),
    });
    
    // استقبال الرد
    final response = await bridge.receiveMessages()
      .firstWhere((msg) => msg.type == 'assistant_message');
    
    return AssistantResponse.fromBridgeMessage(response);
  }
}
```

### البنية المقترحة للتطبيق

```
lib/
├── main.dart
├── core/
│   ├── ssh/
│   │   ├── ssh_manager.dart
│   │   └── ssh_config.dart
│   ├── bridge/
│   │   ├── bridge_client.dart
│   │   ├── bridge_message.dart
│   │   └── bridge_protocol.dart
│   ├── engine/
│   │   ├── query_engine.dart
│   │   └── tool_executor.dart
│   └── auth/
│       ├── jwt_manager.dart
│       └── oauth_handler.dart
├── features/
│   ├── chat/
│   │   ├── presentation/
│   │   │   ├── chat_screen.dart
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   └── models/
│   │   └── data/
│   │       └── repositories/
│   ├── tools/
│   │   ├── file_operations/
│   │   ├── bash_execution/
│   │   └── web_tools/
│   └── settings/
│       └── ssh_configuration/
└── shared/
    ├── widgets/
    ├── utils/
    └── constants/
```

---

## 🔑 النقاط الحرجة للتنفيذ

### 1. Session Management
```dart
class SessionManager {
  String? sessionId;
  String? jwtToken;
  DateTime? tokenExpiry;
  
  Future<void> createSession() async {
    // POST to /v1/code/sessions
    final response = await http.post(
      Uri.parse('$baseUrl/v1/code/sessions'),
      headers: {'Authorization': 'Bearer $oauthToken'},
    );
    
    sessionId = response.data['session_id'];
    jwtToken = response.data['jwt_token'];
  }
  
  Future<void> refreshToken() async {
    // Proactive refresh before expiry
    if (tokenExpiry != null && 
        DateTime.now().isAfter(tokenExpiry!.subtract(Duration(minutes: 5)))) {
      // Refresh logic
    }
  }
}
```

### 2. Tool Execution via SSH
```dart
class ToolExecutor {
  final SSHManager ssh;
  
  Future<ToolResult> executeTool({
    required String toolName,
    required Map<String, dynamic> input,
  }) async {
    // تنفيذ الأداة على السيرفر عبر SSH
    final command = 'claude tool-exec $toolName \'${jsonEncode(input)}\'';
    final output = await ssh.executeCommand(command);
    
    return ToolResult.fromJson(jsonDecode(output));
  }
}
```

### 3. Real-time Streaming
```dart
class StreamingHandler {
  Stream<StreamEvent> streamQuery(String prompt) async* {
    await bridge.sendMessage({
      'type': 'user_message',
      'content': prompt,
      'stream': true,
    });
    
    await for (final message in bridge.receiveMessages()) {
      if (message.type == 'content_block_delta') {
        yield StreamEvent.textDelta(message.delta);
      } else if (message.type == 'tool_use') {
        yield StreamEvent.toolUse(message.toolName, message.input);
      }
    }
  }
}
```

---

## 📦 Dependencies المطلوبة

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # SSH Connection
  dartssh2: ^2.9.0
  
  # WebSocket (optional)
  web_socket_channel: ^2.4.0
  
  # HTTP & API
  dio: ^5.4.0
  http: ^1.2.0
  
  # State Management
  riverpod: ^2.4.0
  
  # Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Security
  flutter_secure_storage: ^9.0.0
  
  # JWT
  dart_jsonwebtoken: ^2.12.0
  
  # UI
  flutter_markdown: ^0.6.18
  syntax_highlight: ^0.1.0
  
  # Utils
  path: ^1.8.3
  uuid: ^4.3.3
```

---

## 🚀 خطوات التنفيذ

### المرحلة 1: SSH Layer (أسبوع 1-2)
1. ✅ إعداد SSH connection manager
2. ✅ Command execution wrapper
3. ✅ Error handling & reconnection logic
4. ✅ Session persistence

### المرحلة 2: Bridge Protocol (أسبوع 3-4)
1. ✅ Message serialization/deserialization
2. ✅ Bridge client implementation
3. ✅ JWT authentication flow
4. ✅ Session management

### المرحلة 3: Query Engine (أسبوع 5-6)
1. ✅ Query wrapper
2. ✅ Tool execution via SSH
3. ✅ Streaming support
4. ✅ Response parsing

### المرحلة 4: UI Layer (أسبوع 7-8)
1. ✅ Chat interface
2. ✅ Tool execution visualization
3. ✅ File operations UI
4. ✅ Settings & configuration

### المرحلة 5: Testing & Polish (أسبوع 9-10)
1. ✅ Integration testing
2. ✅ Performance optimization
3. ✅ Error handling refinement
4. ✅ Documentation

---

## 🔒 Security Considerations

### 1. SSH Key Management
```dart
class SecureKeyStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  Future<void> savePrivateKey(String key) async {
    await _storage.write(
      key: 'ssh_private_key',
      value: key,
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }
}
```

### 2. JWT Token Security
- تخزين آمن في Keychain/Keystore
- Auto-refresh قبل انتهاء الصلاحية
- Secure transmission عبر HTTPS/SSH

### 3. Connection Security
- SSH key-based authentication (أفضل من password)
- Certificate pinning للـ HTTPS
- Encrypted storage للـ credentials

---

## 📊 Performance Optimization

### 1. Connection Pooling
```dart
class ConnectionPool {
  final Queue<SSHClient> _pool = Queue();
  final int maxConnections = 5;
  
  Future<SSHClient> acquire() async {
    if (_pool.isNotEmpty) {
      return _pool.removeFirst();
    }
    return await createNewConnection();
  }
  
  void release(SSHClient client) {
    if (_pool.length < maxConnections) {
      _pool.add(client);
    } else {
      client.close();
    }
  }
}
```

### 2. Response Caching
```dart
class ResponseCache {
  final Map<String, CachedResponse> _cache = {};
  
  CachedResponse? get(String key) {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired) {
      return cached;
    }
    return null;
  }
}
```

---

## 🎯 الميزات الأساسية للنسخة الأولى (MVP)

### Must Have
- ✅ SSH connection management
- ✅ Basic chat interface
- ✅ File read/write operations
- ✅ Bash command execution
- ✅ Session persistence

### Nice to Have
- ⏳ WebSocket support (fallback)
- ⏳ Offline mode with queue
- ⏳ Multi-session support
- ⏳ Voice input
- ⏳ Code syntax highlighting

### Future Enhancements
- 🔮 Local LLM support
- 🔮 Plugin system
- 🔮 Team collaboration
- 🔮 Advanced file operations
- 🔮 Git integration

---

## 💡 نصائح مهمة

### 1. استخدم الـ Bridge بدلاً من إعادة بناء كل شيء
- الـ Bridge موجود ومجرب
- يوفر عليك آلاف الساعات
- يدعم كل الـ features

### 2. SSH هو الخيار الأمثل للموبايل
- أبسط من WebSocket setup
- أكثر أماناً
- يعمل في أي بيئة

### 3. ابدأ بـ MVP صغير
- Chat + File operations + Bash
- باقي الـ features تدريجياً
- Test كل feature بشكل منفصل

### 4. Performance مهم جداً
- Connection pooling
- Response caching
- Lazy loading للـ tools
- Background processing

---

## 📚 مصادر إضافية

### الملفات المهمة للدراسة

1. **Bridge System**
   - `src/bridge/bridgeMain.ts` - Main loop
   - `src/bridge/replBridge.ts` - REPL integration
   - `src/bridge/bridgeMessaging.ts` - Protocol

2. **Query Engine**
   - `src/QueryEngine.ts` - Core engine
   - `src/query.ts` - Query helpers

3. **Tools**
   - `src/tools/BashTool/` - Bash execution
   - `src/tools/FileReadTool/` - File operations
   - `src/tools/AgentTool/` - Sub-agents

4. **Authentication**
   - `src/services/oauth/` - OAuth flow
   - `src/bridge/jwtUtils.ts` - JWT handling

---

## 🎓 الخلاصة

بناء نسخة موبايل من Claude Code ممكن جداً باستخدام:

1. **SSH** للاتصال بالسيرفر
2. **Bridge Protocol** للتواصل مع الـ CLI
3. **Flutter** لبناء الـ UI
4. **Query Engine Wrapper** لإدارة الـ queries

المفتاح هو استخدام الـ **Bridge System** الموجود بدلاً من إعادة بناء كل شيء من الصفر.

**الوقت المتوقع:** 8-10 أسابيع للـ MVP
**الصعوبة:** متوسطة إلى عالية
**الجدوى:** عالية جداً

---

**ملاحظة:** هذا التحليل مبني على الكود المسرب. للاستخدام الفعلي، تحتاج:
- Claude API key
- SSH access لسيرفر يشغل Claude Code
- OAuth credentials (للـ bridge mode)
