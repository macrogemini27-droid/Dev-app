# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Clone and Setup

```bash
git clone <your-repo-url>
cd claude-code-mobile
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Run the App

```bash
flutter run
```

That's it! The app will launch on your connected device.

## 📱 First Time Setup

### 1. Connect to SSH Server

When you first open the app:
1. Tap the "Connect" button
2. Enter your SSH credentials:
   - Host: `your-server.com`
   - Port: `22`
   - Username: `your-username`
   - Password or SSH Key

### 2. Create a Session

1. Tap the "New Session" button
2. Select your working directory
3. Choose an AI provider (Anthropic recommended)
4. Start chatting!

### 3. Add AI Provider

1. Go to Settings
2. Tap "Add Provider"
3. Enter your API key
4. Select provider type (Anthropic, Bedrock, Vertex, or Custom)

## 🎯 Example Usage

### Read a File
```
User: Read the file /home/user/app.py
Claude: [Executes Read tool and shows file contents]
```

### Edit Code
```
User: In app.py, change the port from 3000 to 8080
Claude: [Executes Edit tool to make the change]
```

### Run Commands
```
User: Run npm install
Claude: [Executes Bash tool and shows output]
```

### Search Files
```
User: Find all Python files in the project
Claude: [Executes Glob tool with pattern *.py]
```

## 🔧 Troubleshooting

### Build Errors

If you get build errors:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### SSH Connection Issues

- Check firewall settings
- Verify SSH port is open (default: 22)
- Test connection with: `ssh user@host`

### Code Generation Issues

If freezed/json_serializable fails:
```bash
flutter pub upgrade
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Next Steps

- Read [SETUP.md](SETUP.md) for detailed instructions
- Check [PRD.md](PRD.md) for full feature list
- Review [ARCHITECTURE_REVIEW.md](ARCHITECTURE_REVIEW.md) for architecture details

## 💡 Tips

1. **Save Sessions**: All conversations are automatically saved
2. **Multiple Providers**: Add multiple AI providers and switch between them
3. **Tool Execution**: Watch real-time tool execution in the UI
4. **Offline Mode**: Messages are queued when offline and sent when reconnected

## 🆘 Need Help?

- Open an issue on GitHub
- Check existing issues for solutions
- Read the documentation

---

**Happy Coding! 🎉**
