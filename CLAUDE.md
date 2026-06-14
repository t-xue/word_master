# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**单词小达人 (Word Master)** - A Flutter-based English vocabulary learning app for children aged 6-12.

## Build Commands

```bash
# Install dependencies
flutter pub get

# Run in development
flutter run

# Build release APK
flutter build apk --release --no-tree-shake-icons

# Run tests
flutter test

# Run single test file
flutter test test/models_test.dart

# Analyze code
flutter analyze

# Clean build
flutter clean && flutter pub get
```

## Architecture

### State Management: Riverpod
- `lib/providers/user_provider.dart` - All providers and notifiers
- Uses `StateNotifier` pattern for user progress
- `StateProvider` for simple state (current words, practice score)

### Routing: GoRouter
- `lib/app.dart` - All route definitions
- Routes: `/`, `/home`, `/learn`, `/practice`, `/profile`, `/vocabulary`, `/achievements`, `/settings`

### Local Storage: Hive
- `StorageService` wraps two Hive boxes (user_progress, settings)
- Models use `fromJson`/`toJson` for serialization

### TTS Service
- `lib/services/tts_service.dart` - Dual TTS support
- **Primary**: Remote API (Xiaomi mimo-v2.5-tts)
- **Fallback**: Local device TTS via `flutter_tts`
- Auto-switches to local TTS when API unavailable or no API key configured

### Data Layer
- `data/vocabulary.json` - 527 words across 27 categories
- `WordService` loads and indexes words by category/grade
- `AppConfig` manages runtime configuration with SharedPreferences

## Key Technical Decisions

### Flutter Version Compatibility
- **Local**: Flutter 3.44.1 (uses `CardThemeData`)
- **GitHub Actions**: Flutter 3.24.5 (uses `CardTheme`)
- Use `CardTheme` for compatibility (works in both versions)

### Gradle Configuration
- Gradle 8.4, AGP 8.1.0, Kotlin 1.7.10
- `versionCode` and `versionName` are properties (not functions)
- Use standard Maven repositories (Google, Maven Central)

### API Key Management
- No hardcoded API keys in source code
- `AppConfig.isApiKeyConfigured()` checks if key exists
- App works without API key (uses local TTS fallback)
- Users configure API key in Settings screen

## Screen Architecture

| Screen | File | Purpose |
|--------|------|---------|
| Login | `login_screen.dart` | User registration (name + age) |
| Home | `home_screen.dart` | Dashboard with stats and navigation |
| Learn | `learn_screen.dart` | Flashcard-style word learning |
| Practice | `practice_screen.dart` | Quiz mode (multiple choice + flashcard) |
| Profile | `profile_screen.dart` | User info, badges, settings |
| Vocabulary | `vocabulary_screen.dart` | Browse words by category |
| Achievements | `achievements_screen.dart` | Badges and level system |
| Settings | `settings_screen.dart` | API configuration |

## Gamification System

- **10 levels** with experience points (0-2500 exp)
- **12 badges** across 4 categories (streak, words, perfect, special)
- **Word mastery**: 3 consecutive correct answers = mastered

## Common Patterns

### Adding New Screens
1. Create screen in `lib/screens/`
2. Add route in `lib/app.dart`
3. Update `BottomNavBar` index if needed

### Modifying TTS Behavior
- Edit `lib/services/tts_service.dart`
- Local TTS uses `flutter_tts` package
- Remote TTS calls API in `AppConfig.ttsApiUrl`

### Adding Vocabulary Categories
1. Add words to `data/vocabulary.json`
2. Add category to `_categories` list in `vocabulary_screen.dart`

## Build Issues & Solutions (CRITICAL - READ BEFORE MODIFYING ANDROID CONFIG)

### CardThemeData Error
```dart
// WRONG - CardThemeData doesn't exist in Flutter 3.24.5
cardTheme: CardThemeData(...)

// CORRECT - Use CardTheme (works in all Flutter 3.x versions)
cardTheme: CardTheme(...)
```

### Gradle versionCode and versionName
```kotlin
// WRONG - These are properties, not functions
versionCode = flutter.versionCode()
versionName = flutter.versionName()

// CORRECT - Direct property access
versionCode = flutter.versionCode
versionName = flutter.versionName
```

### Kotlin and AGP Versions
```kotlin
// USE THESE STABLE VERSIONS (tested with Flutter 3.24.5)
id("com.android.application") version "8.1.0" apply false
id("org.jetbrains.kotlin.android") version "1.7.10" apply false
```

### Adaptive Icon Issues
- DO NOT create `mipmap-anydpi-v26/ic_launcher.xml` unless you have proper foreground assets
- Standard mipmap icons (`ic_launcher.png` in each density folder) work reliably
- Missing foreground assets will cause build failure

### Maven Repositories
```kotlin
// USE STANDARD REPOSITORIES (avoid Chinese mirrors in CI)
repositories {
    google()
    mavenCentral()
    gradlePluginPortal()
}
```

### GitHub Actions Flutter Version
```yaml
# USE 3.24.5 for CI builds (CardTheme compatible)
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.5'
    channel: 'stable'
```

## Testing

- `test/models_test.dart` - Word, UserProgress, Badge models
- `test/services_test.dart` - WordService, AppConfig
- `test/config_test.dart` - LevelSystem, BadgeSystem, colors, sizes

Note: `WordService` tests use default words (not loaded from JSON) due to asset loading limitations in test environment.
