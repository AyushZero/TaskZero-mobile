# Taskzer0

A modern, minimalist task management application built with Flutter. Taskzer0 helps you organize your daily tasks with a clean and intuitive interface, featuring both light and dark modes for comfortable usage at any time of day.

## Features

- ✨ Clean, minimalist interface
- 🌓 Light and dark mode support
- 📱 Responsive design
- 💾 Persistent storage using SharedPreferences
- 📋 Task management capabilities:
  - Add new tasks
  - Mark tasks as complete/incomplete
  - Archive/unarchive tasks
  - Delete tasks
- 🔄 Swipe gestures for quick actions
- 📱 System UI theme integration

## Project Structure

```
taskzer0/
├── lib/
│   ├── main.dart           # Main application entry point
│   ├── models/             # Data models
│   ├── screens/            # Screen widgets
│   ├── widgets/            # Reusable widgets
│   └── utils/              # Utility functions
├── assets/
│   └── fonts/             # Custom fonts
├── test/                  # Test files
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── pubspec.yaml           # Project configuration
├── README.md             # Project documentation
├── LICENSE               # MIT license
└── CONTRIBUTING.md       # Contribution guidelines
```

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator

### Development Setup

1. Install Flutter by following the [official installation guide](https://flutter.dev/docs/get-started/install)

2. Clone the repository:
```bash
git clone https://github.com/yourusername/taskzer0.git
cd taskzer0
```

3. Install dependencies:
```bash
flutter pub get
```

4. Set up your IDE:
   - For VS Code: Install the Flutter and Dart extensions
   - For Android Studio: Install the Flutter plugin

5. Run the app:
```bash
flutter run
```

### Running Tests

```bash
flutter test
```

### Building for Production

For Android:
```bash
flutter build apk --release
```

For iOS:
```bash
flutter build ios --release
```

## Dependencies

- flutter: sdk
- shared_preferences: ^2.2.2 - For persistent storage
- flutter/services: For system UI integration

## Usage

- **Adding Tasks**: Type your task in the bottom input field and tap the + button
- **Completing Tasks**: Swipe right-to-left on a task
- **Archiving Tasks**: Swipe left-to-right on a task
- **Managing Tasks**: Long press on any task to see additional options
- **Switching Views**: Tap on "Tasks" or "Archived" at the top
- **Changing Theme**: Tap the circle button in the top-right corner

## Troubleshooting

### Common Issues

1. **Build Fails**
   - Run `flutter clean` and try again
   - Ensure all dependencies are up to date
   - Check your Flutter SDK version

2. **Hot Reload Not Working**
   - Restart the app
   - Check for syntax errors
   - Ensure your device is connected properly

3. **Performance Issues**
   - Enable performance overlay: `Flutter.addOption(enablePerformanceOverlay: true)`
   - Check for unnecessary rebuilds
   - Profile the app using Flutter DevTools

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests, report issues, and contribute to the project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Design inspired by modern minimalist UI principles
- Built with Flutter framework
- Thanks to all contributors who help improve Taskzer0

## Support

If you're having any problems, please:
1. Check the [issues page](https://github.com/yourusername/taskzer0/issues)
2. Create a new issue if your problem isn't already listed
3. Join our community discussions
