# Claude Code Mobile

AI-powered coding assistant for remote servers via SSH. Built with Flutter.

## Features

- 🔐 Secure SSH connection to remote servers
- 🤖 AI-powered coding assistance with Claude
- 📁 Remote file system operations
- 🎨 Modern dark theme UI
- 💾 Session persistence and history
- 🔧 Multiple AI provider support
- ⚡ Real-time tool execution

## Architecture

Clean Architecture with BLoC pattern:
- **Presentation Layer**: UI components and BLoCs
- **Domain Layer**: Business logic and entities
- **Data Layer**: SSH client, repositories, and data sources

## Getting Started

### Prerequisites

- Flutter SDK 3.3.0 or higher
- Dart SDK 3.3.0 or higher

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd claude_code_mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

```bash
flutter test
```

## CI/CD

GitHub Actions automatically builds the app on push to main branch.

## License

MIT License
