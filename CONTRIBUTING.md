# Contributing

## Branching
- Keep `main` stable.
- Create branches as `feat/<scope>`, `fix/<scope>`, or `chore/<scope>`.
- Merge to `main` only through pull requests.

## Commit style
- Conventional Commits:
  - `feat:`
  - `fix:`
  - `chore:`
  - `docs:`
  - `refactor:`
  - `test:`

## Local checks
```bash
flutter pub get
flutter gen-l10n
dart format lib test
flutter analyze
flutter test
```
