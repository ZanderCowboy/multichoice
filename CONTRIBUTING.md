# 🚀 Contributing to Multichoice

> **Making contribution cool and straightforward!** 🎯

Welcome to the **Multichoice** project! We're excited to have you contribute to this awesome Flutter application. This guide will help you understand our workflow, standards, and how to make meaningful contributions.

## 🌟 Quick Start

1. **Fork & Clone**
   ```bash
   git clone https://github.com/ZanderCowboy/multichoice.git
   cd multichoice
   ```

2. **Setup Development Environment**
   ```bash
   # Install dependencies
   melos get
   
   # Run the app
   flutter run
   ```

3. **Create a Feature Branch**
   ```bash
   git checkout -b {issue-number}-{feature-description}
   # Example: git checkout -b 42-add-dark-mode-toggle
   ```

## 📋 Project Structure & Architecture

This project follows **Clean Architecture** principles with a monorepo structure:

```
multichoice/
├── apps/
│   └── multichoice/          # Main Flutter app
├── packages/
│   ├── core/                 # Core business logic
│   ├── models/               # Data models & DTOs
│   ├── theme/                # Theming system
│   └── ui_kit/              # Reusable UI components
└── docs/                    # Documentation & tickets
```

### 🏗️ Architecture Layers
- **Presentation**: UI components, pages, and widgets
- **Application**: Business logic, use cases, and state management
- **Domain**: Core entities and repository interfaces
- **Data**: Repository implementations and data sources

## 🎯 Contributing Workflow

### 1. 📝 Issue Creation & Assignment

- **Browse existing issues**: Check [Issues](https://github.com/ZanderCowboy/multichoice/issues) first
- **Create detailed issues**: Use our issue templates for consistency
- **Get assigned**: Comment on issues you'd like to work on
- **One issue at a time**: Focus on quality over quantity

### 2. 🌿 Branch Strategy

We follow **Git Flow** with these branches:

```
main         # 🏭 Production releases
├── rc       # 🧪 Release candidates (staging)
├── develop  # 🔄 Integration branch
└── feature/ # 🚀 Feature branches
```

**Branch Naming Convention:**
```
{issue-number}-{kebab-case-description}
```

**Examples:**
- `27-setup-workflows`
- `119-implement-dark-mode`
- `42-add-integration-tests`

### 3. 🏷️ Version Management

We use **Semantic Versioning** (MAJOR.MINOR.PATCH+BUILD) with PR labels:

| Label | Version Bump | Usage |
|-------|--------------|-------|
| `major` | 1.0.0 → 2.0.0 | Breaking changes |
| `minor` | 1.0.0 → 1.1.0 | New features |
| `patch` | 1.0.0 → 1.0.1 | Bug fixes |
| `no-build` | No change | Documentation, etc. |

### 4. 🔄 Pull Request Process

1. **Create PR to `develop`** branch
2. **Add appropriate labels** (major/minor/patch)
3. **Fill out PR template** completely
4. **Ensure CI passes** (tests, linting, build)
5. **Request review** from maintainers
6. **Address feedback** promptly

### 5. 🚀 Release Flow

```
develop → rc (Release Candidate) → main (Production)
```

- **RC builds**: Automatic via staging workflow
- **Production**: Manual promotion from RC

## 📚 Documentation Standards

### Issue Documentation

Every completed issue should have documentation in `/docs/` following this structure:

```markdown
# [Feature Name](https://github.com/ZanderCowboy/multichoice/issues/{number})

## Ticket: [{number}](https://github.com/ZanderCowboy/multichoice/issues/{number})

### branch: `{branch-name}`

### Overview
Brief description of what this ticket accomplishes.

### What was done
- [X] Implemented feature A
- [X] Added tests for component B
- [X] Updated documentation

### What needs to be done
- [ ] Follow-up task if any

### Resources
- [Relevant link](https://example.com)
```

## 🧪 Testing Requirements

### ✅ Required Tests

- **Unit Tests**: For business logic and utilities
- **Widget Tests**: For UI components
- **Integration Tests**: For complete user flows

### 🏃‍♂️ Running Tests

```bash
# Unit tests
flutter test

# Widget tests (specific package)
cd packages/core && flutter test

# Integration tests
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart

# Coverage
flutter test --coverage
```

### 📊 Coverage Requirements

- **Minimum**: 80% code coverage
- **Core package**: 90% coverage required
- **UI components**: Visual testing preferred

## 🎨 Code Standards

### 🔧 Linting & Formatting

```bash
# Analyze code
flutter analyze

# Format code
dart format .

# Fix issues
dart fix --apply
```

### 📝 Code Style

- **Follow Dart conventions**: Use `dart format`
- **Meaningful names**: Clear, descriptive variable/function names
- **Documentation**: Document public APIs with `///`
- **Comments**: Explain complex logic, not obvious code

### 🏗️ Architecture Guidelines

```dart
// ✅ Good: Clear separation of concerns
class UserRepository implements IUserRepository {
  @override
  Future<User> getUser(String id) async {
    // Implementation
  }
}

// ❌ Avoid: Business logic in widgets
class UserWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Don't put business logic here
  }
}
```

## 🛠️ Development Tools

### 🐳 Dev Container

We provide a complete development environment:

```bash
# Using Dev Container
code .
# Select "Reopen in Container" when prompted
```

### 🔧 Recommended Extensions

- **Flutter**: Official Flutter extension
- **Dart**: Dart language support
- **GitLens**: Git visualization
- **Error Lens**: Inline error display

## 🚦 CI/CD Pipeline

### 🔄 Automated Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **Linting** | Every PR | Code quality checks |
| **Build** | Every PR | Test & build verification |
| **Develop** | PR to `develop` | Deploy to Firebase App Distribution |
| **Staging** | PR to `rc` | Deploy to Google Play Internal |
| **Production** | PR to `main` | Production release |

### ✨ What Gets Automated

- 🔍 **Code Analysis**: Linting and static analysis
- 🧪 **Testing**: Unit, widget, and integration tests
- 📦 **Building**: Android APK/AAB generation
- 🚀 **Deployment**: Automatic app distribution
- 🏷️ **Versioning**: Automatic version bumping
- 📊 **Coverage**: Code coverage reporting

## 🎯 Issue Types & Templates

### 🐛 Bug Reports
Use for: Fixing existing functionality
**Template**: Bug report template

### ✨ Feature Requests  
Use for: New functionality
**Template**: Feature request template

### 📚 Documentation
Use for: Improving docs
**Template**: Documentation template

### 🔧 Maintenance
Use for: Refactoring, dependencies
**Template**: Maintenance template

## 🏆 Recognition

### 🌟 Hall of Contributors

Outstanding contributors get:
- **Recognition** in release notes
- **Contributor badge** on profile
- **Priority** on issue assignments
- **Mentorship** opportunities

### 📈 Contribution Levels

| Level | Contributions | Benefits |
|-------|--------------|----------|
| **Rookie** | 1-5 PRs | Welcome package |
| **Contributor** | 6-15 PRs | Priority reviews |
| **Champion** | 16+ PRs | Mentor role |

## 🤝 Community Guidelines

### ✨ Be Awesome

- **Be respectful**: Treat everyone with kindness
- **Be constructive**: Provide helpful feedback
- **Be patient**: Reviews take time
- **Be inclusive**: Welcome all skill levels

### 💬 Communication

- **Issues**: Technical discussions
- **Discussions**: General questions & ideas
- **Discord**: Real-time chat (coming soon!)

## 📞 Need Help?

### 🆘 Getting Support

1. **Check existing issues**: Someone might have asked already
2. **Search documentation**: Look in `/docs/` folder  
3. **Create an issue**: Use appropriate template
4. **Join discussions**: Share ideas and get help

### 📧 Contact

- **Project Maintainer**: [@ZanderCowboy](https://github.com/ZanderCowboy)
- **Issues**: [GitHub Issues](https://github.com/ZanderCowboy/multichoice/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ZanderCowboy/multichoice/discussions)

---

## 🎉 Ready to Contribute?

1. 🍴 **Fork** the repository
2. 🔍 **Find** an issue that interests you
3. 💬 **Comment** to get assigned
4. 🚀 **Code** your solution
5. 📝 **Document** your changes
6. 🔄 **Submit** a PR

**Let's build something amazing together!** 🚀✨

---

> **Pro Tip**: Start with issues labeled `good first issue` or `help wanted` if you're new to the project! 