---
name: app-connectivity-gate
description: AppConnectivityGate (one-shot offline UI on screen entry), ConnectivityHelper for checks, and refresh-time connectivity (pull-to-refresh + error toast). Use when wrapping screens for offline entry, adding PTR connectivity checks, or avoiding duplicate connectivity logic; reference HomeScreen patterns.
---

# App connectivity gate & refresh checks (Clix)

## When to use this skill

- Wrapping a **screen** so the first paint runs a **single** connectivity check (no live listener).
- Showing **full-screen no internet** (centered empty state + Try again) only when that **initial** check fails.
- Running a **manual** re-check on **Try again**, then hiding the blocker and calling **`onRetry`** (full reload with shimmers).
- **Pull-to-refresh:** before silent BLoC refresh, verify connectivity and show an **error toast** if offline (see HomeScreen).
- Centralizing **`ConnectivityHelper`** instead of duplicating `ConnectivityResult` rules.

Related: **pull-to-refresh** skill (silent `*Refreshed` events, completers). This skill covers **when** to gate entry vs **when** to guard PTR.

---

## `ConnectivityHelper`

- **File:** `lib/app/core/helpers/connectivity_helper.dart`
- **Import:** `package:clix/app/core/core.dart` (barrel includes helpers) or `.../connectivity_helper.dart`

| API | Use |
|-----|-----|
| `checkConnectivity()` | `Future<List<ConnectivityResult>>` — one-shot snapshot |
| `isOnline(results)` | `true` if there is a real path (not only `none`) |
| `checkIsOnline()` | Awaits check + returns bool |
| `onConnectivityChanged` | Stream — for **`AppConnectivityBanner`** only; **do not** use inside `AppConnectivityGate` |

---

## `AppConnectivityGate`

- **File:** `lib/app/widgets/app_connectivity_gate.dart`
- **Barrel:** `package:clix/app/widgets/widgets.dart`

### Behavior (contract)

1. **No connectivity subscription.** Losing network **after** the screen is shown does **not** open the gate UI.
2. **On first build:** `ConnectivityHelper.checkConnectivity()` → if offline, full-screen **`AppEmptyStateLayoutWidget`** (wifi icon, `LocaleKeys.noInternet` / `checkYourInternet`, Try again).
3. **While the first check runs:** solid `AppColors.background` placeholder (child not built yet).
4. **Try again:** `checkConnectivity()` again; if still offline → haptic; if online → hide gate, **`await onRetry()`**.
5. **Do not** auto-dismiss when the OS reports “back online” — only **Try again** after a successful check dismisses.

### API

```dart
AppConnectivityGate(
  onRetry: () => _reloadAfterOffline(context), // Future<void> — full reload
  child: /* normal screen body */,
)
```

### `onRetry` vs pull-to-refresh

- **Gate `onRetry`:** use **`*Started`**-style reload so sections show **loading/shimmers** (same as cold open). Example: Home dispatches `CarouselStarted`, `ContinueWatchingStarted`, `SeriesByCategoryStarted`.
- **PTR `onRefresh`:** use **`*Refreshed`** + completers (silent refresh) — see pull-to-refresh skill; **also** run a connectivity check first (below).

---

## HomeScreen reference (real wiring)

**File:** `lib/features/home/presentation/screens/home_screen.dart`

### Stack order (outside → inside)

1. `MultiBlocProvider` (home section BLoCs + `*Started` in `create`)
2. `Builder` → **`innerContext`** for `read` below providers
3. **`AppConnectivityGate`** (`onRetry` → `_reloadHomeAfterOffline`)
4. `ShellTabScaffoldWidget` → `AppPullToRefresh` → scrollable content

### Entry reload after offline (`onRetry`)

Dispatches **Started** events (not Refreshed):

```dart
Future<void> _reloadHomeAfterOffline(BuildContext context) async {
  context.read<CarouselBloc>().add(const CarouselStarted());
  context.read<ContinueWatchingBloc>().add(const ContinueWatchingStarted());
  context.read<SeriesByCategoryBloc>().add(const SeriesByCategoryStarted());
}
```

### Refresh connectivity check (PTR)

At the **start** of `_refreshHomeData`:

1. `await ConnectivityHelper.checkConnectivity()`
2. `if (!context.mounted) return;`
3. If `!ConnectivityHelper.isOnline(connectivity)` → `showAppToastError(context, LocaleKeys.connectivity_refreshNoConnection)` and **return** (no BLoC refresh; PTR future completes so the indicator dismisses)
4. Else run parallel `*Refreshed` + completers as usual

**Strings:** `assets/l10n/en.json` — `connectivity_refreshNoConnection`. Regenerate keys after edits:  
`dart run easy_localization:generate -S assets/l10n -f keys -O lib/l10n -o locale_keys.g.dart`

---

## `BuildContext` after `await`

Always **`if (!context.mounted) return;`** immediately after **`await ConnectivityHelper.checkConnectivity()`** before `read` / toast (see `use_build_context_synchronously`).

---

## What not to do

- Do **not** add `onConnectivityChanged` inside `AppConnectivityGate` (product requirement: no mid-session overlay).
- Do **not** use **`*Refreshed`** for gate **Try again** if you want shimmers — use **`*Started`** for that path.
- Do **not** duplicate “is online” logic — use **`ConnectivityHelper.isOnline`**.

---

## Optional: top banner

**`AppConnectivityBanner`** (`lib/app/widgets/app_connectivity_banner.dart`) **does** listen via **`ConnectivityHelper.onConnectivityChanged`** for a thin top strip; that is separate from the gate and is allowed to react to live changes.
