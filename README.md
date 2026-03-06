# multichoice

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![GitHub Release](https://img.shields.io/github/v/release/ZanderCowboy/multichoice)
![GitHub Tag](https://img.shields.io/github/v/tag/ZanderCowboy/multichoice)

![Linting](https://github.com/ZanderCowboy/multichoice/actions/workflows/linting_workflow.yml/badge.svg)
![Build](https://github.com/ZanderCowboy/multichoice/actions/workflows/build_workflow.yml/badge.svg)
![Deploy](https://github.com/ZanderCowboy/multichoice/actions/workflows/deploy_workflow.yml/badge.svg)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ZanderCowboy_multichoice&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=ZanderCowboy_multichoice)
[![codecov](https://codecov.io/gh/ZanderCowboy/multichoice/graph/badge.svg?token=1DW57BV8D5)](https://codecov.io/gh/ZanderCowboy/multichoice)
![GitHub License](https://img.shields.io/github/license/ZanderCowboy/multichoice)

## 📱 Download

[<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" height="80">](https://play.google.com/store/apps/details?id=com.zandercowboy.multichoice)

## 📖 Description

Multichoice is a versatile Flutter application that helps users manage and organize their choices across different categories. Built with modern Flutter architecture and following best practices, it provides an intuitive interface for creating, editing, and managing multiple choice items.

## ✨ Features

- **Intuitive UI**: Modern, responsive design with dark/light theme support
- **Data Management**: Create, edit, and organize multiple choice items
- **Search Functionality**: Quick search through your choices
- **Export/Import**: Backup and restore your data
- **Product Tour**: Interactive tutorial for new users
- **Feedback System**: Built-in feedback mechanism

## 📸 Screenshots

| Dark Theme | Light Theme |
|------------|-------------|
| <img alt="Reading Dark Horizontal" width=200 src=play_store/feature_graphic/reading/reading_home_view_horizontal_dark.png> | <img alt="Reading Light Horizontal" width=200 src=play_store/feature_graphic/reading/reading_home_view_horizontal_light.png> |
| <img alt="Reading Dark Vertical" width=200 src=play_store/feature_graphic/reading/reading_home_view_vertical_dark.png> | <img alt="Reading Light Vertical" width=200 src=play_store/feature_graphic/reading/reading_home_view_vertical_light.png> |

## 🗺️ Roadmap

### 🚀 Upcoming Ideas (v1.0)

#### Core Improvements

- **Categories**: Organize choices into custom categories
- **Favorites**: Mark frequently used choices as favorites
- **Sort Options**: Sort by name, date created, last used
- **Bulk Delete**: Select and delete multiple items at once
- **Search History**: Remember recent searches

#### User Experience

- **Custom Themes**: Additional color themes beyond dark/light
- **Home Screen Widget**: Quick access widget for Android
- **Keyboard Shortcuts**: Keyboard navigation for web/desktop
- **Offline Mode**: Work without internet connection
- **Data Export**: Export to CSV and JSON formats

#### Quality of Life

- **Undo/Redo**: Undo accidental deletions or changes
- **Auto-save**: Automatically save changes as you type
- **Import from Text**: Paste a list and auto-create choices
- **Duplicate Detection**: Warn about duplicate entries
- **Backup Reminders**: Remind users to backup their data
- **Calender Integration**: Have reminders in calender

### 🔮 Future Ideas (v2.0+)

#### Advanced Features

- **Cloud Backup**: Sync data across devices
- **Sharing**: Share choice lists with others
- **Templates**: Pre-built templates for common scenarios
- **Statistics**: Basic usage statistics and insights

#### Platform Enhancements

- **iOS App**: Native iOS application

*This roadmap is based on user feedback and development priorities. Features may be adjusted based on community needs.*

## 🚀 Getting Started

### Prerequisites

- Flutter version: 3.38.9
- Dart version: 3.10.8
- Android Studio / VS Code
- Windows (for Windows platform development)

### Quick Setup Links

- [Install Flutter](https://docs.flutter.dev/get-started/install)
- [Install VS Code](https://code.visualstudio.com/download)
- [Install Android Studio](https://developer.android.com/studio)

### Installation

1. **Clone the repository**
   ```sh
   git clone https://github.com/ZanderCowboy/multichoice.git
   cd apps/multichoice
   ```

2. **Install dependencies and build**
   ```sh
   dart pub global activate melos
   melos bootstrap
   melos build
   ```

   **Note**: If you encounter permissions issues, run:
   ```sh
   sudo chown -R ${whoami}:${whoami} /flutter
   ```
   or
   ```sh
   sudo chown -R node:node /flutter
   ```

3. **Configure platforms**
   ```sh
   flutter config --list
   ```
   Enable/disable platforms as needed (Android, Web, Windows).

4. **Run the application**
   ```sh
   melos run --scope=multichoice flutter run
   ```

### VS Code Setup

The project includes a `.vscode/launch.json` configuration for easy debugging:

- **multichoice**: Standard debug mode
- **multichoice (profile mode)**: Performance profiling
- **multichoice (release mode)**: Release mode testing
- **Run Integration Test with Emulator**: Integration testing

Simply press `F5` or use the Run and Debug panel in VS Code to start debugging.

## 🏗️ Project Structure

```sh
multichoice/
├── apps/
│   └── multichoice/          # Main Flutter application
├── packages/
│   ├── core/                 # Core business logic
│   ├── models/               # Data models
│   ├── theme/                # App theming
│   └── ui_kit/               # Reusable UI components
├── docs/                     # Documentation
└── play_store/               # Store assets
```

## 📚 Important Files

### README Files

- **[Main App README](apps/multichoice/README.md)** - Detailed documentation for the main Flutter application
- **[Core Package README](packages/core/README.md)** - Documentation for the core business logic package
- **[Models Package README](packages/models/README.md)** - Documentation for data models package
- **[Theme Package README](packages/theme/README.md)** - Documentation for app theming package
- **[UI Kit Package README](packages/ui_kit/README.md)** - Documentation for reusable UI components
- **[Workflows README](docs/workflows/README.md)** - Documentation for development workflows

### Changelog Files

- **[Main Changelog](CHANGELOG.md)** - Project-wide changes and releases
- **[App Changelog](apps/multichoice/CHANGELOG.md)** - Changes specific to the main application
- **[Core Package Changelog](packages/core/CHANGELOG.md)** - Changes to the core business logic
- **[Models Package Changelog](packages/models/CHANGELOG.md)** - Changes to data models
- **[Theme Package Changelog](packages/theme/CHANGELOG.md)** - Changes to app theming
- **[UI Kit Package Changelog](packages/ui_kit/CHANGELOG.md)** - Changes to UI components

### Documentation

- **[Integration Tests Setup](docs/setting-up-integration-tests.md)** - Guide for setting up integration tests
- **[Firebase Functions Setup](docs/setting-up-firebase-functions.md)** - Guide for Firebase Functions configuration
- **[Using Wrappers in Code](docs/using-wrappers-in-code.md)** - Documentation on wrapper usage
- **[VS Code Configuration](docs/explaining-the-vscode-folder.md)** - Explanation of VS Code setup
- **[Batch Scripts](docs/explaining-the-bat-scripts.md)** - Documentation for automation scripts

> For any additional documentation, refer to `docs` folder

## 🧪 Testing

Run tests using melos:

```sh
# Run all tests
melos test:all

# Run specific test suites
melos test:core
melos test:multichoice
melos test:integration

# Generate coverage reports
melos coverage:all
melos coverage:core
melos coverage:multichoice
```

For integration tests:
```sh
melos test:integration
```

## 📋 Development Workflow

### Versioning

<!-- TODO: Update using latest way -->
Every PR from `develop` into `main` must have one of these labels:
- `patch`: Fixes, hot-fixes, and patches
- `minor`: New features
- `major`: Major releases or significant changes

**Note**: If no label is provided, `patch` will be used by default.

### CI/CD Pipeline - needs updating

- **Linting**: Runs on push to any branch and on PRs
- **Building**: Runs on PRs from feature to develop
- **Tag and Release**: Runs on PRs from develop to main
- **Deploy**: Runs on push to main

## 🔧 Configuration

### config.yml

Located in the root directory, contains project configuration settings.

### Makefile

Provides convenient commands for common development tasks.

### .scripts folder

Contains automation scripts for various development workflows.

## 🌐 Links

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-white.svg)](https://sonarcloud.io/summary/new_code?id=ZanderCowboy_multichoice)

[Code Coverage](https://codecov.io/gh/ZanderCowboy/multichoice)

[Changelog](CHANGELOG.md)

## 🐛 Known Issues & Fixes

### Android Gradle Upgrade

If you encounter Android Gradle issues, ensure you're using the latest compatible versions.

## 📄 License

This project is licensed under the terms specified in the LICENSE file.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request into `develop` branch

## 📞 Support

If you encounter any issues or have questions, please:
1. Check the [existing issues](https://github.com/ZanderCowboy/multichoice/issues)
2. Create a new issue with detailed information
3. Use the in-app feedback feature
