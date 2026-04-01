# Claude Code Mobile - Setup Instructions

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   └── injection_container.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── datasources/
│   │   ├── api/
│   │   │   └── anthropic_api_client.dart
│   │   ├── local/
│   │   │   ├── database_helper.dart
│   │   │   ├── local_storage_service.dart
│   │   │   └── secure_storage_service.dart
│   │   └── ssh/
│   │       └── ssh_client_impl.dart
│   ├── repositories/
│   │   ├── provider_repository_impl.dart
│   │   ├── session_repository_impl.dart
│   │   ├── ssh_repository_impl.dart
│   │   └── tool_repository_impl.dart
│   └── tools/
│       ├── bash_tool.dart
│       ├── file_edit_tool.dart
│       ├── file_read_tool.dart
│       ├── file_write_tool.dart
│       ├── glob_tool.dart
│       └── grep_tool.dart
├── domain/
│   ├── entities/
│   │   ├── message.dart
│   │   ├── provider_config.dart
│   │   ├── session.dart
│   │   ├── ssh_config.dart
│   │   └── tool.dart
│   ├── repositories/
│   │   ├── provider_repository.dart
│   │   ├── session_repository.dart
│   │   ├── ssh_repository.dart
│   │   └── tool_repository.dart
│   └── usecases/
│       ├── provider/
│       │   ├── add_provider.dart
│       │   └── get_providers.dart
│       ├── session/
│       │   ├── create_session.dart
│       │   ├── load_session.dart
│       │   └── save_message.dart
│       ├── ssh/
│       │   ├── connect_ssh.dart
│       │   ├── disconnect_ssh.dart
│       │   └── execute_command.dart
│       └── tool/
│           └── execute_tool.dart
├── presentation/
│   ├── blocs/
│   │   ├── chat/
│   │   │   ├── chat_bloc.dart
│   │   │   ├── chat_event.dart
│   │   │   └── chat_state.dart
│   │   ├── connection/
│   │   │   ├── connection_bloc.dart
│   │   │   ├── connection_event.dart
│   │   │   └── connection_state.dart
│   │   └── provider/
│   │       ├── provider_bloc.dart
│   │       ├── provider_event.dart
│   │       └── provider_state.dart
│   ├── screens/
│   │   ├── chat/
│   │   │   └── chat_screen.dart
│   │   └── home/
│   │       └── home_screen.dart
│   └── widgets/
│       ├── chat_input.dart
│       ├── message_bubble.dart
│       └── tool_execution_indicator.dart
└── main.dart
```

## Next Steps

### 1. Run Code Generation

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files for immutable data classes
- `*.g.dart` files for JSON serialization

### 2. Create Missing Directories

```bash
mkdir -p assets/images
mkdir -p assets/icons
```

### 3. Test the Build

```bash
# Check for any issues
flutter analyze

# Run tests
flutter test

# Build for Android
flutter build apk --debug

# Build for iOS (macOS only)
flutter build ios --debug --no-codesign
```

### 4. Connect to GitHub

```bash
# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Push to GitHub
git push -u origin main
```

### 5. GitHub Actions

The workflow is already configured in `.github/workflows/build.yml`. It will:
- Run on push to `main` or `develop` branches
- Install Flutter and dependencies
- Run code generation
- Run tests and analysis
- Build Android APK and AAB
- Build iOS app (no codesign)
- Upload artifacts

## Features Implemented

### Core Architecture
- ✅ Clean Architecture with 3 layers (Domain, Data, Presentation)
- ✅ BLoC pattern for state management
- ✅ Dependency injection with GetIt
- ✅ Repository pattern
- ✅ Use case pattern

### Domain Layer
- ✅ Entities: Message, Session, SSHConfig, ProviderConfig, Tool
- ✅ Repository interfaces
- ✅ Use cases for SSH, Session, Provider, Tool operations

### Data Layer
- ✅ SSH client implementation with dartssh2
- ✅ SQLite database for sessions and messages
- ✅ Secure storage for credentials
- ✅ Local storage for settings
- ✅ Anthropic API client
- ✅ 6 core tools: Read, Write, Edit, Bash, Grep, Glob

### Presentation Layer
- ✅ Modern dark theme (GitHub-inspired)
- ✅ Home screen with connection status
- ✅ Chat screen with message bubbles
- ✅ Tool execution indicators
- ✅ Chat input with send button
- ✅ BLoCs for Chat, Connection, Provider

### CI/CD
- ✅ GitHub Actions workflow
- ✅ Automated builds for Android and iOS
- ✅ Test and analysis automation

## TODO: Features to Implement

### High Priority
1. **API Integration**: Connect chat to Anthropic API for real responses
2. **SSH Connection Dialog**: UI for entering SSH credentials
3. **Provider Management**: Add/edit/delete AI providers
4. **Session List**: Display and manage multiple sessions
5. **Tool Result Display**: Better visualization of tool outputs

### Medium Priority
6. **File Browser**: Browse remote file system
7. **Syntax Highlighting**: Code blocks in messages
8. **Copy Code**: Copy button for code blocks
9. **Session Search**: Search through messages
10. **Settings Screen**: App configuration

### Low Priority
11. **Voice Input**: Speech-to-text
12. **Export Sessions**: Export as JSON/Markdown
13. **Themes**: Light theme option
14. **Notifications**: Background notifications
15. **Offline Mode**: Queue messages when offline

## Known Issues

1. **Code Generation Required**: Run `flutter pub run build_runner build` before first run
2. **API Integration Pending**: Chat responses are simulated
3. **SSH Connection UI**: Connection dialog not implemented yet
4. **Session Persistence**: Session list not loading from database yet

## Architecture Decisions

### Why SSH Model?
- Zero installation on remote servers
- Direct command execution
- Full control over operations
- No server-side dependencies

### Why Clean Architecture?
- Separation of concerns
- Testability
- Maintainability
- Scalability

### Why BLoC?
- Predictable state management
- Easy testing
- Clear separation of business logic
- Flutter community standard

### Why Freezed?
- Immutable data classes
- Copy with functionality
- Union types
- Code generation reduces boilerplate

## Performance Considerations

1. **SSH Connection Pooling**: Reuse connections
2. **Message Pagination**: Load messages in batches
3. **Tool Result Caching**: Cache file reads
4. **Database Indexing**: Indexes on session_id and timestamp
5. **Lazy Loading**: Load sessions on demand

## Security Considerations

1. **Secure Storage**: API keys and SSH credentials encrypted
2. **Shell Escaping**: All SSH commands properly escaped
3. **Input Validation**: Validate all user inputs
4. **Connection Timeout**: Prevent hanging connections
5. **Error Handling**: Don't expose sensitive info in errors

## Testing Strategy

1. **Unit Tests**: Test use cases and repositories
2. **Widget Tests**: Test UI components
3. **Integration Tests**: Test complete flows
4. **BLoC Tests**: Test state transitions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and analysis
5. Submit a pull request

## License

MIT License
