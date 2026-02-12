# DEV/PROD Environment Implementation Checklist

Use this checklist to systematically implement the DEV and PROD environment setup. Check off each item as you complete it.

## Phase 1: Firebase Setup (Critical First Step)

### [ ] Create Dev Firebase Project

- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Create new project: `multichoice-dev`
- [ ] Enable Google Analytics (optional)

### [ ] Configure Services in Dev Project

- [ ] **Authentication**
  - [ ] Enable Google Sign-in
  - [ ] Add SHA-1 fingerprints for dev builds
- [ ] **Firestore Database**
  - [ ] Create database (start in test mode)
  - [ ] Select same region as production
- [ ] **Cloud Functions**
  - [ ] Set up functions directory
  - [ ] Copy feedback function from production
- [ ] **App Distribution**
  - [ ] Enable App Distribution
  - [ ] Create tester groups

### [ ] Add Android App to Dev Project

- [ ] Add Android app with package name: `com.zander.multichoice.dev`
- [ ] Download `google-services.json` for dev

## Phase 2: Android Configuration

### [ ] Update build.gradle

- [ ] Add flavor dimensions in `apps/multichoice/android/app/build.gradle`
- [ ] Create `dev` and `prod` flavors
- [ ] Set application ID suffixes
- [ ] Configure app names and manifest placeholders

### [ ] Create Firebase Config Directories

```
apps/multichoice/android/app/src/
├── dev/google-services.json     # New dev config
├── prod/google-services.json    # Move existing config here
└── main/... (existing files)
```

### [ ] Create Environment-Specific Icons (Optional)

- [ ] Create dev app icon with "DEV" badge
- [ ] Place in `apps/multichoice/android/app/src/dev/res/mipmap-*/`
- [ ] Copy production icons to `apps/multichoice/android/app/src/prod/res/mipmap-*/`

## Phase 3: Flutter App Configuration

### [ ] Create Config Classes

- [ ] Create `apps/multichoice/lib/config/app_config.dart`
- [ ] Create `apps/multichoice/lib/config/dev_config.dart`
- [ ] Create `apps/multichoice/lib/config/prod_config.dart`

### [ ] Create Environment-Specific Main Files

- [ ] Create `apps/multichoice/lib/main_dev.dart`
- [ ] Create `apps/multichoice/lib/main_prod.dart`
- [ ] Update existing `apps/multichoice/lib/main.dart`

### [ ] Create Firebase Options Files

- [ ] Generate `apps/multichoice/lib/firebase_options_dev.dart` using Firebase CLI
- [ ] Update existing `firebase_options.dart` for production

### [ ] Update Bootstrap

- [ ] Modify `apps/multichoice/lib/bootstrap.dart` to use environment-specific Firebase options
- [ ] Add AppConfig initialization

## Phase 4: Local Testing

### [ ] Test Dev Build Locally

```bash
cd apps/multichoice
flutter run --flavor dev --target lib/main_dev.dart
```

### [ ] Test Prod Build Locally

```bash
cd apps/multichoice
flutter run --flavor prod --target lib/main_prod.dart
```

### [ ] Verify Environment Separation

- [ ] Check app names are different
- [ ] Verify different Firebase projects are being used
- [ ] Test authentication with different Firebase projects

## Phase 5: CI/CD Pipeline Updates

### [ ] Update GitHub Secrets

Add new secrets for dev environment:
- [ ] `DEV_ANDROID_KEYSTORE_BASE64`
- [ ] `DEV_ANDROID_KEYSTORE_PASSWORD`
- [ ] `DEV_ANDROID_KEY_ALIAS`
- [ ] `DEV_ANDROID_KEY_PASSWORD`
- [ ] `DEV_FIREBASE_TOKEN`
- [ ] `DEV_GOOGLE_SERVICES_JSON`
- [ ] `DEV_FIREBASE_APP_ID`
- [ ] `DEV_FIREBASE_SERVICE_ACCOUNT`

### [ ] Create Dev Workflow

- [ ] Create `.github/workflows/dev-build.yml`
- [ ] Configure to trigger on `develop` branch
- [ ] Set up Firebase App Distribution upload

### [ ] Update Existing Workflows

- [ ] Update production workflow to use `--flavor prod`
- [ ] Update staging workflow if needed
- [ ] Test workflows with manual triggers

## Phase 6: Google Play Console Setup

### [ ] Choose Strategy

- [ ] **Option A**: Use existing app with different tracks (recommended)
  - [ ] Set up Internal Testing track for dev builds
  - [ ] Set up Alpha track for staging
  - [ ] Keep Production track for live releases
- [ ] **Option B**: Create separate dev app (more isolation)
  - [ ] Create new app in Google Play Console
  - [ ] Set up separate app configuration

### [ ] Configure Testing

- [ ] Add internal testers
- [ ] Set up testing groups
- [ ] Configure release notes templates

## Phase 7: Testing and Validation

### [ ] End-to-End Testing

- [ ] Build and deploy dev version via CI/CD
- [ ] Test Firebase App Distribution
- [ ] Verify data isolation (dev vs prod Firebase)
- [ ] Test authentication flows
- [ ] Verify app icons and names

### [ ] Production Validation

- [ ] Ensure production builds still work
- [ ] Verify no impact on existing users
- [ ] Test production CI/CD pipeline

## Phase 8: Team Onboarding

### [ ] Documentation

- [ ] Share environment setup guide with team
- [ ] Document new development workflow
- [ ] Create troubleshooting guide for common issues

### [ ] Training

- [ ] Train team on new build commands
- [ ] Explain when to use dev vs prod
- [ ] Set up team access to Firebase projects

## Phase 9: Monitoring and Optimization

### [ ] Set Up Monitoring

- [ ] Monitor Firebase usage for both projects
- [ ] Set up alerts for build failures
- [ ] Track deployment metrics

### [ ] Optimization

- [ ] Review and optimize build times
- [ ] Fine-tune testing strategies
- [ ] Gather team feedback and iterate

## Quick Commands Reference

### Local Development

```bash
# Run dev build locally
flutter run --flavor dev --target lib/main_dev.dart

# Run prod build locally  
flutter run --flavor prod --target lib/main_prod.dart

# Build dev APK
flutter build apk --flavor dev --target lib/main_dev.dart

# Build prod APK
flutter build apk --flavor prod --target lib/main_prod.dart
```

### Firebase CLI

```bash
# Switch to dev project
firebase use multichoice-dev

# Switch to prod project
firebase use multichoice-412309

# Deploy functions to current project
firebase deploy --only functions
```

### Android Gradle

```bash
# Get SHA-1 for dev builds
cd apps/multichoice/android
./gradlew signingReport
```

## Rollback Plan

If something goes wrong, here's how to quickly rollback:

### [ ] Emergency Rollback Steps

1. [ ] Revert any changes to existing `main.dart`
2. [ ] Remove flavor configurations from `build.gradle`
3. [ ] Move `google-services.json` back to original location
4. [ ] Revert CI/CD workflow changes
5. [ ] Test production build works as before

## Success Criteria

You'll know the setup is successful when:
- [ ] You can build both dev and prod flavors locally
- [ ] Dev builds connect to dev Firebase project
- [ ] Prod builds connect to prod Firebase project
- [ ] CI/CD deploys dev builds to Firebase App Distribution
- [ ] Team can test features safely in dev environment
- [ ] Production app remains unaffected

## Common Issues and Solutions

### Build Errors

- **Flavor not found**: Check `build.gradle` syntax
- **Firebase config missing**: Verify file locations
- **Keystore issues**: Check secrets and file paths

### Runtime Issues

- **Wrong Firebase project**: Verify `AppConfig` setup
- **Authentication fails**: Check SHA-1 fingerprints
- **Data not syncing**: Confirm Firestore rules

---

**Pro Tip**: Start with Phase 1 (Firebase setup) and test each phase thoroughly before moving to the next. This incremental approach reduces risk and makes troubleshooting easier.
