# Implementing Login Functionality with Google Sign-In

This guide provides a comprehensive approach to implementing authentication with Google Sign-In in your multichoice app, following the existing clean architecture patterns.

## Table of Contents

1. [Overview](#overview)
2. [Current Architecture Analysis](#current-architecture-analysis)
3. [Prerequisites](#prerequisites)
4. [Implementation Steps](#implementation-steps)
5. [Firebase Configuration](#firebase-configuration)
6. [Testing](#testing)
7. [Security Considerations](#security-considerations)
8. [Troubleshooting](#troubleshooting)
9. [Next Steps](#next-steps)
10. [Resources](#resources)

## Overview

Your app already has a solid foundation for authentication with:
- Firebase Core integration
- Clean architecture with dependency injection (GetIt + Injectable)
- BLoC pattern for state management
- Existing Session service for token management
- Firebase project configured (`multichoice-412309`)

This implementation will extend the existing architecture to support Google Sign-In while maintaining the established patterns.

Remember to have a deregister option.

## Current Architecture Analysis

### Existing Components

- **Session Service**: Basic token storage in SharedPreferences
- **Dependency Injection**: GetIt with Injectable for service management
- **Firebase Integration**: Core Firebase already configured
- **Clean Architecture**: Separation of concerns with interfaces and implementations

### What We'll Add

- Firebase Authentication
- Google Sign-In integration
- Enhanced user management
- Authentication state management with BLoC
- User profile data models

## Prerequisites

### 1. Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `multichoice-412309`
3. Enable Authentication:
   - Go to Authentication → Sign-in method
   - Enable Google Sign-in
   - Add your app's SHA-1 fingerprint for Android

### 2. Dependencies to Add

Add these to `apps/multichoice/pubspec.yaml`:
```yaml
dependencies:
  firebase_auth: ^5.3.3
  google_sign_in: ^6.2.1
  # ... existing dependencies
```

Add these to `packages/core/pubspec.yaml`:
```yaml
dependencies:
  firebase_auth: ^5.3.3
  # ... existing dependencies
```

### 3. Android Configuration

Update `apps/multichoice/android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        // ... existing config
        multiDexEnabled true
    }
}

dependencies {
    // ... existing dependencies
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

### 4. iOS Configuration

Update `apps/multichoice/ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## Implementation Steps

### Step 1: Create User Models

Create `packages/models/lib/src/models/user_model.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@collection
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

Create `packages/models/lib/src/dto/user_dto.dart`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);
}
```

### Step 2: Create Authentication Service Interface

Create `packages/core/lib/src/services/interfaces/i_auth_service.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

abstract class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}

abstract class IAuthService {
  Future<Either<AuthException, UserDTO>> signInWithGoogle();
  Future<Either<AuthException, void>> signOut();
  Future<Either<AuthException, UserDTO?>> getCurrentUser();
  Stream<UserDTO?> get authStateChanges;
}
```

### Step 3: Create Authentication Service Implementation

Create `packages/core/lib/src/services/implementations/auth_service.dart`:
```dart
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:core/src/services/interfaces/i_auth_service.dart';

@LazySingleton(as: IAuthService)
class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthService(this._firebaseAuth, this._googleSignIn);

  @override
  Future<Either<AuthException, UserDTO>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(AuthException('Google sign-in was cancelled'));
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);
      
      final user = userCredential.user;
      if (user == null) {
        return Left(AuthException('Failed to sign in with Google'));
      }

      final userDTO = UserDTO(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
      );

      return Right(userDTO);
    } catch (e) {
      return Left(AuthException('Google sign-in failed: $e'));
    }
  }

  @override
  Future<Either<AuthException, void>> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } catch (e) {
      return Left(AuthException('Sign out failed: $e'));
    }
  }

  @override
  Future<Either<AuthException, UserDTO?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Right(null);
      }

      final userDTO = UserDTO(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
      );

      return Right(userDTO);
    } catch (e) {
      return Left(AuthException('Failed to get current user: $e'));
    }
  }

  @override
  Stream<UserDTO?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      
      return UserDTO(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoURL: user.photoURL,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
      );
    });
  }
}
```

### Step 4: Create Authentication BLoC

Create `packages/core/lib/src/application/auth/auth_bloc.dart`:
```dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:core/src/services/interfaces/i_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService _authService;

  AuthBloc(this._authService) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        signInWithGoogle: (e) async => await _onSignInWithGoogle(emit),
        signOut: (e) async => await _onSignOut(emit),
        checkAuthState: (e) async => await _onCheckAuthState(emit),
        authStateChanged: (e) async => await _onAuthStateChanged(e, emit),
      );
    });

    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      add(AuthEvent.authStateChanged(user));
    });
  }

  Future<void> _onSignInWithGoogle(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    
    final result = await _authService.signInWithGoogle();
    
    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onSignOut(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    
    final result = await _authService.signOut();
    
    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onCheckAuthState(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    
    final result = await _authService.getCurrentUser();
    
    result.fold(
      (failure) => emit(AuthState.error(failure.toString())),
      (user) => user != null 
          ? emit(AuthState.authenticated(user))
          : emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthState.authenticated(event.user!));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }
}
```

Create `packages/core/lib/src/application/auth/auth_event.dart`:
```dart
part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signInWithGoogle() = SignInWithGoogle;
  const factory AuthEvent.signOut() = SignOut;
  const factory AuthEvent.checkAuthState() = CheckAuthState;
  const factory AuthEvent.authStateChanged(UserDTO? user) = AuthStateChanged;
}
```

Create `packages/core/lib/src/application/auth/auth_state.dart`:
```dart
part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(UserDTO user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(String message) = Error;
}
```

### Step 5: Update Dependency Injection

Update `packages/core/lib/src/injectable_module.dart`:
```dart
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:models/models.dart' show TabsSchema, EntrySchema, UserSchema;
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectableModule {
  @preResolve
  Future<Isar> get isar async {
    final directory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        TabsSchema,
        EntrySchema,
        UserSchema, // Add UserSchema
      ],
      directory: directory.path,
      name: 'MultichoiceDB',
    );

    return isar;
  }

  @preResolve
  Future<SharedPreferences> get sharedPref async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref;
  }

  @lazySingleton
  FilePicker get filePicker => FilePicker.platform;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();
}
```

### Step 6: Create Login UI

Create `apps/multichoice/lib/presentation/auth/login_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:theme/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.message),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                const Icon(
                  Icons.apps,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Multichoice',
                  style: context.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Google Sign-In Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: state.maybeWhen(
                          loading: () => null,
                          orElse: () => () {
                            context.read<AuthBloc>().add(
                              const AuthEvent.signInWithGoogle(),
                            );
                          },
                        ),
                        icon: state.maybeWhen(
                          loading: () => const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          orElse: () => const Icon(Icons.login),
                        ),
                        label: Text(
                          state.maybeWhen(
                            loading: () => 'Signing in...',
                            orElse: () => 'Sign in with Google',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Step 7: Create Authentication Wrapper

Create `apps/multichoice/lib/presentation/auth/auth_wrapper.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:multichoice/presentation/auth/login_page.dart';
import 'package:multichoice/layouts/home_layout/home_layout.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          loading: (_) => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          authenticated: (_) => const HomeLayout(),
          unauthenticated: (_) => const LoginPage(),
          error: (error) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${error.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthEvent.checkAuthState(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
```

### Step 8: Update Main App

Update `apps/multichoice/lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:multichoice/bootstrap.dart';
import 'package:multichoice/presentation/auth/auth_wrapper.dart';

void main() async {
  await bootstrap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => coreSl<AuthBloc>()
            ..add(const AuthEvent.checkAuthState()),
        ),
        // Add other BLoCs as needed
      ],
      child: MaterialApp(
        title: 'Multichoice',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
```

### Step 9: Add Sign Out to Drawer

Update your existing drawer to include sign out functionality:
```dart
// In your drawer widget
ListTile(
  leading: const Icon(Icons.logout),
  title: const Text('Sign Out'),
  onTap: () {
    context.read<AuthBloc>().add(const AuthEvent.signOut());
  },
),
```

## Firebase Configuration

### 1. Enable Google Sign-In in Firebase Console

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable Google provider
3. Add your app's SHA-1 fingerprint for Android

### 2. Get SHA-1 Fingerprint

```bash
cd apps/multichoice/android
./gradlew signingReport
```

### 3. Update google-services.json

Download the updated `google-services.json` from Firebase Console and replace the existing one in `apps/multichoice/android/app/`.

## Testing

### 1. Unit Tests

Create `packages/core/test/src/services/auth_service_test.dart`:
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockIAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockIAuthService();
      authBloc = AuthBloc(mockAuthService);
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is Initial', () {
      expect(authBloc.state, const AuthState.initial());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [Loading, Authenticated] when signInWithGoogle succeeds',
      build: () {
        when(mockAuthService.signInWithGoogle()).thenAnswer(
          (_) async => Right(UserDTO(
            id: 'test-id',
            email: 'test@example.com',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthEvent.signInWithGoogle()),
      expect: () => [
        const AuthState.loading(),
        isA<Authenticated>(),
      ],
    );
  });
}
```

### 2. Integration Tests

Add authentication tests to your existing integration test suite.

## Security Considerations

### 1. Firestore Security Rules

Update your Firestore rules to include user-based access:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow authenticated users to read/write their own tabs and entries
    match /users/{userId}/tabs/{tabId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /users/{userId}/entries/{entryId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Keep existing feedback rules
    match /feedback/{feedbackId} {
      allow create: if true;
      allow read: if request.auth != null;
      allow update, delete: if false;
    }
  }
}
```

### 2. Token Management

- The existing Session service already handles token storage
- Consider implementing token refresh logic
- Add token validation on app startup

### 3. Error Handling

- Implement proper error handling for network issues
- Add retry logic for failed authentication attempts
- Handle edge cases like account deletion

## Troubleshooting

### Common Issues

1. **Google Sign-In not working on Android**
   - Verify SHA-1 fingerprint is correct
   - Check that google-services.json is up to date
   - Ensure Google Play Services is installed

2. **iOS Sign-In issues**
   - Verify REVERSED_CLIENT_ID in Info.plist
   - Check that GoogleService-Info.plist is properly configured

3. **Build errors**
   - Run `melos clean` and `melos get`
   - Run `melos build:runner` to generate code
   - Check that all dependencies are properly added

### Debug Commands

```bash
# Clean and rebuild
melos clean
melos get
melos build:runner

# Run tests
melos test:core
melos test:multichoice

# Check Firebase configuration
firebase projects:list
firebase auth:export users.json
```

## Next Steps

1. **User Profile Management**: Add user profile editing capabilities
2. **Data Synchronization**: Sync user data with Firestore
3. **Offline Support**: Implement offline-first data handling
4. **Multi-account Support**: Allow users to switch between accounts
5. **Analytics**: Add authentication events to Firebase Analytics

## Resources

- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Auth Flutter Plugin](https://pub.dev/packages/firebase_auth)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
