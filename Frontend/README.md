# GAULA Frontend (Flutter)

The client for the [GAULA](../README.md) school-management platform. One Flutter codebase for
Android and web.

## Stack

- **Flutter** 3.22+ / Dart 3.4
- **Riverpod 2** (code-gen) for state
- **Dio** for HTTP — JWT interceptor, automatic retry on `401`
- **GoRouter** for navigation with role-based redirect guards
- **freezed** + `json_serializable` for immutable models
- l10n in Spanish, Catalan and English, switched at runtime

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json           # Android / iOS
flutter run -d chrome --dart-define-from-file=env/dev.json  # web
```

`env/dev.json` targets `http://localhost:8080`. For a deployed backend, copy it to
`env/prod.json` (gitignored) and change `API_BASE_URL` / `UPLOADS_BASE_URL`.

## Build web

```bash
flutter build web --dart-define-from-file=env/prod.json
# output in build/web/ — deploy as a static site
```

## Layout

```
lib/
  features/{auth,admin,teacher,student,attendance,shared}/   screens + providers + data
  core/{network,storage,constants}/                          Dio client, secure storage
  router/                                                    GoRouter + role guards
  shared/{theme,widgets,providers,utils,presentation}/       cross-feature pieces
  l10n/                                                      ARB translation files
```
