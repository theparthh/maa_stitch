---
name: auto-route
description: "Routing for this Flutter app using auto_route package. Use whenever creating a new screen, navigating between screens, or modifying routes. All screens MUST have @RoutePage() annotation. All routes MUST be in app_router.dart. NEVER use Navigator.push or any other routing method."
---

# Auto Route Skill

## Package
- `auto_route: ^11.1.0`
- `auto_route_generator: ^10.4.0`

---

## 1. Adding a New Screen — Checklist

```
[ ] Add @RoutePage() annotation to screen widget
[ ] Import screen in lib/app/router/app_router.dart
[ ] Add AutoRoute(page: YourScreenRoute.page) to routes list
[ ] Run: flutter pub run build_runner build --delete-conflicting-outputs
[ ] Navigate using AppRouteHandler.route
```

---

## 2. Screen Annotation (MANDATORY)

```dart
// lib/features/<feature>/view/<feature>_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}
```

---

## 3. Router Configuration

```dart
// lib/app/router/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:scorer/features/home/home.dart';
import 'package:scorer/features/match_setup/match_setup.dart';
import 'package:scorer/features/scoring/scoring.dart';
import 'package:scorer/features/match_result/match_result.dart';
import 'package:scorer/features/match_details/match_details.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: MatchSetupRoute.page),
        AutoRoute(page: ScoringRoute.page),
        AutoRoute(page: InningsScorecardRoute.page),
        AutoRoute(page: MatchResultRoute.page),
        AutoRoute(page: MatchDetailsRoute.page),
        AutoRoute(page: SuperOverRoute.page),
      ];
}
```

---

## 4. Route Handler

```dart
// lib/app/router/app_route_handler.dart
import 'package:auto_route/auto_route.dart';
import 'package:scorer/app/router/app_router.dart';

class AppRouteHandler {
  AppRouteHandler._();
  static late AppRouter route;
}
```

---

## 5. App Bootstrap (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  AppRouteHandler.route = AppRouter();
  runApp(const ScorerApp());
}

// lib/app/app.dart
class ScorerApp extends StatelessWidget {
  const ScorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouteHandler.route.config(),
      // ...
    );
  }
}
```

---

## 6. Navigation (MANDATORY — only these patterns)

```dart
import 'package:scorer/app/router/app_route_handler.dart';
import 'package:scorer/app/router/app_router.dart';

// Push a new screen
AppRouteHandler.route.push(const HomeRoute());

// Push with params
AppRouteHandler.route.push(ScoringRoute(matchId: 'abc123'));

// Replace current screen
AppRouteHandler.route.replace(const MatchResultRoute());

// Pop current screen
AppRouteHandler.route.pop();

// Pop back to specific route
AppRouteHandler.route.popUntilRouteWithName(HomeRoute.name);
```

---

## 7. Passing Parameters

```dart
// In router:
AutoRoute(page: ScoringRoute.page),

// Screen definition with param:
@RoutePage()
class ScoringScreen extends StatelessWidget {
  const ScoringScreen({super.key, @PathParam('matchId') required this.matchId});
  final String matchId;
  // ...
}

// Navigate with param:
AppRouteHandler.route.push(ScoringRoute(matchId: match.id));
```

---

## 8. Build Runner (Run after every route change)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 9. Never Use These

```dart
// ❌ NEVER
Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
Navigator.pushNamed(context, '/home');
Navigator.of(context).push(...);
context.go('/home');            // go_router
```

---

## Screen List (This App)

| Screen | Route Class | Feature |
|---|---|---|
| Home (Match List) | `HomeRoute` | `home` |
| New Match Setup | `MatchSetupRoute` | `match_setup` |
| Live Scoring | `ScoringRoute(matchId)` | `scoring` |
| Innings Scorecard | `InningsScorecardRoute(matchId, inningsNum)` | `scoring` |
| Match Result | `MatchResultRoute(matchId)` | `match_result` |
| Match Details | `MatchDetailsRoute(matchId)` | `match_details` |
| Super Over | `SuperOverRoute(matchId)` | `super_over` |
