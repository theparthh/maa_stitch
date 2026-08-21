---
name: feature-architecture
description: "Clean architecture folder structure and barrel import rules for this Flutter app. Use whenever creating or modifying any feature. Every feature follows data/domain/presentation layers with strict separation. All imports must go through barrel files — never deep imports."
---

# Feature Architecture Skill

## Mandatory Folder Layout (Clean Architecture)

Every feature MUST follow this exact structure:

```
lib/features/<feature_name>/
├── <feature_name>.dart              ← feature barrel (exports all layers)
├── data/
│   ├── data.dart                    ← barrel
│   └── repositories/
│       ├── repositories.dart        ← barrel
│       └── <feature>_repository_impl.dart  ← concrete implementations
├── domain/
│   ├── domain.dart                  ← barrel
│   ├── models/
│   │   ├── models.dart              ← barrel
│   │   └── <model>_model.dart
│   └── repositories/
│       ├── repositories.dart        ← barrel
│       └── <feature>_repository.dart  ← abstract interfaces
└── presentation/
    ├── presentation.dart            ← barrel
    ├── cubit/
    │   ├── cubit.dart               ← barrel
    │   ├── <feature>_cubit.dart
    │   └── <feature>_state.dart
    ├── screens/
    │   ├── screens.dart             ← barrel
    │   └── <feature>_screen.dart    ← @RoutePage() screen
    └── widgets/
        ├── widgets.dart             ← barrel
        └── <widget_name>_widget.dart ← ONE widget per file
```

---

## Layer Responsibilities

| Layer | Purpose |
|-------|---------|
| **data/** | Concrete implementations, data sources, external API calls |
| **domain/** | Business logic, pure Dart models, abstract repository interfaces |
| **presentation/** | UI layer - Cubit state management, screens, widgets |

---

## Feature Barrel File

```dart
// lib/features/<feature>/<feature>.dart
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
```

## Sub-Barrel Examples

```dart
// data/data.dart
export 'repositories/repositories.dart';

// data/repositories/repositories.dart
export '<feature>_repository_impl.dart';

// domain/domain.dart
export 'models/models.dart';
export 'repositories/repositories.dart';

// domain/models/models.dart
export '<model>_model.dart';

// domain/repositories/repositories.dart
export '<feature>_repository.dart';

// presentation/presentation.dart
export 'cubit/cubit.dart';
export 'screens/screens.dart';
export 'widgets/widgets.dart';

// presentation/cubit/cubit.dart
export '<feature>_cubit.dart';
export '<feature>_state.dart';

// presentation/screens/screens.dart
export '<feature>_screen.dart';

// presentation/widgets/widgets.dart
export '<widget_a>_widget.dart';
export '<widget_b>_widget.dart';
```

---

## Barrel Import Rules (STRICT)

### ✅ Always import the barrel — never the file directly

```dart
// ✅ Correct
import 'package:scorer/features/home/home.dart';
import 'package:scorer/core/core.dart';
import 'package:scorer/theme/theme.dart';
import 'package:scorer/widgets/widgets.dart';

// ❌ Wrong — deep imports
import 'package:scorer/features/home/presentation/cubit/home_cubit.dart';
import 'package:scorer/features/home/domain/models/match_model.dart';
import 'package:scorer/theme/app_colors.dart';
```

---

## Widget Rules

1. **One widget class per file** — no exceptions
2. File name: `<widget_name>_widget.dart` (snake_case)
3. Class name: `<WidgetName>Widget` (PascalCase)
4. Place in: `lib/features/<feature>/presentation/widgets/`
5. Export in: `widgets/widgets.dart` barrel

```dart
// ✅ Good: login_button_widget.dart
class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ...;
  }
}

// ❌ Bad: multiple classes in one file
class LoginButtonWidget extends StatelessWidget { ... }
class LoginFormWidget extends StatelessWidget { ... }  // DON'T
```

---

## Repository Pattern

```dart
// domain/repositories/<feature>_repository.dart (interface)
abstract class MatchRepository {
  Future<List<MatchModel>> getMatches();
  Future<void> saveMatch(MatchModel match);
}

// data/repositories/<feature>_repository_impl.dart (implementation)
class MatchRepositoryImpl implements MatchRepository {
  final DataSource _dataSource;

  MatchRepositoryImpl(this._dataSource);

  @override
  Future<List<MatchModel>> getMatches() async {
    // implementation details
  }
}
```

---

## Screen Checklist (New Screen)

```
[ ] Create <feature>_screen.dart with @RoutePage() annotation
[ ] Add to presentation/screens/screens.dart barrel
[ ] Register route in lib/app/router/app_router.dart
[ ] Run build_runner
[ ] Create Cubit with state in presentation/cubit/
[ ] Add all widgets as separate files under presentation/widgets/
[ ] Export all widgets in widgets/widgets.dart
[ ] Create repository interface in domain/repositories/
[ ] Create repository implementation in data/repositories/
[ ] Register DI (repo + cubit) in lib/app/di/
[ ] Add strings to assets/l10n/en.json
[ ] Run slidy run generateLocal
```

---

## Top-Level lib/ Structure

```
lib/
├── app/                    ← MaterialApp, app shell, cross-cutting app code
│   ├── app.dart            ← root app widget (e.g. MaterialApp.router)
│   ├── core/               ← app-wide constants, theme (barrel: core.dart)
│   ├── di/                 ← get_it registration (injection + modules)
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── app_router.gr.dart   (generated — DO NOT EDIT)
│   │   └── app_route_handler.dart
│   ├── services/           ← app-scoped services / facades
│   └── widgets/            ← shared widgets used across features
├── features/               ← feature modules (clean architecture)
├── generated/              ← flutter_gen output (DO NOT EDIT)
├── config/                 ← env, flavours, sentry
├── l10n/                   ← generated localization (DO NOT EDIT)
├── services/               ← top-level external integrations / service wrappers
└── main.dart               ← entry (typically exports app/app.dart)
```

---

## Cleanup Rules

When revising features:
1. Search for any unused widget files: `grep -r "WidgetName" lib/features/<feature>/`
2. If not referenced anywhere → delete the file
3. Remove its export from `widgets.dart` barrel
4. Verify no compile errors after removal

---

## Unused File Cleanup
- Remove unused widget files whenever code is updated/revised
- Check barrel files for dangling exports
- Never leave dead code in the codebase
