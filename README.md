# VentureLink

VentureLink is a Flutter mobile application that connects ALU students with internship and volunteer opportunities at student-led startups within the ALU ecosystem. Students can discover roles, apply, and track applications. Startups can post opportunities, manage listings, and review applicants. Admins verify startups before they can publish listings.

**Technical Report:** [Nshuti-Ruranga-Jabes_FinalFlutterProject.pdf](docs/Nshuti-Ruranga-Jabes_FinalFlutterProject.pdf) · **Demo Video:** [Your Demo Video URL](https://your-demo-video-url-here)

## Features

### Students
- Onboarding and email-verified authentication
- Browse recommended and recent opportunities on Home
- Search, filter, and bookmark opportunities on Explore
- Apply with cover letter and resume link
- Track application status with a visual timeline
- Edit profile (skills, academic info, portfolio links)

### Startups
- Register as a startup during sign-up
- Dedicated startup shell: **Dashboard**, **Listings**, **Applicants**, **Company**
- Create, edit, and close opportunity listings (verified startups only)
- Review applicants and update application status
- Company profile with verification status and metrics
- Startup name changes sync to all posted opportunities

### Admins
- Admin dashboard with user/startup stats
- Verify users, assign roles, and approve startups (`isVerified`)
- Firestore-backed user management (no manual console edits required for day-to-day use)

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter (Dart 3.12+) |
| State management | Riverpod |
| Navigation | GoRouter |
| Backend | Firebase Auth, Cloud Firestore |
| Models | Freezed + json_serializable |
| Local storage | SharedPreferences |

## Architecture

The project uses **feature-first Clean Architecture**:

```
lib/
├── core/           # Theme, routes, constants, shared providers, utils
├── shared/         # Reusable widgets and helpers
└── features/
    ├── authentication/
    ├── profile/
    ├── home/
    ├── opportunities/
    ├── applications/
    ├── startup/
    └── admin/
```

Each feature typically follows:

```
feature/
├── data/           # Datasources, models, repository implementations
├── domain/         # Entities, repository interfaces
└── presentation/   # Screens, widgets, Riverpod providers
```

**State management:** Riverpod `StreamProvider`s for real-time Firestore data, `AsyncNotifier` for actions (login, apply, verify user), and GoRouter redirects driven by auth/profile state.

## Firestore Collections

| Collection | Purpose |
|------------|---------|
| `users/{uid}` | Profile, role (`student` / `startup` / `admin`), `isVerified` |
| `users/{uid}/saved/{opportunityId}` | Bookmarked opportunities |
| `opportunities/{id}` | Internship/volunteer listings |
| `applications/{id}` | Student applications and status |

Security rules live in `firestore.rules`. Composite indexes are defined in `firestore.indexes.json`.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.12+)
- [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli) (`dart pub global activate flutterfire_cli`)
- Android Studio / Xcode for emulator or physical device testing
- A Firebase project with **Authentication (Email/Password)** and **Cloud Firestore** enabled

> **Note:** Run and demo the app on an **Android emulator or physical device**. Web-only runs are not suitable for mobile assignment evaluation.

## Setup

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd venture_link
flutter pub get
```

### 2. Configure Firebase

**Option A — FlutterFire CLI (recommended)**

```bash
firebase login
flutterfire configure
```

This generates `lib/firebase_options.dart` and platform config files.

**Option B — Manual from examples**

```bash
cp lib/firebase_options.example.dart lib/firebase_options.dart
cp android/app/google-services.json.example android/app/google-services.json
```

Fill in values from the [Firebase Console](https://console.firebase.google.com/) for your project.

These files are gitignored and must exist locally before running the app.

### 3. Deploy Firestore rules and indexes

Production Firestore starts with deny-all rules. Deploy the project rules and indexes before testing:

```bash
firebase deploy --only firestore:rules --project <your-project-id>
firebase deploy --only firestore:indexes --project <your-project-id>
```

Wait until indexes show **Enabled** in Firebase Console → Firestore → Indexes.

### 4. Run code generation (if models changed)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run
```

## User Roles

| Role | How it is set | Access |
|------|---------------|--------|
| **Student** | Default when registering as Student | Home, Explore, Applications, Profile |
| **Startup** | Register as Startup; admin sets `isVerified: true` | Dashboard, Listings, Applicants, Company |
| **Admin** | Set `role: "admin"` in Firestore or promoted in Admin UI | Admin Dashboard, Verify Users |

### First-time admin setup

1. Register a normal account in the app.
2. In Firebase Console → Firestore → `users/{your-uid}`, set `role` to `"admin"`.
3. Sign in again → Profile → **Admin Dashboard**.

From there you can verify startups and change user roles without using the console.

## Registration Flow

1. User selects **Student** or **Startup** on the register screen.
2. Firebase Auth account is created and email verification is sent.
3. A `users/{uid}` document is created with the chosen role.
4. After email verification, the app routes to the correct shell (student vs startup UI).

## Development Commands

```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Regenerate Freezed/JSON models
dart run build_runner build --delete-conflicting-outputs

# Deploy Firestore config
firebase deploy --only firestore
```

## Environment Notes

- **Firebase client API keys** in `firebase_options.dart` are not server secrets; they ship in the compiled app. Access control is enforced by Firestore rules and Firebase Auth.
- If queries fail with a missing index error, deploy `firestore.indexes.json` or create the suggested index from the Firebase Console link in the error.
- Startup accounts cannot post opportunities until an admin sets `isVerified: true`.

## Project Info

- **Course:** Formative Assignment 2 — Flutter Mobile Development
- **Institution:** African Leadership University (ALU)
- **App name:** VentureLink
- **Version:** 1.0.0+1

## License

This project was developed as an academic assignment. All rights reserved by the author.
