# islam-edu-mobile

Flutter MVP app for beginner-friendly Islamic education in Kyrgyzstan.

## Stack
- Flutter
- Riverpod state management
- Dio API client
- Localization (`ky`, `ru`) via ARB

## MVP screens
- Onboarding (language selection)
- Home
- Categories
- Lesson list + search
- Lesson detail
- Learning path + progress
- Bookmarks
- Profile

## Product constraints
- Educational app only
- No AI chat in MVP
- No fatwa generation
- Content comes from curated backend lessons

## Setup
```bash
flutter pub get
flutter gen-l10n
flutter run
```

If backend runs locally:
- Android emulator base URL is set to `http://10.0.2.2:3000`
- Override with:
```bash
flutter run --dart-define=API_BASE_URL=http://<host>:<port>
```

## Checks
```bash
dart format lib test
flutter analyze
flutter test
```

## Git workflow
- Use feature branches: `feat/*`, `fix/*`, `chore/*`
- Use Conventional Commits
- Open pull requests into `main`
