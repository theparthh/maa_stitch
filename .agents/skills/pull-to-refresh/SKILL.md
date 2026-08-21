---
name: pull-to-refresh
description: Pull-to-refresh using custom_refresh_indicator, AppPullToRefresh, and BLoC silent refresh with reliable completion. Use when adding PTR to a screen, wiring onRefresh to blocs, or fixing stuck indicators / shimmers during refresh.
---

# Pull-to-refresh (Clix)

## When to Use

- Wrapping a **scrollable** screen or tab so the user can reload data with a pull gesture.
- Wiring **`onRefresh`** to one or more **BLoCs** (or repositories) and ensuring the **material indicator dismisses** when work finishes.
- Avoiding **full-screen shimmers** during refresh while **initial load** still uses loading states.

## Dependencies

```yaml
# pubspec.yaml
dependencies:
  custom_refresh_indicator: ^4.0.1
```

Do **not** add a second pull-to-refresh package for the same screen; this project standardizes on **`custom_refresh_indicator`** via **`AppPullToRefresh`**.

## App wrapper: `AppPullToRefresh`

- **Location:** `lib/app/widgets/app_pull_to_refresh.dart`
- **Import:** `package:clix/app/widgets/widgets.dart` (barrel)
- **Implementation:** wraps **`CustomMaterialIndicator`** (Material-style indicator, Clix colors: `AppColors.accent` / `AppColors.surface` by default).

### Rules

1. **`child` must be a scrollable** that participates in scroll notifications (`ListView`, `GridView`, `SingleChildScrollView`, `CustomScrollView`, etc.).
2. **`onRefresh`** must return a **`Future<void>`** that completes **only after** all async refresh work is done (same contract as Flutter’s `RefreshIndicator`).
3. On **Android**, if content is **shorter than the viewport**, default physics may prevent overscroll — set:

   ```dart
   physics: const AlwaysScrollableScrollPhysics(),
   ```

   on the scrollable inside `AppPullToRefresh`.

## `BuildContext` and providers

`onRefresh` closures often need **`context.read<SomeBloc>()`**. The **`BuildContext` from `build(BuildContext context)`** of a widget that **creates** `BlocProvider` is **above** those providers — **`read` will throw**.

**Fix:** wrap the subtree that needs bloc access in a **`Builder`** and pass the **inner** `BuildContext` into `onRefresh`:

```dart
MultiBlocProvider(
  providers: [...],
  child: Builder(
    builder: (innerContext) {
      return AppPullToRefresh(
        onRefresh: () => _refresh(innerContext),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ...,
        ),
      );
    },
  ),
)
```

## BLoC: initial load vs pull-to-refresh

| Concern | Initial load (`*Started`) | Pull-to-refresh (`*Refreshed`) |
|--------|---------------------------|---------------------------------|
| Purpose | First paint / cold open | User-triggered reload |
| Loading UI | Emit **`*Loading`** → shimmers / placeholders OK | **Silent** fetch — **do not** emit `*Loading` so **previous content stays visible** |
| Completion signal | N/A for indicator | Must signal when fetch **finishes** (see below) |

Implement **`_fetchSilent`** (no loading emit) for refreshed handlers, and keep **`_fetch`** (loading first) for started handlers, or share a private loader method used only from `_fetch`.

## Reliable completion (do not use `bloc.stream.firstWhere` alone)

**Problem:** Waiting for a “settled” state via **`stream.firstWhere`** can **hang forever** because:

- `bloc` **skips `emit`** when the new state **equals** the current state (Equatable).
- Example: refresh while logged out → `ContinueWatchingUnavailable()` again → **no stream event** → `Future` never completes → **PTR spinner stuck**.

**Pattern:** add an optional **`onFinished`** (or similar) on **`*Refreshed`** events:

- **Do not** put the callback in **`props`** (override `props` to `[]` for that event, or exclude the callback from equality) so Equatable does not break usage.
- In **`_onRefreshed`**, use **`try` / `finally`** and always call **`event.onFinished?.call()`** after the silent fetch path completes (success, failure, or duplicate state).

**Screen:**

```dart
import 'dart:async';

Future<void> _refresh(BuildContext context) async {
  final a = context.read<FeatureABloc>();
  final b = context.read<FeatureBBloc>();

  final doneA = Completer<void>();
  final doneB = Completer<void>();

  void safeComplete(Completer<void> c) {
    if (!c.isCompleted) c.complete();
  }

  a.add(FeatureARefreshed(onFinished: () => safeComplete(doneA)));
  b.add(FeatureBRefreshed(onFinished: () => safeComplete(doneB)));

  await Future.wait<void>([doneA.future, doneB.future]);
}
```

## Multi-section home pattern

When one screen coordinates **several** blocs (e.g. carousel + continue watching + categories):

- Dispatch all **`*Refreshed`** events with **per-bloc `onFinished`**.
- **`await Future.wait`** on all completers so the **single** `AppPullToRefresh` indicator runs until **every** section finishes.

Reference: `lib/features/home/presentation/screens/home_screen.dart`.

## Customization

`AppPullToRefresh` forwards **`CustomMaterialIndicator`** options (`trigger`, `triggerMode`, `displacement`, `indicatorBuilder`, etc.). Prefer adjusting those over forking the widget unless behavior must change app-wide.

## Anti-patterns

- **`Navigator` / manual `RefreshIndicator`** for app chrome — use **`AppPullToRefresh`** for consistency.
- **`context.read` from the wrong `BuildContext`** above `BlocProvider` — use **`Builder`**.
- **Emitting `*Loading` on refresh** when the UI maps loading to **shimmers** — use **silent refresh** for PTR.
- **Awaiting refresh completion via stream** without handling **duplicate** terminal states — use **`onFinished` + `Completer`**.

## Checklist (new screen)

- [ ] Scrollable has **`AlwaysScrollableScrollPhysics`** if PTR must work with short content (especially Android).
- [ ] `onRefresh` uses a **`BuildContext` under** all needed `BlocProvider`s (**`Builder`** if providers are created in the same `build`).
- [ ] `*Refreshed` handlers use **silent fetch** (no loading shimmer state).
- [ ] `*Refreshed` completes **`onRefresh`** via **`try/finally`** + **`Completer`**, not stream-only waiting.
