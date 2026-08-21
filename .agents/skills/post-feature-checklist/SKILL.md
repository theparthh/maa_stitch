---
name: post-feature-checklist
description: "MANDATORY post-development checklist to run after completing every feature. Must pass 100% before the feature is considered done. Steps are ordered to eliminate feedback loops — each phase depends only on prior phases being complete."
---

# 🚦 Post-Feature Checklist (MANDATORY)

> **Complete every phase IN ORDER. Do not skip ahead.**
> Each phase depends on the previous being fully clean.
> A feature is NOT done until every item below is checked and passing.
> Do NOT mark a feature complete in `tracker.md` (or your project’s feature tracker) until this passes.

---

## Phase 1: 🧹 Cleanup First

> Remove all noise before any analysis or build runs. Cleaning after analysis causes re-runs — do it first.

- Remove any unused widget files introduced during development
- Remove unused imports from all files touched
- Remove any `TODO` / `FIXME` comments left behind
- Remove any `print()` / `debugPrint()` statements
- Remove any test/debug UI scaffolding
- Ensure no file was accidentally left with placeholder content

---

## Phase 2: 🏗️ Architecture Compliance

> Fix structural issues before building — broken architecture causes build and analysis failures.

- Each widget is in its own separate file (`<name>_widget.dart`)
- No multiple widget classes in a single file
- Zero private widget classes in screen files — every widget lives in its own file under `presentation/widgets/` (feature) or `lib/app/widgets/` (shared app-level)
- Zero methods returning `Widget` — all UI fragments are proper widget classes in separate files (no `Widget _buildX()` methods)
- All imports go through barrel files — zero deep imports
- All barrel files are updated: per feature, typically `<feature>.dart`, `data/data.dart`, `domain/domain.dart`, `presentation/presentation.dart`, `controllers/controllers.dart`, plus nested `models.dart`, `repositories.dart`, `widgets.dart`, `screens.dart` as applicable
- No feature-only widgets under `lib/app/widgets/` — shared, app-wide widgets only
- All new types (repositories, BLoCs, services) are registered in **`lib/app/di/`** (`injection.dart` + `*_module.dart`) — nothing constructed ad hoc in UI or BLoC except where the architecture explicitly allows (e.g. `TextEditingController` in a screen)
- Screen has `@RoutePage()` annotation
- Route is registered in **`lib/app/router/app_router.dart`**

---

## Phase 3: 🔍 Static Analysis

> Run analysis only after build succeeds on clean, correctly structured code — this is the single analyze run.

- Run `flutter analyze` — **zero issues, zero warnings**
- No unused imports anywhere in touched files
- No unused variables or parameters
- No dead code or unreachable branches
- No `// ignore:` or `// ignore_for_file:` comments added without explicit user approval
- All `late` variables are guaranteed to be initialized before use
- No implicit `dynamic` types used
- No red errors in the IDE Problems tab
- No yellow warnings left unaddressed in the Problems tab

---

## Phase 4: 🎨 Theme & UI Compliance

> UI compliance checks after code is structurally stable and compiling clean.

- Zero hardcoded colors — only `AppColors.*` used
- Zero hardcoded `TextStyle` — only `AppTextStyles.*` used
- Zero hardcoded spacing numbers — only `AppSize.*` / `AppGaps.*` used (see **design-guide**)
- Zero hardcoded radius values — only `AppBorderRadius.*` used
- Zero gradients (`LinearGradient`, `RadialGradient`, `SweepGradient`) used anywhere
- Anek Latin font used throughout (via `GoogleFonts.anekLatin` / `AppTextStyles`)
- Bottom navigation follows established patterns: e.g. main tab shell uses **`AutoTabsScaffold`** + **`bottomNavigationBuilder`** (see `MainShellScreen`); a plain **`Scaffold`** may use **`bottomNavigationBar`** for fixed bars — avoid stuffing persistent chrome only inside the body **`Column`** unless the design requires it
- Bars that float or sit above the safe area use project tokens (e.g. `AppSize.size68` bar height, `AppSize.size14` horizontal inset, `AppSize.size19_25` blur sigma) — no one-off magic numbers for bar geometry
- **`resizeToAvoidBottomInset`** is set per screen for keyboard + sheet UX (forms, OTP) — match the screen, not a global default
- ZERO user-visible hardcoded strings — copy goes through **easy_localization**: `assets/l10n/en.json` → generated **`LocaleKeys.*`** (`lib/l10n/`) and **`.tr()`** / project helpers. No raw user-facing English in widgets, BLoCs, toasts, or dialogs (developer-only `kDebugMode` / asserts are fine)

---

## Phase 5: 🧠 State Management Compliance

> Logic compliance — checked after UI layer is confirmed correct. Matches `flutter_bloc` + feature layout under `lib/features/`.

- Zero `setState` — use **BLoC** for feature/application state; use **`ValueNotifier`** only for tiny, widget-local UI state (press/hover, one-off toggles). Do not use `setState` for business rules or state shared beyond a single leaf widget
- **No Cubit** — only **`Bloc<Event, State>`** with explicit event classes (`flutter_bloc` skill)
- BLoCs live in **`lib/features/<feature>/controllers/`** as `<name>_bloc.dart` with **`part`** files for `<name>_event.dart` / `<name>_state.dart`, exported through **`controllers.dart`**
- Events and states follow the existing pattern: **`sealed class`** base, **`final class`** variants, **`Equatable`** with complete **`props`** — no mutable “state bag” objects
- BLoCs are **registered in `lib/app/di/bloc_module.dart`** and resolved with **`getIt<...>()`** inside `BlocProvider` / app wiring — **never** construct a BLoC with manual repository wiring in a screen
- UI uses **`BlocBuilder` / `BlocSelector` / `BlocConsumer`** (and **`BlocListener`** for side effects); dispatch with **`context.read<...Bloc>().add(...)`** — do not use **`context.watch`** for BLoC-driven UI
- BLoC code does not build widgets or take **`BuildContext`** for presentation; navigation/snackbars belong in **`BlocListener`** (or coordinated helpers), not inside `emit` handlers
- **Domain repository interfaces** stay free of BLoC, `BuildContext`, and widget-layer concerns; **data** repository implementations do not reference BLoCs
- Presentation screens/widgets do not call repositories, services, or data sources directly for feature behavior — go through the BLoC (or shared domain helpers used by the BLoC)
- No business rules, branching workflows, or async I/O inside **`build()`**
- Controllers and notifiers owned by a **`State`** are disposed: **`AnimationController`**, **`TextEditingController`**, **`ScrollController`**, **`ValueNotifier`**, etc. — no leaks

---

## Phase 6: 🧭 Routing & Navigation (auto_route)

> Checked after screens compile — navigation mistakes fail at runtime.

- **Never** `Navigator.push` / `pop` or other imperative **`Navigator`** APIs — use **`context.router`**, tab routers, and generated **`*Route`** types (see `.agents/skills/auto-route/SKILL.md`)
- Every routable screen has **`@RoutePage()`** and is wired in **`lib/app/router/app_router.dart`**
- After changing routes, **`@RoutePage()`**, or route params: run **`dart run build_runner build --delete-conflicting-outputs`** so **`app_router.gr.dart`** matches sources
- Nested tab / shell flows follow the existing **`MainShellRoute`** / **`AutoTabsScaffold`** pattern; avoid circular imports — when a shell must reference generated route types, **`part of app_router.dart`** is acceptable (see **`MainShellScreen`**)

---

## Phase 7: 🔒 Security & Data Integrity

> After data flow is plausible end-to-end (network, env, optional persistence).

- No secrets (tokens, API keys, raw `.env` values) or PII in **`print`**, **`debugPrint`**, or casual logs
- **`envied`** / env handling follows existing project patterns — no new secrets committed in plaintext
- User input is validated or normalized before sensitive use (email, OTP, search, etc.) — avoid unguarded **`!`** on nullable API or form data
- **Repositories / data layer:** network and parsing failures are handled — use project patterns (**`master_utility`**, **`Either`**, **`try`/`catch`**) so exceptions do not bubble to **`build()`** as uncaught throws
- **Sentry:** avoid attaching PII to events or breadcrumbs unless explicitly approved
- BLoCs surface failures as **typed error / failure states** (or equivalent) — typical API errors must not white-screen the app

---

## Phase 8: ⚡ Performance

> Optimization pass — done after correctness is fully confirmed.

- No expensive operations inside `build()` methods
- Heavy work (parsing, transcoding decisions, large list prep) stays in repository/BLoC/isolates as appropriate — not in widgets
- `AnimatedBuilder` / `AnimatedWidget` used instead of `setState` in animation listeners where animations are used
- Long lists use **`ListView.builder`** (or sliver equivalents) — not unbounded `ListView`/`Column` with huge child lists
- No unnecessary widget rebuilds — use `const` constructors where possible
- Images and vectors use **`flutter_gen`** (`AppAssets`, generated color accessors) — no raw string asset paths

---

## Phase 9: 📐 Spec Compliance

> Final verification against requirements — done last so implementation changes cannot invalidate it.

- Feature matches its `.md` spec file **exactly** — re-read the spec and verify
- All acceptance criteria listed in the feature file are satisfied
- All edge cases listed in the feature file are handled
- Out-of-scope items were **NOT accidentally implemented**
- No assumptions were added without documenting them in the spec
- UI layout matches the ASCII wireframe / description in the spec

---

## Phase 10: 📝 Documentation & Tracker

> Documentation is the last step — written only after everything above is confirmed complete.

- **Feature README (mandatory):** For each `lib/features/<feature_name>/` touched or added, create or update **`README.md`** in that folder. Follow `.agents/skills/feature-readme/SKILL.md`: short summary, bullets for main types, file list, **`## Flow chart`** with **ASCII** + **Mermaid**, link to spec if any. One README per feature — not a single app-wide substitute.
- Add a short explanation of the completed feature to the **repo root** `README.md` if the project uses one (high-level only; details stay in the feature README).
- Note any newly added packages or system dependencies in the root `README.md` if significant (e.g. vendored `video_player_android` fork).
- If the repo uses a **`tracker.md`** (or similar), mark the feature **`[x]`** when fully done.

---

## Phase 11: ✅ Final Gate

> One final end-to-end confirm. No new runs of earlier phases should be needed if order was followed.

- `flutter analyze` → **0 issues** (confirmation only — should already be clean from Phase 3)
- App runs on device or simulator with no crashes through the full feature flow
- Feature spec `.md` file re-read and all points confirmed
- If the project defines **git hooks** or **CI checks** for analyze/tests, they pass on commit — do not use `--no-verify` to skip agreed checks

---

> **If any item is unchecked, fix it and continue from that phase.**
> You should never need to go back more than one phase if the order was followed correctly.
