# VentureLink: Technical Report

**Connecting ALU Students with Startup Opportunities**

---

**Author:** [Your Full Name]  
**Student ID:** [Your Student ID]  
**Course:** Mobile Application Development (Flutter)  
**Institution:** African Leadership University (ALU)  
**Assignment:** Formative Assignment 2 — Individual Final Flutter Project  
**Submission Date:** [Date]  
**GitHub Repository:** [Your Repository URL]  
**Demo Video:** [Your Demo Video URL](https://your-demo-video-url-here)  

---

## Abstract

VentureLink is a cross-platform mobile application developed with Flutter that connects African Leadership University (ALU) students with internship and volunteer opportunities at student-led startups within the ALU ecosystem. The application addresses a practical gap: students often struggle to find meaningful internship experience, while campus entrepreneurs need affordable talent in software development, design, marketing, operations, and related domains.

The system uses Firebase Authentication for secure identity management, Cloud Firestore for real-time persistent data, and Riverpod for predictable state management across a feature-first Clean Architecture codebase. Three user roles—Student, Startup, and Admin—each receive tailored navigation and workflows. Students discover, bookmark, and apply for opportunities; verified startups publish listings and manage applicants; administrators verify startups and manage user roles.

This report documents the system architecture, backend schema, state management design, user workflows, UI/UX decisions, scalability considerations, development challenges, testing approach, limitations, and planned future improvements. The implementation demonstrates real-time synchronization between the mobile client and Firebase Console, role-based access control through Firestore security rules, and maintainable separation of concerns suitable for continued development.

**Keywords:** Flutter, Firebase, Riverpod, Clean Architecture, Internships, ALU, Mobile Development, Firestore

---

## Table of Contents

1. Introduction  
2. Problem Statement and Objectives  
3. System Overview  
4. System Architecture  
5. Firebase Backend Design  
6. State Management with Riverpod  
7. Application Workflows  
8. UI/UX Design and Reasoning  
9. Feature Implementation Summary  
10. Scalability and Maintainability  
11. Development Challenges and Solutions  
12. Testing Strategy  
13. Limitations  
14. Future Improvements  
15. Lessons Learned  
16. Conclusion  
17. References  
18. Appendices  

---

## 1. Introduction

Mobile applications have become essential platforms for connecting communities, managing workflows, and delivering services at scale. Within university ecosystems, internship matching is particularly underserved: generic job boards rarely reflect campus-specific ventures, and student entrepreneurs lack structured channels to recruit peers who understand their context.

VentureLink was designed specifically for the ALU startup ecosystem. Rather than building a generic CRUD application, the project prioritizes role-aware experiences, verification of legitimate startups, real-time application tracking, and an architecture that can grow with additional features such as messaging, notifications, and skill-based recommendations.

The application targets Android and iOS through a single Flutter codebase. Firebase provides backend services without requiring a custom server, which is appropriate for an academic project with real-time requirements and rapid iteration. Riverpod was selected over alternatives such as Provider or BLoC because it offers compile-safe dependency injection, first-class support for asynchronous and streaming state, and clean integration with GoRouter for auth-aware navigation.

---

## 2. Problem Statement and Objectives

### 2.1 Problem Statement

Many ALU students possess technical and professional skills but struggle to secure internships at established organizations. Simultaneously, student-led startups on campus require support across software engineering, UI/UX, marketing, operations, finance, research, product management, and community management. Existing channels—social media posts, word of mouth, and informal WhatsApp groups—are fragmented, unverified, and difficult to search.

### 2.2 Project Objectives

The primary objectives of VentureLink are:

1. **Connect supply and demand** — Enable startups to publish structured opportunity listings and students to discover roles aligned with their skills and interests.
2. **Ensure platform trust** — Restrict posting privileges to ALU-verified startups through an admin verification workflow.
3. **Support end-to-end application lifecycle** — Allow students to apply, track status, and receive updates; allow startups to review and progress applicants.
4. **Demonstrate engineering excellence** — Apply feature-first Clean Architecture, modern state management, secure Firebase integration, and polished mobile UX.
5. **Enable real-time collaboration** — Use Firestore streams so all parties see updates without manual refresh.

### 2.3 Success Criteria (Aligned with Assignment Rubric)

| Criterion | Target |
|-----------|--------|
| UI/UX Design | Polished, consistent Material 3 interface with role-specific navigation |
| Firebase Authentication | Email/password auth with verification, session persistence, console-visible changes |
| Firebase CRUD | Full create/read/update workflows reflected in Firestore in real time |
| State Management & Architecture | Riverpod + Clean Architecture with clear separation of concerns |
| Feature Implementation | All minimum requirements plus bookmarks, admin panel, application timeline |
| Technical Explanation | Report explains decisions, trade-offs, and data flow clearly |
| Code Quality | Modular features, typed models, repository pattern, reusable widgets |
| Report Quality | Structured technical document with diagrams and reasoning |
| Product Thinking | ALU-specific verification, dual-role UX, practical workflows |

---

## 3. System Overview

### 3.1 Technology Stack

| Layer | Technology | Justification |
|-------|------------|---------------|
| Frontend | Flutter (Dart 3.12+) | Single codebase for Android/iOS; rich widget ecosystem |
| State Management | Riverpod 2.x | Stream/async providers, testable DI, router integration |
| Navigation | GoRouter | Declarative routes, redirect guards, shell navigation |
| Authentication | Firebase Auth | Email/password, verification, session management |
| Database | Cloud Firestore | Real-time NoSQL, offline cache, security rules |
| Storage | Firebase Storage | Prepared for profile images and documents (future) |
| Models | Freezed + json_serializable | Immutable data classes, JSON/Firestore serialization |
| Local Persistence | SharedPreferences | Onboarding flag, remembered email |

### 3.2 User Roles

VentureLink implements three distinct roles:

**Student (default registration role)**  
- Browse Home and Explore screens  
- Search, filter by category, bookmark opportunities  
- Submit applications with cover letter and resume link  
- Track application status via visual timeline  
- Manage academic profile, skills, and portfolio links  

**Startup**  
- Register with startup role during sign-up  
- Access dedicated shell: Dashboard, Listings, Applicants, Company Profile  
- Create and edit opportunities after admin verification (`isVerified: true`)  
- Review applicants and update application status  
- Company name changes propagate to all posted opportunities  

**Admin**  
- Access Admin Dashboard and Verify Users screens  
- Promote/demote user roles (student, startup, admin)  
- Toggle startup verification status  
- View platform statistics  

### 3.3 High-Level System Context

```
┌─────────────────────────────────────────────────────────────────┐
│                     VentureLink Mobile App                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │ Student  │  │ Startup  │  │  Admin   │  │  Shared UI   │  │
│  │   Shell  │  │   Shell  │  │  Screens │  │  Components  │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬───────┘  │
│       │             │             │                │          │
│       └─────────────┴─────────────┴────────────────┘          │
│                            │                                     │
│              Riverpod Providers (State Layer)                    │
│                            │                                     │
│              Repository Pattern (Domain/Data)                    │
└────────────────────────────┼────────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │      Firebase Backend        │
              │  ┌────────┐  ┌────────────┐  │
              │  │  Auth  │  │ Firestore  │  │
              │  └────────┘  └────────────┘  │
              └─────────────────────────────┘
```

*[Insert Figure 1: System Context Diagram — recreate in Google Docs using shapes or draw.io]*

---

## 4. System Architecture

### 4.1 Architectural Pattern: Feature-First Clean Architecture

The codebase follows **feature-first Clean Architecture**, organizing code by business capability rather than technical layer alone. Each feature contains its own data, domain, and presentation layers. Shared concerns live in `core/` and `shared/`.

```
lib/
├── main.dart / app.dart
├── core/
│   ├── constants/       # Colors, strings, roles, dimensions
│   ├── theme/           # Material 3 theme (Poppins + Inter)
│   ├── routes/          # GoRouter configuration and guards
│   ├── services/        # Firebase initialization
│   ├── providers/       # Cross-feature providers (user context)
│   ├── errors/          # Failure types
│   └── utils/           # Validators, converters, logger
├── shared/
│   └── widgets/         # Reusable UI (buttons, cards, chips, states)
└── features/
    ├── authentication/
    ├── profile/
    ├── home/
    ├── opportunities/
    ├── applications/
    ├── startup/
    └── admin/
```

Within each feature:

```
feature/
├── domain/
│   ├── entities/        # Pure business objects
│   └── repositories/    # Abstract repository interfaces
├── data/
│   ├── models/          # Freezed models with fromJson/toJson
│   ├── datasources/     # Firebase/Firestore access
│   └── repositories/    # Repository implementations
└── presentation/
    ├── providers/       # Riverpod providers
    ├── screens/         # Full-page UI
    └── widgets/         # Feature-specific components
```

### 4.2 Layer Responsibilities

**Presentation Layer**  
- Renders UI using `ConsumerWidget` / `ConsumerStatefulWidget`  
- Watches Riverpod providers; never calls Firestore directly  
- Handles loading, error, and empty states consistently  
- Does not use `FutureBuilder` for backend data (state comes from Riverpod)  

**Domain Layer**  
- Defines entities independent of Firebase  
- Declares repository contracts  
- Encapsulates business enums (e.g., `ApplicationStatus`, `OpportunityCategory`)  

**Data Layer**  
- Implements repositories  
- Maps Firestore documents to typed models via `fromFirestore` / `toFirestore`  
- Handles network errors and converts them to domain failures  

### 4.3 Navigation Architecture

GoRouter manages all navigation with auth-aware redirects:

1. **Unauthenticated users** → Splash → Onboarding → Login/Register  
2. **Unverified email** → Email Verification screen  
3. **Authenticated users** → Role-specific `MainShell` via `RoleBranchScreen`  
4. **Admin routes** → Protected by role check in redirect logic  

The `MainShell` uses `StatefulShellRoute.indexedStack` with four bottom-navigation branches. Each branch renders different screens for students vs. startups through `RoleBranchScreen`:

| Tab Index | Student Screen | Startup Screen |
|-----------|----------------|----------------|
| 0 | Home | Dashboard |
| 1 | Explore | Listings |
| 2 | Applications | Applicants |
| 3 | Profile | Company Profile |

*[Insert Figure 2: Navigation Flow Diagram]*

### 4.4 Repository Pattern

All Firebase access is isolated behind repository interfaces. Example flow for applying to an opportunity:

```
ApplyApplicationSheet (UI)
        ↓ ref.read(applyActionProvider.notifier).apply(...)
ApplicationRepository (interface)
        ↓
ApplicationRepositoryImpl
        ↓
FirestoreApplicationDatasource.createApplication(...)
        ↓
Cloud Firestore: applications/{id}
        ↓
StreamProvider invalidates / emits new data
        ↓
ApplicationsScreen rebuilds automatically
```

This pattern ensures UI widgets remain unaware of Firestore query syntax, security rule details, or JSON field names.

### 4.5 Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Riverpod over BLoC | Less boilerplate for StreamProviders; excellent async support |
| GoRouter over Navigator 1.0 | Centralized redirects; deep linking ready |
| Freezed models | Immutability, copyWith, reduced serialization bugs |
| Feature-first folders | Teams can work on features independently; aligns with product modules |
| RoleBranchScreen | Single router config with runtime role switching; avoids duplicate route trees |
| Firestore streams over polling | Real-time UX; matches assignment requirement |
| Security rules over client checks | Server-side enforcement; verified startups cannot be bypassed in client |

---

## 5. Firebase Backend Design

### 5.1 Firebase Project Configuration

- **Project ID:** venture-link-8cc2e  
- **Services enabled:** Authentication (Email/Password), Cloud Firestore  
- **Configuration files:** `firebase_options.dart`, `google-services.json` (gitignored locally; example templates provided)  
- **Deployment:** `firestore.rules` and `firestore.indexes.json` deployed via Firebase CLI  

### 5.2 Firestore Collections and Schema

#### Collection: `users/{uid}`

| Field | Type | Description |
|-------|------|-------------|
| uid | string | Firebase Auth UID (document ID) |
| fullName | string | Display name |
| email | string | User email |
| role | string | `student`, `startup`, or `admin` |
| profilePicture | string? | URL to profile image |
| degree | string? | Academic program |
| year | string? | Year of study |
| skills | array<string> | Student skills |
| interests | array<string> | Areas of interest |
| bio | string? | Profile biography |
| resumeUrl | string? | Link to resume |
| github | string? | GitHub profile |
| linkedin | string? | LinkedIn profile |
| portfolio | string? | Portfolio URL |
| isProfileComplete | boolean | Profile completion flag |
| isEmailVerified | boolean | Synced from Auth |
| isVerified | boolean | Startup verification (admin-controlled) |
| createdAt | timestamp | Account creation |
| updatedAt | timestamp | Last profile update |

**Subcollection:** `users/{uid}/saved/{opportunityId}` — bookmarked opportunities

#### Collection: `opportunities/{id}`

| Field | Type | Description |
|-------|------|-------------|
| title | string | Job title |
| description | string | Full description |
| startupId | string | Owner startup UID |
| startupName | string | Denormalized startup name |
| skills | array<string> | Required skills |
| location | string | Physical or general location |
| workMode | string | remote, hybrid, on-site |
| category | string | engineering, design, marketing, etc. |
| hoursPerWeek | string | Expected weekly commitment |
| deadline | timestamp | Application deadline |
| status | string | active, closed |
| isVerified | boolean | Mirrors startup verification |
| createdAt | timestamp | Listing creation |
| updatedAt | timestamp | Last edit |

#### Collection: `applications/{id}`

| Field | Type | Description |
|-------|------|-------------|
| studentId | string | Applicant UID |
| opportunityId | string | Target opportunity |
| startupId | string | Opportunity owner |
| status | string | applied, under_review, interview, accepted, rejected |
| coverLetter | string? | Application message |
| resumeUrl | string? | Resume link |
| createdAt | timestamp | Submission time |
| updatedAt | timestamp | Last status change |

*[Insert Figure 3: Entity-Relationship / Firestore Schema Diagram]*

```
users ──────────────< applications >────────────── opportunities
  │                         │                            │
  │                         └──── references ────────────┘
  │
  └── saved (subcollection) ──> opportunityId
```

### 5.3 Firestore Security Rules

Security rules enforce role-based access at the database level:

- **Users:** Any signed-in user can read profiles; users update their own document; admins can update any user.
- **Saved bookmarks:** Owner read/write only.
- **Opportunities:** Public read; create restricted to verified startups posting as themselves; update by owning startup or admin.
- **Applications:** Read by student applicant, owning startup, or admin; create by students with status `applied`; update by owning startup or admin; delete (withdraw) by student only while status is `applied`.

Helper functions in rules: `isSignedIn()`, `isStartup()`, `isVerifiedStartup()`, `isAdmin()`.

Deploying rules was critical: Firestore in production mode denies all reads/writes by default. Initial registration failed because profile documents could not be created until rules were deployed.

### 5.4 Composite Indexes

Firestore requires composite indexes for multi-field queries. VentureLink defines indexes for:

| Collection | Fields | Use Case |
|------------|--------|----------|
| applications | studentId + updatedAt DESC | Student application list |
| applications | startupId + updatedAt DESC | Startup applicant inbox |
| applications | studentId + opportunityId | Duplicate application check |
| opportunities | startupId + updatedAt DESC | Startup listing management |
| opportunities | status + createdAt DESC | Active opportunities feed |

Indexes are version-controlled in `firestore.indexes.json` and deployed with:

```
firebase deploy --only firestore:indexes
```

Missing indexes initially caused "Failed to load opportunities" errors on Home, Explore, and Applications screens until deployment completed.

### 5.5 Authentication Integration

Firebase Authentication handles:

- Email/password registration with role selection  
- Email verification before home access  
- Login with optional "Remember Me" (email stored in SharedPreferences)  
- Password reset via email link  
- Session persistence across app restarts  
- Auth state stream driving GoRouter redirects  

On registration, the app creates a corresponding `users/{uid}` Firestore document with the selected role. A profile recovery path exists for users whose Auth account was created but Firestore write failed (e.g., before rules deployment).

---

## 6. State Management with Riverpod

### 6.1 Why Riverpod

Riverpod was chosen because VentureLink relies heavily on:

1. **Streaming data** — Firestore `snapshots()` for opportunities, applications, bookmarks  
2. **Async actions** — Login, register, apply, verify user  
3. **Derived state** — Filtered lists, role checks, bookmark status  
4. **Router integration** — Auth state changes trigger navigation redirects  

Compared to Provider, Riverpod eliminates `BuildContext` dependency for reading state. Compared to BLoC, it reduces event/state class boilerplate for straightforward CRUD workflows.

### 6.2 Provider Categories Used

| Provider Type | Purpose | Examples |
|---------------|---------|----------|
| `Provider` | Singleton dependencies | `firebaseAuthProvider`, `authRepositoryProvider` |
| `StreamProvider` | Real-time Firestore data | `opportunitiesStreamProvider`, `studentApplicationsProvider` |
| `FutureProvider` | One-shot async reads | Profile fetch on demand |
| `AsyncNotifierProvider` | Mutable async state + actions | `authNotifierProvider`, `loginActionProvider` |
| `family` modifiers | Parameterized providers | Opportunity by ID, filtered lists |

### 6.3 Auth State Flow

```
FirebaseAuth.authStateChanges()
        ↓
AuthRepository.authStateChanges
        ↓
AuthNotifier (AsyncNotifier<AuthState>)
        ↓
ref.listen in routerProvider → GoRouter refresh
        ↓
redirect() evaluates: onboarding? logged in? email verified?
        ↓
Navigate to appropriate screen
```

After email verification, `refreshUser()` reloads the Firebase user and updates `authNotifierProvider`, fixing a bug where the UI did not redirect until app restart.

### 6.4 Real-Time UI Updates

Screens watch StreamProviders and rebuild automatically:

```dart
final opportunitiesAsync = ref.watch(activeOpportunitiesProvider);

return opportunitiesAsync.when(
  data: (opportunities) => OpportunityList(opportunities),
  loading: () => LoadingIndicator(),
  error: (e, _) => ErrorState(message: e.toString()),
);
```

When a startup changes an application status in Firestore, the student's Applications screen updates within seconds without pull-to-refresh. This satisfies the assignment requirement for dynamic, real-time updates.

### 6.5 State Propagation Example

**Scenario:** Startup marks application as "Under Review"

1. Startup taps status chip in Applicants screen  
2. `updateApplicationStatusProvider` calls repository  
3. Firestore document `applications/{id}` field `status` updates  
4. Student's `studentApplicationsProvider` stream emits new snapshot  
5. Application card rebuilds with new status color and timeline position  
6. Firebase Console shows updated timestamp and status field  

This chain demonstrates state management controlling UI updates, backend synchronization, and workflow consistency across the application.

---

## 7. Application Workflows

### 7.1 Authentication and Onboarding

**Flow:** Splash → Onboarding (first launch only) → Login or Register → Email Verification → Home/Startup Dashboard

**Registration enhancements:**
- User selects **Student** or **Startup** role before account creation  
- Password validation: minimum 8 characters, uppercase, lowercase, number  
- Firestore profile created atomically after Auth user creation  
- Verification email sent; user must tap link then press "I Have Verified"  

*[Insert Screenshot A: Onboarding screens]*  
*[Insert Screenshot B: Register screen with role picker]*  
*[Insert Screenshot C: Email verification screen]*  

### 7.2 Student Opportunity Discovery

**Home Screen:**
- Personalized greeting with user name  
- Search bar filtering opportunities locally  
- Recommended horizontal cards  
- Category grid (Engineering, Design, Marketing, etc.)  
- Recent opportunities vertical list  

**Explore Screen:**
- Full searchable list with category filters  
- Bookmark toggle on each card  
- Navigate to Opportunity Details  

**Opportunity Details:**
- Full description, skills, location, work mode, deadline  
- Apply button opens bottom sheet for cover letter + resume URL  
- Duplicate application prevention  

*[Insert Screenshot D: Home screen]*  
*[Insert Screenshot E: Explore with filters]*  
*[Insert Screenshot F: Opportunity details]*  

### 7.3 Application Submission and Tracking

**Apply workflow:**
1. Student opens opportunity details  
2. Taps Apply → validates inputs  
3. Creates `applications` document with status `applied`  
4. Snackbar confirmation; button changes to "Applied"  

**Tracking workflow:**
- Applications tab lists all submissions sorted by `updatedAt`  
- Status chips use color coding (applied=blue, under review=amber, interview=purple, accepted=green, rejected=red)  
- Timeline widget shows progression through pipeline stages  
- Student can withdraw while status is `applied`  

*[Insert Screenshot G: Apply bottom sheet]*  
*[Insert Screenshot H: Applications list with timeline]*  

### 7.4 Startup Opportunity Management

**Verification gate:** Unverified startups see prompts to await admin approval; create buttons disabled.

**Verified startup workflow:**
1. Dashboard shows stats (active listings, total applicants, pending reviews)  
2. Listings tab → create/edit/close opportunities  
3. Opportunity form validates required fields  
4. Firestore creates document with `startupId`, `startupName`, `isVerified: true`  

**Name sync:** When startup edits company name in profile, all their opportunity documents update `startupName` via batch query—keeping denormalized data consistent for search and display.

*[Insert Screenshot I: Startup dashboard]*  
*[Insert Screenshot J: Create opportunity form]*  
*[Insert Screenshot K: Startup listings]*  

### 7.5 Applicant Review (Startup)

1. Applicants tab streams applications where `startupId == currentUser.uid`  
2. Each card shows student info, opportunity title, current status  
3. Startup taps status actions to progress applicant  
4. Changes reflect immediately in student's app  

*[Insert Screenshot L: Applicants management screen]*  

### 7.6 Admin Verification

1. Admin sets `role: "admin"` in Firestore (first admin) or is promoted in-app  
2. Profile shows Admin Dashboard link  
3. Verify Users screen lists all users with filters (All, Startups, Pending, Students)  
4. Admin toggles `isVerified` for startups and changes roles via menu  

*[Insert Screenshot M: Admin dashboard]*  
*[Insert Screenshot N: Verify users screen]*  

---

## 8. UI/UX Design and Reasoning

### 8.1 Design System

VentureLink uses Material 3 with a custom theme:

| Token | Value | Usage |
|-------|-------|-------|
| Primary | #6C63FF | Buttons, active nav, accents |
| Secondary | #A78BFA | Gradients, secondary actions |
| Accent | #F59E0B | Highlights, badges |
| Background | #F8F9FC | Screen backgrounds |
| Typography | Poppins (headings), Inter (body) | Modern, readable hierarchy |

Spacing, border radius, and elevation constants live in `core/constants/` to ensure consistency.

### 8.2 UX Principles Applied

1. **Role-specific shells** — Students and startups see fundamentally different navigation, reducing cognitive load and irrelevant screens.
2. **Progressive disclosure** — Apply form appears as bottom sheet; admin actions hidden behind menus.
3. **Immediate feedback** — Loading indicators on async actions; snackbars for success/error; disabled buttons during submission.
4. **Empty and error states** — Dedicated widgets for no data, search miss, and network failure rather than blank screens.
5. **Visual status language** — Color-coded application statuses and verification badges communicate state at a glance.
6. **Responsive layout fixes** — Stat cards, opportunity headers, and skill chips were iteratively adjusted to prevent overflow on smaller devices.

### 8.3 Accessibility Considerations

- Sufficient color contrast on primary actions  
- Touch targets sized for mobile interaction  
- Semantic structure with clear headings and labels on form fields  
- Future improvement: explicit screen reader labels and focus order audit  

### 8.4 Beyond Template Design

The UI was intentionally redesigned from the default Flutter counter template:

- Custom auth scaffold with branded gradients  
- Animated splash with fade/scale transitions  
- Featured opportunity cards with gradient overlays  
- Category grid with iconography  
- Application status timeline (not a generic list)  
- Separate startup dashboard with metric cards  

---

## 9. Feature Implementation Summary

### 9.1 Minimum Requirements Checklist

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Authentication & onboarding | ✅ Complete | Full auth flow with email verification |
| Startup profiles + ALU verification | ✅ Complete | Role + isVerified with admin UI |
| Opportunity posting | ✅ Complete | CRUD for verified startups |
| Discovery & search | ✅ Complete | Home, Explore, category filters |
| Application submission | ✅ Complete | Apply sheet with validation |
| Real-time updates | ✅ Complete | Firestore StreamProviders |
| Firebase persistence | ✅ Complete | Auth + Firestore |
| State management | ✅ Complete | Riverpod throughout |

### 9.2 Additional Features (Beyond Minimum)

| Feature | Description |
|---------|-------------|
| Bookmarks | Save opportunities to user subcollection |
| Application timeline | Visual pipeline for students |
| Admin dashboard | User stats and management |
| Role at registration | Student vs Startup picker |
| Dual navigation shells | RoleBranchScreen pattern |
| Startup name sync | Denormalized field consistency |
| Remember Me | Persist login email locally |
| Forgot password | Firebase reset email |
| Profile portfolio fields | GitHub, LinkedIn, resume links |
| Withdraw application | Delete while status is applied |

### 9.3 Features Not Implemented (Future Scope)

| Feature | Reason Deferred |
|---------|-----------------|
| Push notifications (FCM) | Marked future-ready in product spec |
| In-app messaging/chat | Scope prioritization |
| Skill-based recommendations | Requires matching algorithm |
| Interview scheduling | Dependent on calendar integration |
| Analytics dashboards | Admin stats only; no charts yet |
| Firebase Storage uploads | Resume currently URL-based |

---

## 10. Scalability and Maintainability

### 10.1 Scalability Considerations

**Firestore denormalization:** `startupName` is copied onto opportunity documents to avoid joins on every list query. When the name changes, a batch update synchronizes all related documents.

**Indexed queries:** All list queries use indexed field combinations, preventing full collection scans as data grows.

**Security rules:** Access control scales with user count because enforcement happens server-side, not in client logic.

**Modular features:** New features (e.g., notifications) can be added as `lib/features/notifications/` without restructuring existing modules.

**Pagination readiness:** Current lists load full collections suitable for demo scale; production would add `limit()` + cursor pagination to providers.

### 10.2 Maintainability Practices

- **Typed models** — No raw `Map<String, dynamic>` in UI  
- **String constants** — User-facing text centralized in `*_strings.dart` files  
- **Reusable widgets** — `LoadingIndicator`, `ErrorState`, `EmptyState`, `SkillOverflowChips`  
- **Single router** — All paths defined in `app_router.dart`  
- **Gitignored secrets** — Firebase config excluded; example templates documented in README  
- **Static analysis** — Project passes `flutter analyze` with no issues  

### 10.3 Code Organization Metrics

- 7 feature modules + core/shared layers  
- Repository interface for every data domain  
- Consistent provider file naming (`*_providers.dart`, `*_repository_providers.dart`)  

---

## 11. Development Challenges and Solutions

### 11.1 Firestore Production Rules Blocking Registration

**Problem:** New users could create Firebase Auth accounts but registration appeared to fail. Firestore profile writes were denied because production mode defaults to deny-all rules.

**Solution:** Authored and deployed `firestore.rules` with role-aware policies. Added profile recovery on login for users created during the rules gap.

**Lesson:** Backend security configuration must be deployed before testing auth flows in production Firestore.

### 11.2 Email Verification Redirect Not Working

**Problem:** After clicking "I Have Verified," a success toast appeared but navigation did not proceed to Home.

**Root cause:** `user.reload()` updated Firebase Auth but Riverpod's `authNotifierProvider` still held stale `emailVerified: false`.

**Solution:** Implemented `refreshUser()` to reload Auth user and emit updated `AuthState`, triggering GoRouter redirect.

### 11.3 Missing Composite Indexes

**Problem:** Home, Explore, and Applications showed "Failed to load opportunities."

**Root cause:** Multi-field Firestore queries require composite indexes not present in a fresh Firebase project.

**Solution:** Defined indexes in `firestore.indexes.json` and deployed via Firebase CLI. Documented in README as required setup step.

### 11.4 UI Overflow on Startup Dashboard and Cards

**Problem:** Stat cards and opportunity skill chips overflowed on smaller screen sizes.

**Solution:** Adjusted `mainAxisExtent`, used `Flexible`/`Expanded` layouts, created `SkillOverflowChips` widget showing "+N more" for long skill lists.

### 11.5 Denormalized Data Consistency

**Problem:** Startup name displayed on opportunities could become stale after profile edits.

**Solution:** `ProfileRepositoryImpl.updateProfile()` detects startup name changes and calls `syncStartupName()` to batch-update related opportunity documents.

---

## 12. Testing Strategy

### 12.1 Manual Testing (Primary)

Given the assignment timeline, manual testing was the primary validation method:

| Area | Test Cases |
|------|------------|
| Auth | Register, login, logout, forgot password, email verification |
| Roles | Student vs startup registration, admin promotion |
| Opportunities | Create, edit, close, search, filter, bookmark |
| Applications | Apply, duplicate prevention, withdraw, status updates |
| Admin | Verify startup, change roles, filter users |
| Real-time | Two devices/emulators; verify Console sync |
| Edge cases | Unverified startup posting blocked, offline error states |

### 12.2 Static Analysis

```bash
flutter analyze
```

Run continuously during development; project maintains zero analyzer issues.

### 12.3 Firebase Console Verification

Each core workflow was validated against Firebase Console:

- Authentication tab shows new users  
- Firestore shows created/updated documents with correct timestamps  
- Security rules tested by attempting unauthorized operations  

### 12.4 Automated Testing (Future)

Automated widget and integration tests are planned but not yet implemented. Recommended next steps:

- Unit tests for validators and model serialization  
- Repository tests with mocked Firestore  
- Widget tests for auth forms and application timeline  
- Integration tests with Firebase Emulator Suite  

---

## 13. Limitations

1. **No push notifications** — Users must open the app to see application status changes.  
2. **No in-app messaging** — Students and startups cannot chat within the platform.  
3. **URL-based resumes** — No file upload to Firebase Storage; users provide external links.  
4. **Limited recommendation engine** — Home "Recommended" section uses available listings rather than skill matching.  
5. **No pagination** — All opportunities load at once; acceptable for demo scale only.  
6. **Single institution** — Designed for ALU; no multi-university support.  
7. **Manual first admin** — Initial admin requires Firestore role assignment or promotion.  
8. **Minimal automated tests** — Reliance on manual QA for assignment submission.  
9. **English only** — No internationalization/localization.  

---

## 14. Future Improvements

1. **Firebase Cloud Messaging** — Notify students of status changes; notify startups of new applicants.  
2. **In-app chat** — Firestore subcollections for conversation threads per application.  
3. **Skill matching** — Score opportunities against student skills/interests for true recommendations.  
4. **Firebase Storage integration** — Upload resumes and profile pictures directly.  
5. **Interview scheduling** — Calendar picker with Cloud Functions reminders.  
6. **Analytics dashboard** — Charts for application funnel, popular categories, active startups.  
7. **Pagination and infinite scroll** — Performance optimization for large datasets.  
8. **Firebase Emulator Suite in CI** — Automated integration tests.  
9. **Deep linking** — Share opportunity URLs that open directly in app.  
10. **Multi-language support** — English, French, Kinyarwanda for ALU community.  

---

## 15. Lessons Learned

1. **Deploy Firebase infrastructure early** — Rules and indexes are not optional; they block core functionality.  
2. **Auth state and UI state must stay synchronized** — Reloading Firebase user data must propagate through state management layers.  
3. **Design for roles from the start** — Retrofitting startup-specific navigation was harder than building `RoleBranchScreen` from the beginning.  
4. **Denormalize deliberately** — Copying `startupName` to opportunities improves read performance but requires sync logic on updates.  
5. **Test on real device dimensions** — Overflow bugs appear only on constrained mobile viewports.  
6. **Console-side verification matters** — Validating Firestore updates in Firebase Console alongside the app confirms end-to-end data flow.  
7. **Feature-first architecture pays off** — Adding admin module did not require changes to authentication internals.  

---

## 16. Conclusion

VentureLink successfully addresses the ALU internship matching problem through a role-aware, real-time mobile platform built with Flutter and Firebase. The application meets all minimum assignment requirements and extends them with bookmarks, application tracking, admin verification, and distinct student/startup experiences.

The feature-first Clean Architecture combined with Riverpod provides a scalable foundation for future enhancements. Firestore security rules enforce trust in the startup verification model, while StreamProviders deliver the dynamic user experience specified in the assignment brief.

Development challenges—production Firestore rules, composite indexes, auth state synchronization, and responsive layout—were resolved through systematic debugging and architectural discipline. The project demonstrates not only functional mobile development skills but also product thinking tailored to the ALU ecosystem.

---

## 17. References

[1] Google, "Flutter Documentation," Google LLC, 2026. [Online]. Available: https://docs.flutter.dev/. [Accessed: Jul. 11, 2026].

[2] Google, "Cloud Firestore Documentation," Google LLC, 2026. [Online]. Available: https://firebase.google.com/docs/firestore. [Accessed: Jul. 11, 2026].

[3] Google, "Firebase Authentication Documentation," Google LLC, 2026. [Online]. Available: https://firebase.google.com/docs/auth. [Accessed: Jul. 11, 2026].

[4] R. C. Martin, *Clean Architecture: A Craftsman's Guide to Software Structure and Design*. Boston, MA, USA: Prentice Hall, 2017.

[5] Remi Rousselet, "Riverpod Documentation," 2026. [Online]. Available: https://riverpod.dev/. [Accessed: Jul. 11, 2026].

[6] Google, "GoRouter Package," pub.dev, 2026. [Online]. Available: https://pub.dev/packages/go_router. [Accessed: Jul. 11, 2026].

[7] African Leadership University, "Formative Assignment 2: Individual Final Flutter Project," Mobile Application Development Course, 2026.

[8] Google, "Firestore Security Rules," Google LLC, 2026. [Online]. Available: https://firebase.google.com/docs/firestore/security/get-started. [Accessed: Jul. 11, 2026].

[9] Google, "Material Design 3," Google LLC, 2026. [Online]. Available: https://m3.material.io/. [Accessed: Jul. 11, 2026].

[10] Freezed Contributors, "freezed — Code Generation for Immutable Classes," pub.dev, 2026. [Online]. Available: https://pub.dev/packages/freezed. [Accessed: Jul. 11, 2026].

---

## 18. Appendices

### Appendix A: Screenshot Checklist for Final PDF

Replace each placeholder in Section 7 and Section 8 with actual screenshots from your emulator or device:

1. Onboarding (2–3 slides)  
2. Register with role picker  
3. Email verification  
4. Student Home  
5. Explore with search/filters  
6. Opportunity details  
7. Apply bottom sheet  
8. Applications with timeline  
9. Startup dashboard  
10. Create/edit opportunity  
11. Startup applicants  
12. Admin verify users  
13. Firebase Console — Auth users list  
14. Firebase Console — Firestore document after apply  

### Appendix B: Key File References

| Component | Path |
|-----------|------|
| App entry | `lib/main.dart`, `lib/app.dart` |
| Router | `lib/core/routes/app_router.dart` |
| Auth providers | `lib/features/authentication/presentation/providers/auth_providers.dart` |
| Firestore rules | `firestore.rules` |
| Firestore indexes | `firestore.indexes.json` |
| Role branching | `lib/shared/widgets/role_branch_screen.dart` |
| Main navigation | `lib/features/home/presentation/screens/main_shell.dart` |

### Appendix C: Submission Checklist

- [ ] GitHub repository link is public/accessible to instructor  
- [ ] README.md contains setup instructions  
- [ ] PDF named: `YourName_FinalFlutterProject.pdf`  
- [ ] PDF uploaded to Canvas before deadline  
- [ ] App tested on emulator or physical device (not browser-only)  

---

*End of Report*
