# GAULA — school management platform

![Java](https://img.shields.io/badge/Java-21-007396?style=flat&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3-6DB33F?style=flat&logo=springboot&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-3.22-02569B?style=flat&logo=flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2-0553B1?style=flat)

A full-stack platform for running a school: students, teachers, courses, class schedules,
attendance ("pasar lista"), incident reports, events and a holiday calendar. A **Spring Boot**
REST API with JWT auth and a **Flutter** client that runs on Android and the web from one
codebase.

Built for the final DAM (software development) project. Two people, ~130 backend classes and a
feature-first Flutter app.

## The three roles

| Role | Can do |
|---|---|
| **Admin** | Everything — create courses/subjects from templates, enrol students, assign teachers, edit the school year, manage the rulebook and system config. |
| **Teacher** | See their classes and schedule, take attendance, open incident reports, read the directory. |
| **Student** | See their timetable, attendance record, incidents, events and the school rulebook. |

Access is enforced server-side in `SecurityConfig` (per-endpoint, per-HTTP-method role checks)
and mirrored in the Flutter router as redirect guards.

## Repository layout

```
Backend/    Spring Boot REST API
  src/main/java/com/gaula/
    controller/  service/  repository/  entity/  dto/  domain/
    security/    JWT filter, token provider, blacklist (logout), UserDetails
    config/      Spring Security, CORS, rate limiting, Flyway, DB seeding
  src/main/resources/db/migration/   Flyway migrations (V1..V16)
Frontend/   Flutter app (mobile-first, also web)
  lib/
    features/{auth,admin,teacher,student,attendance,shared}/
    core/{network,storage,constants}/   Dio client + JWT interceptor, secure storage
    router/     GoRouter with role-based redirects
    shared/     theme, widgets, providers, l10n (ES / CA / EN)
```

## Run it locally

**Backend** — needs JDK 21 and a MySQL database (or Postgres — both drivers are on the
classpath). Nothing is hardcoded; configuration is all environment variables:

```bash
cd Backend
export DB_URL="jdbc:mysql://localhost:3306/gaula?useSSL=false&allowPublicKeyRetrieval=true"
export DB_USERNAME=root DB_PASSWORD=yourpassword
export GAULA_JWT_SECRET="$(openssl rand -base64 64)"
mvn spring-boot:run
```

Flyway creates the schema and seeds demo data on first boot. Swagger UI is at
`http://localhost:8080/swagger-ui.html`. Seeded logins use the password `admin123` (see
`db/migration/V2__fix_default_passwords.sql`).

**Frontend** — needs the Flutter SDK (3.22+):

```bash
cd Frontend
flutter pub get
flutter run --dart-define-from-file=env/dev.json          # mobile
flutter run -d chrome --dart-define-from-file=env/dev.json # web
```

`env/dev.json` points at `http://localhost:8080`. Copy it to `env/prod.json` (gitignored) to
target a deployed backend.

## Architecture

See [ARCHITECTURE.md](./ARCHITECTURE.md) for the request path, the auth flow and the data model.

## License

PolyForm Noncommercial 1.0.0 ([LICENSE](./LICENSE)). Personal, non-commercial use only.
