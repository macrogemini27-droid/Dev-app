# Claude Code Mobile

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19.0-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Build](https://img.shields.io/badge/Build-Passing-success)

**AI-Powered Coding Assistant for Remote Servers via SSH**

[Features](#features) • [Architecture](#architecture) • [Getting Started](#getting-started) • [Documentation](#documentation)

</div>

---

## 🚀 Overview

Claude Code Mobile brings the power of AI-assisted coding to your mobile device. Connect to remote servers via SSH and interact with Claude AI to perform software engineering tasks—all without installing anything on the server.

### Key Features

- 🔐 **Secure SSH Connection** - Connect to any remote server with password or key-based authentication
- 🤖 **AI-Powered Assistance** - Full Claude AI integration for coding tasks
- 📁 **Remote File Operations** - Read, write, and edit files on remote servers
- 🎨 **Modern Dark Theme** - Beautiful, eye-friendly interface
- 💾 **Session Persistence** - Save and resume conversations
- 🔧 **Multiple AI Providers** - Support for Anthropic, AWS Bedrock, Google Vertex, and custom endpoints
- ⚡ **Real-Time Tool Execution** - See what Claude is doing in real-time

---

## 🏗️ Architecture

Built with **Clean Architecture** and **BLoC** pattern for maximum scalability and maintainability.

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│   - BLoC (State Management)         │
│   - Screens & Widgets               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Domain Layer                   │
│   - Entities                        │
│   - Use Cases                       │
│   - Repository Interfaces           │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Data Layer                     │
│   - SSH Client                      │
│   - Repositories                    │
│   - Tools (Read, Write, Edit, etc.) │
└─────────────────────────────────────┘
```

### Tech Stack

- **Framework**: Flutter 3.19.0
- **Language**: Dart 3.3.0
- **State Management**: flutter_bloc
- **SSH**: dartssh2
- **Database**: sqflite
- **Secure Storage**: flutter_secure_storage
- **Code Generation**: freezed, json_serializable

---

## 📦 Getting Started

### Prerequisites

- Flutter SDK 3.19.0 or higher
- Dart SDK 3.3.0 or higher
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/claude-code-mobile.git
cd claude-code-mobile
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run code generation**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For a specific device
flutter devices
flutter run -d <device-id>
```

### Building for Production

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🎯 Features

### ✅ Implemented

- **Core Architecture**
  - Clean Architecture with 3 layers
  - BLoC pattern for state management
  - Dependency injection with GetIt
  - Repository pattern

- **SSH Connection**
  - Password authentication
  - SSH key authentication
  - Connection status monitoring
  - Auto-reconnect capability

- **Tool System**
  - Read: Read files from remote server
  - Write: Create/overwrite files
  - Edit: Partial file modifications
  - Bash: Execute shell commands
  - Grep: Search file contents
  - Glob: Find files by pattern

- **UI/UX**
  - Modern dark theme (GitHub-inspired)
  - Chat interface with streaming
  - Tool execution indicators
  - Message history
  - Connection status display

- **Data Persistence**
  - SQLite for sessions and messages
  - Secure storage for credentials
  - Local storage for settings

### 🚧 Coming Soon

- API integration with Anthropic Claude
- SSH connection dialog UI
- Provider management screen
- File browser
- Syntax highlighting
- Session search
- Export/import sessions
- Voice input
- Offline mode

---

## 📚 Documentation

- [Setup Instructions](SETUP.md) - Detailed setup guide
- [Architecture Review](ARCHITECTURE_REVIEW.md) - Comprehensive architecture analysis
- [Product Requirements](PRD.md) - Full product specification

### Project Structure

```
lib/
├── core/              # Core utilities, theme, constants
├── data/              # Data sources, repositories, tools
├── domain/            # Entities, use cases, repository interfaces
├── presentation/      # BLoCs, screens, widgets
└── main.dart          # App entry point
```

---

## 🛠️ Development

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Analysis

```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

### Code Generation

```bash
# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🔒 Security

- **Encrypted Storage**: All credentials stored with AES-256 encryption
- **Shell Escaping**: All SSH commands properly escaped to prevent injection
- **Secure Communication**: HTTPS for API calls, SSH for server communication
- **No Server Installation**: Zero footprint on remote servers

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards

- Follow Flutter/Dart style guide
- Write tests for new features
- Update documentation
- Run `flutter analyze` before committing

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by [Claude Code CLI](https://github.com/anthropics/claude-code)
- Built with [Flutter](https://flutter.dev)
- Powered by [Anthropic Claude](https://anthropic.com)

---

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

<div align="center">

**Made with ❤️ and Claude AI**

[⬆ Back to Top](#claude-code-mobile)

</div>
