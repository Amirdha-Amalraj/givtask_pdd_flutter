# GivTask Flutter — Full Fix & Enhancement Plan

## Analysis Summary

After deep review of the existing codebase, here are the confirmed bugs and missing pieces:

---

## What Is Wrong

### 1. No Landing Page
- `/` route maps directly to `SplashScreen` which redirects to `/onboarding` (another app-style screen)
- There is **no public website homepage** at all
- Public users immediately hit the splash → onboarding → login flow (wrong for web)

### 2. Authentication Flow Is Completely Broken
- `login_screen.dart` line 38: After login it always calls `context.go('/home')` — hardcoded
- `/home` in `home_screen.dart` **always** renders `NgoDashboardScreen()` in its `_pages` list regardless of user role
- There is **zero role checking** after login

### 3. Registration Saves Role But Never Routes By Role
- `register_screen.dart` correctly passes role to `signUpWithEmail`, which stores it in Supabase metadata
- But after registration it just goes to `/login` with no role-aware routing
- After login, `/home` ignores role and shows NGO dashboard

### 4. Splash Screen Doesn't Check Role
- `splash_screen.dart` checks if user is logged in but sends everyone to `/home` — again no role check

### 5. Session Logout Redirects to `/login` not landing page
- `settings_screen.dart` calls `context.go('/login')` on logout instead of `/landing`

### 6. No Volunteer Dashboard Screen
- There is a volunteer *features* folder with task screens, but **no volunteer dashboard** screen
- The volunteer folder has no dashboard — only individual task pages

### 7. No Freelancer Dashboard Screen
- No freelancer dashboard exists at all — no folder, no screen

### 8. Admin Dashboard Is Just a Placeholder
- `admin_dashboard_screen.dart` is 14 lines — just a placeholder text

### 9. Route Guards Are Missing
- No redirect logic in the router — any URL can be accessed without authentication

---

## User Review Required

> [!IMPORTANT]
> Since Supabase stores the role in `user.userMetadata['role']`, the role-based routing will rely on this field. If existing users don't have this field set, they will land on a fallback screen (volunteer dashboard). This is acceptable behavior and will be documented.

> [!WARNING]
> The landing page will be a Flutter Web page (not a separate HTML site). It will use Flutter's web renderer and be fully responsive using `LayoutBuilder` and `MediaQuery`. This is consistent with the existing stack (Flutter Web + Go Router).

---

## Proposed Changes

### Landing Page (NEW)

#### [NEW] `lib/features/landing/landing_screen.dart`
Full responsive landing page with:
- Navigation bar (Home, About, Features, How it Works, Contact, Login, Register)
- Hero section with CTA
- About GivTask
- Features section
- How it Works
- Statistics
- Benefits (NGOs, Volunteers, Freelancers)
- Testimonials
- FAQ (expandable)
- Contact section
- Footer

---

### Routing (MODIFY)

#### [MODIFY] `lib/core/routing/app_router.dart`
- Change initial route from `/` to `/landing`
- Add `/landing` route → `LandingScreen`
- Add `/volunteer-dashboard` route → `VolunteerDashboardScreen`
- Add `/freelancer-dashboard` route → `FreelancerDashboardScreen`
- Add redirect logic: check auth state on every route change
- Protect dashboard routes (require auth)
- Public routes: `/landing`, `/login`, `/register`, `/role-selection`, `/onboarding`
- Splash screen becomes role-aware redirector after session check

---

### Authentication Fixes (MODIFY)

#### [MODIFY] `lib/features/auth/login_screen.dart`
- After successful login, read `user.userMetadata['role']`
- Route to correct dashboard based on role:
  - `volunteer` → `/volunteer-dashboard`
  - `freelancer` → `/freelancer-dashboard`
  - `ngo` → `/ngo-dashboard`
  - `admin` → `/admin-dashboard`
  - fallback → `/volunteer-dashboard`

#### [MODIFY] `lib/features/auth/register_screen.dart`
- After successful registration, route to correct dashboard (not to `/login`)

#### [MODIFY] `lib/features/auth/splash_screen.dart`
- On init, check auth state + role → route to correct dashboard or `/landing`

#### [MODIFY] `lib/features/shared/settings_screen.dart`
- Logout should redirect to `/landing` not `/login`

---

### New Dashboards (NEW + MODIFY)

#### [NEW] `lib/features/volunteer/volunteer_dashboard_screen.dart`
Full volunteer dashboard with:
- Profile header (name, email, role badge)
- Stats: applications, active tasks, completed, hours
- Quick actions
- Recent activity

#### [NEW] `lib/features/freelancer/freelancer_dashboard_screen.dart`
Full freelancer dashboard with:
- Profile header
- Stats: earnings, active projects, completed
- Quick actions
- Recent projects

#### [MODIFY] `lib/features/ngo/ngo_dashboard_screen.dart`
- Add profile header showing logged-in NGO user info (name, email, role)
- Keep existing task management features

#### [MODIFY] `lib/features/admin/admin_dashboard_screen.dart`
- Replace placeholder with real admin dashboard
- Show admin profile header
- Platform stats
- Quick links to admin features

---

### Home Screen Fix (MODIFY)

#### [MODIFY] `lib/features/shared/home_screen.dart`
- Make it role-aware: read user role and render appropriate dashboard
- OR: Remove `/home` as the post-login destination entirely (preferred approach)
- Each role gets its own dashboard screen with its own nav bar

---

## Verification Plan

### Automated Tests
- `flutter analyze` — to check for compilation errors

### Manual Verification
- Open `/` → Should see the landing page (not onboarding/login)
- Click Login → Should see login screen
- Login as NGO user → Should land on NGO dashboard showing correct name/email
- Login as Volunteer → Should land on Volunteer dashboard
- Login as Freelancer → Should land on Freelancer dashboard
- Refresh browser while logged in → Should stay on correct dashboard (session persisted by Supabase)
- Logout → Should go to landing page
- Try navigating to `/ngo-dashboard` while logged out → Should redirect to `/login`
