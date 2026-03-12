# Setting Up DEV and PROD Environments

This guide will help you create separate development and production environments so you can safely develop new features without breaking your live app on Google Play Store.

## Table of Contents

1. [Overview](#overview)
2. [What You'll Need](#what-youll-need)
3. [Firebase Setup](#firebase-setup)
4. [Android App Configuration](#android-app-configuration)
5. [Google Play Console Setup](#google-play-console-setup)
6. [Environment Configuration](#environment-configuration)
7. [CI/CD Pipeline Updates](#cicd-pipeline-updates)
8. [Testing Strategy](#testing-strategy)
9. [Deployment Flow](#deployment-flow)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

## Overview

Your current setup has one app connecting to one Firebase project. We'll create:

- **DEV Environment**: For testing new features safely
- **PROD Environment**: Your current live app (minimal changes)

This approach allows you to:
- Test new features without affecting production users
- Use separate databases and configurations
- Deploy with confidence knowing dev testing was thorough
- Roll back easily if issues arise

## What You'll Need

### Firebase

- **Current Project**: `multichoice-412309` (will become PROD)
- **New Project**: `multichoice-dev` (for development)

### Google Play Console

- **Current App**: Your existing production app
- **Testing Tracks**: Internal testing, Alpha, Beta tracks for dev builds

### Development Tools

- Separate app configurations
- Environment-specific secrets
- Updated CI/CD workflows

## Firebase Setup

### Step 1: Create Dev Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it `multichoice-dev`
4. Follow setup wizard (enable Google Analytics if desired)

### Step 2: Configure Dev Project Services

Enable the same services as your production project:

#### Authentication

```bash
# Go to Authentication → Sign-in method
# Enable Google Sign-in
# Add SHA-1 fingerprints for dev builds
```

#### Firestore Database

```bash
# Go to Firestore Database → Create database
# Choose test mode initially
# Select same region as production
```

#### Cloud Functions

```bash
# Go to Functions
# Copy your production functions to dev project
```

#### App Distribution

```bash
# Go to App Distribution
# This will be used for internal testing
```

### Step 3: Set Up Firebase Projects Structure

```
Firebase Projects:
├── multichoice-412309 (PROD)
│   ├── Authentication (production users)
│   ├── Firestore (production data)
│   ├── Functions (production feedback)
│   └── App Distribution (release candidates)
└── multichoice-dev (DEV)
    ├── Authentication (test users)
    ├── Firestore (test data)
    ├── Functions (development feedback)
    └── App Distribution (dev builds)
```

## Android App Configuration

### Step 1: Create Environment-Specific Configurations

Create different build flavors in `apps/multichoice/android/app/build.gradle`:

```gradle
android {
    // ... existing config

    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "Multichoice Dev"
            manifestPlaceholders = [
                firebaseAppId: "your-dev-firebase-app-id"
            ]
        }
        
        prod {
            dimension "environment"
            resValue "string", "app_name", "Multichoice"
            manifestPlaceholders = [
                firebaseAppId: "your-prod-firebase-app-id"
            ]
        }
    }
    
    buildTypes {
        debug {
            debuggable true
            applicationIdSuffix ".debug"
        }
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 2: Create Environment-Specific Firebase Config

Create separate directories for Firebase configurations:

```
apps/multichoice/android/app/src/
├── dev/
│   └── google-services.json      # Dev Firebase config
├── prod/
│   └── google-services.json      # Prod Firebase config (current)
└── main/
    └── ... (existing files)
```

### Step 3: Update App Icons and Names

Create environment-specific app icons:

```
apps/multichoice/android/app/src/
├── dev/res/
│   ├── mipmap-hdpi/ic_launcher.png      # Dev icon (maybe with "DEV" badge)
│   ├── mipmap-mdpi/ic_launcher.png
│   └── ... (other densities)
└── prod/res/
    ├── mipmap-hdpi/ic_launcher.png      # Production icon
    └── ... (other densities)
```

### Step 4: Environment-Specific App Names

Update `apps/multichoice/android/app/src/main/res/values/strings.xml`:

```xml
<resources>
    <string name="app_name">@string/app_name</string>
</resources>
```

The actual names will come from the build flavors.

## Google Play Console Setup

### Option 1: Same App, Different Tracks (Recommended)

Use your existing app with different testing tracks:

1. **Internal Testing**: For dev builds
2. **Alpha**: For staging/RC builds  
3. **Beta**: For pre-production testing
4. **Production**: For live releases

### Option 2: Separate Apps (More Isolated)

Create a separate app for development:

1. Go to Google Play Console
2. Create new app: "Multichoice Dev"
3. Use different package name: `com.zander.multichoice.dev`
4. Set up completely separate from production

**Recommendation**: Use Option 1 (same app, different tracks) as it's simpler to manage.

## Environment Configuration

### Step 1: Create Environment Configuration Files

Create `apps/multichoice/lib/config/`

```
apps/multichoice/lib/config/
├── app_config.dart
├── dev_config.dart
└── prod_config.dart
```

**app_config.dart**:
```dart
abstract class AppConfig {
  static late AppConfig _instance;
  
  static AppConfig get instance => _instance;
  
  static void setInstance(AppConfig config) {
    _instance = config;
  }
  
  String get appName;
  String get apiBaseUrl;
  String get firebaseProjectId;
  bool get debugMode;
  String get environment;
}
```

**dev_config.dart**:
```dart
import 'app_config.dart';

class DevConfig implements AppConfig {
  @override
  String get appName => 'Multichoice Dev';
  
  @override
  String get apiBaseUrl => 'https://dev-api.multichoice.com';
  
  @override
  String get firebaseProjectId => 'multichoice-dev';
  
  @override
  bool get debugMode => true;
  
  @override
  String get environment => 'development';
}
```

**prod_config.dart**:
```dart
import 'app_config.dart';

class ProdConfig implements AppConfig {
  @override
  String get appName => 'Multichoice';
  
  @override
  String get apiBaseUrl => 'https://api.multichoice.com';
  
  @override
  String get firebaseProjectId => 'multichoice-412309';
  
  @override
  bool get debugMode => false;
  
  @override
  String get environment => 'production';
}
```

### Step 2: Update Main Entry Points

Create separate main files:

**apps/multichoice/lib/main_dev.dart**:
```dart
import 'package:flutter/material.dart';
import 'package:multichoice/bootstrap.dart';
import 'package:multichoice/config/dev_config.dart';
import 'package:multichoice/config/app_config.dart';

void main() async {
  AppConfig.setInstance(DevConfig());
  await bootstrap();
  runApp(const MyApp());
}
```

**apps/multichoice/lib/main_prod.dart**:
```dart
import 'package:flutter/material.dart';
import 'package:multichoice/bootstrap.dart';
import 'package:multichoice/config/prod_config.dart';
import 'package:multichoice/config/app_config.dart';

void main() async {
  AppConfig.setInstance(ProdConfig());
  await bootstrap();
  runApp(const MyApp());
}
```

**apps/multichoice/lib/main.dart** (update existing):
```dart
// Default to production
export 'main_prod.dart';
```

### Step 3: Update Firebase Options

Create environment-specific Firebase options:

**apps/multichoice/lib/firebase_options_dev.dart**:
```dart
// Generated from dev Firebase project
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'your-dev-web-api-key',
    appId: 'your-dev-web-app-id',
    messagingSenderId: 'your-dev-sender-id',
    projectId: 'multichoice-dev',
    // ... other dev config
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'your-dev-android-api-key',
    appId: 'your-dev-android-app-id',
    messagingSenderId: 'your-dev-sender-id',
    projectId: 'multichoice-dev',
    // ... other dev config
  );
  
  // ... iOS config
}
```

### Step 4: Update Bootstrap Configuration

Update `apps/multichoice/lib/bootstrap.dart`:

```dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with environment-specific options
  await Firebase.initializeApp(
    options: AppConfig.instance.environment == 'development'
        ? DevFirebaseOptions.currentPlatform
        : DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configure core dependencies
  await configureCoreDependencies();
  
  // ... rest of bootstrap
}
```

## CI/CD Pipeline Updates

### Step 1: Update GitHub Secrets

Add environment-specific secrets to your GitHub repository:

```bash
# Dev Environment
DEV_ANDROID_KEYSTORE_BASE64
DEV_ANDROID_KEYSTORE_PASSWORD
DEV_ANDROID_KEY_ALIAS
DEV_ANDROID_KEY_PASSWORD
DEV_FIREBASE_TOKEN
DEV_GOOGLE_SERVICES_JSON

# Prod Environment (existing)
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
FIREBASE_TOKEN
GOOGLE_SERVICES_JSON
```

### Step 2: Create Environment-Specific Workflows

Create `.github/workflows/dev-build.yml`:

```yaml
name: Dev Build and Deploy

on:
  push:
    branches: [ develop ]
  pull_request:
    branches: [ develop ]
  workflow_dispatch:

concurrency:
  group: dev-build-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-dev:
    runs-on: ubuntu-latest
    environment: development
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'
          
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          
      - name: Get dependencies
        run: |
          cd apps/multichoice
          flutter pub get
          
      - name: Run tests
        run: |
          cd apps/multichoice
          flutter test
          
      - name: Create dev google-services.json
        run: |
          echo "${{ secrets.DEV_GOOGLE_SERVICES_JSON }}" | base64 --decode > apps/multichoice/android/app/src/dev/google-services.json
          
      - name: Create dev keystore
        run: |
          echo "${{ secrets.DEV_ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > apps/multichoice/android/app/dev-keystore.jks
          
      - name: Create dev key.properties
        run: |
          cat > apps/multichoice/android/key.properties << EOF
          storePassword=${{ secrets.DEV_ANDROID_KEYSTORE_PASSWORD }}
          keyPassword=${{ secrets.DEV_ANDROID_KEY_PASSWORD }}
          keyAlias=${{ secrets.DEV_ANDROID_KEY_ALIAS }}
          storeFile=dev-keystore.jks
          EOF
          
      - name: Build dev APK
        run: |
          cd apps/multichoice
          flutter build apk --flavor dev --target lib/main_dev.dart
          
      - name: Upload to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.DEV_FIREBASE_APP_ID }}
          serviceCredentialsFileContent: ${{ secrets.DEV_FIREBASE_SERVICE_ACCOUNT }}
          groups: testers
          file: apps/multichoice/build/app/outputs/flutter-apk/app-dev-release.apk
```

### Step 3: Update Production Workflow

Update `.github/workflows/production-build.yml`:

```yaml
name: Production Build and Deploy

on:
  push:
    branches: [ main ]
  workflow_dispatch:

# ... (similar structure but with prod secrets and configs)

      - name: Build prod APK
        run: |
          cd apps/multichoice
          flutter build apk --flavor prod --target lib/main_prod.dart
          
      - name: Build prod AAB
        run: |
          cd apps/multichoice
          flutter build appbundle --flavor prod --target lib/main_prod.dart
```

## Testing Strategy

### Development Testing

1. **Local Testing**: Use dev flavor locally
2. **Firebase App Distribution**: Share dev builds with team
3. **Internal Testing**: Use Google Play internal track

### Staging Testing

1. **Alpha Track**: For broader team testing
2. **Beta Track**: For external testers
3. **Pre-production**: Final testing before prod

### Production Deployment

1. **Gradual Rollout**: Start with small percentage
2. **Monitor**: Check crash reports and user feedback
3. **Full Rollout**: Increase to 100% if stable

## Deployment Flow

```
Feature Development → Local Dev Testing → Dev Build + Firebase Distribution → Team Testing
                                                                                     ↓
Production Build ← Merge to main ← Ready for Prod? ← Alpha/Beta Testing ← Merge to staging
       ↓
Google Play Production
```

## Best Practices

### 1. Database Separation

- **Dev**: Use test data, can be reset frequently
- **Prod**: Real user data, handle with care

### 2. Feature Flags

Consider implementing feature flags:
```dart
class FeatureFlags {
  static bool get newFeatureEnabled {
    return AppConfig.instance.environment == 'development' || 
           AppConfig.instance.debugMode;
  }
}
```

### 3. Logging and Analytics

```dart
void logEvent(String event, Map<String, dynamic> parameters) {
  if (AppConfig.instance.environment == 'development') {
    print('Dev Event: $event - $parameters');
  } else {
    // Send to production analytics
    FirebaseAnalytics.instance.logEvent(name: event, parameters: parameters);
  }
}
```

### 4. Error Handling

```dart
void handleError(dynamic error, StackTrace stackTrace) {
  if (AppConfig.instance.environment == 'development') {
    print('Dev Error: $error\n$stackTrace');
  } else {
    // Send to production crash reporting
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
```

### 5. Version Management

- **Dev**: Use build numbers for internal tracking
- **Prod**: Follow semantic versioning strictly

## Troubleshooting

### Build Errors

**Issue**: Flavor not found
```bash
# Solution: Ensure build.gradle has correct flavor configuration
flutter build apk --flavor dev --target lib/main_dev.dart
```

**Issue**: Firebase configuration not found
```bash
# Solution: Verify google-services.json is in correct flavor directory
apps/multichoice/android/app/src/dev/google-services.json
```

### Firebase Issues

**Issue**: Wrong Firebase project
```bash
# Solution: Check firebase_options.dart has correct project ID
# Verify AppConfig is setting correct environment
```

**Issue**: Authentication not working
```bash
# Solution: Ensure SHA-1 fingerprints are added to both Firebase projects
# For dev builds:
cd apps/multichoice/android
./gradlew signingReport
```

### Google Play Issues

**Issue**: Upload conflicts
```bash
# Solution: Ensure different version codes for different environments
# Use applicationIdSuffix for dev builds
```

### Environment Configuration

**Issue**: Wrong environment detected
```bash
# Solution: Verify main_dev.dart and main_prod.dart are correctly setting config
# Check bootstrap.dart is using correct Firebase options
```

## Next Steps

1. **Implement the Firebase setup** first (create dev project)
2. **Configure build flavors** in Android
3. **Test locally** with both dev and prod flavors
4. **Update CI/CD workflows** gradually
5. **Train team** on new deployment process
6. **Document** any project-specific customizations

## Resources

- [Firebase Project Management](https://firebase.google.com/docs/projects/learn-more)
- [Android Build Variants](https://developer.android.com/studio/build/build-variants)
- [Google Play Testing Tracks](https://support.google.com/googleplay/android-developer/answer/9845334)
- [Flutter Flavors](https://docs.flutter.dev/deployment/flavors)
- [GitHub Actions Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

---

This setup will give you confidence to develop new features knowing your production app is protected. Start with the Firebase setup and gradually implement each section.

graph TB
    subgraph "DEV Environment"
        A["Firebase Project:<br/>multichoice-dev"]
        B["App Package:<br/>com.zander.multichoice.dev"]
        C["Google Play:<br/>Internal Testing Track"]
        D["Database:<br/>Test Data"]
    end

    subgraph "PROD Environment"
        E["Firebase Project:<br/>multichoice-412309"]
        F["App Package:<br/>com.zander.multichoice"]
        G["Google Play:<br/>Production Track"]
        H["Database:<br/>Real User Data"]
    end
    
    subgraph "Development Flow"
        I["Feature Development"] --> J["Local Dev Testing"]
        J --> K["Dev Build"]
        K --> L["Firebase App Distribution"]
        L --> M["Team Testing"]
        M --> N{"Ready for<br/>Production?"}
        N -->|No| I
        N -->|Yes| O["Production Build"]
        O --> P["Google Play Store"]
    end
    
    K --> A
    K --> B
    K --> C
    K --> D
    
    O --> E
    O --> F
    O --> G
    O --> H
