---
name: get-it-di
description: "Dependency injection setup using get_it for this Flutter app. Use whenever adding new repositories, blocs, services, or any injectable dependency. DI must be initialized before runApp. Never instantiate repos/services directly in UI or BLoC."
---

# get_it Dependency Injection Skill

## Package
```yaml
get_it: ^7.7.0
```

---

## 1. Folder Structure

```
lib/app/di/
├── di.dart                  ← barrel (exports injection.dart)
├── injection.dart           ← initDependencies() entry point
├── bloc_module.dart         ← BLoC / Cubit registrations
├── repository_module.dart   ← Repository registrations
└── service_module.dart      ← External service registrations
```

---

## 2. Main Entry Point

```dart
// lib/app/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:scorer/di/di.dart';
import 'package:scorer/services/isar/isar_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Init external services first
  await IsarService.init();

  // 2. Register modules (order matters — services before repos, repos before blocs)
  _registerServices();
  _registerRepositories();
  _registerBlocs();
}
```

---

## 3. Service Module

```dart
// lib/app/di/service_module.dart
import 'package:isar/isar.dart';
import 'package:scorer/services/isar/isar_service.dart';

void _registerServices() {
  getIt.registerSingleton<Isar>(IsarService.instance);
}
```

---

## 4. Repository Module

```dart
// lib/app/di/repository_module.dart
import 'package:scorer/features/home/home.dart';
import 'package:scorer/features/match_setup/match_setup.dart';
import 'package:scorer/features/scoring/scoring.dart';

void _registerRepositories() {
  getIt.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(isar: getIt<Isar>()),
  );
  getIt.registerLazySingleton<ScoringRepository>(
    () => ScoringRepositoryImpl(isar: getIt<Isar>()),
  );
  getIt.registerLazySingleton<MatchDetailsRepository>(
    () => MatchDetailsRepositoryImpl(isar: getIt<Isar>()),
  );
}
```

---

## 5. BLoC Module

```dart
// lib/app/di/bloc_module.dart
import 'package:scorer/features/home/home.dart';
import 'package:scorer/features/match_setup/match_setup.dart';
import 'package:scorer/features/scoring/scoring.dart';

void _registerBlocs() {
  // Register as Factory — new instance per screen
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(repository: getIt<MatchRepository>()),
  );
  getIt.registerFactory<MatchSetupCubit>(
    () => MatchSetupCubit(repository: getIt<MatchRepository>()),
  );
  getIt.registerFactory<ScoringBloc>(
    () => ScoringBloc(repository: getIt<ScoringRepository>()),
  );
  getIt.registerFactory<MatchDetailsCubit>(
    () => MatchDetailsCubit(repository: getIt<MatchDetailsRepository>()),
  );
  getIt.registerFactory<MatchResultCubit>(
    () => MatchResultCubit(repository: getIt<MatchRepository>()),
  );
}
```

---

## 6. main.dart Bootstrap

```dart
// lib/main.dart
import 'package:scorer/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();               // ← MUST be before runApp
  AppRouteHandler.route = AppRouter();
  runApp(const ScorerApp());
}
```

---

## 7. Using DI in UI (BlocProvider)

```dart
// In screen/widget — wrap with BlocProvider for Factory
BlocProvider(
  create: (_) => getIt<HomeCubit>()..load(),
  child: const HomeScreen(),
)
```

---

## 8. Registration Types

| Type | Use When |
|---|---|
| `registerSingleton` | One instance forever (Isar, AppRouter) |
| `registerLazySingleton` | One instance, created on first use (repos) |
| `registerFactory` | New instance every time (BLoCs, Cubits) |

---

## 9. Adding a New Feature — DI Checklist

```
[ ] Create repository class with Isar injected via constructor
[ ] Create BLoC/Cubit with repository injected via constructor
[ ] Register repository in repository_module.dart (lazySingleton)
[ ] Register BLoC/Cubit in bloc_module.dart (factory)
[ ] Export new registrations via di.dart barrel if needed
```

---

## Rules
| ✅ Do | ❌ Don't |
|---|---|
| Use `getIt<T>()` to resolve in `BlocProvider` | Instantiate BLoC with constructor in UI |
| Register repos as `lazySingleton` | Create repo directly in BLoC |
| Register BLoCs as `factory` | Register BLoC as `singleton` (stale state) |
| Init DI before `runApp()` | Access `getIt` before `initDependencies()` |
| Inject Isar via constructor | Access `IsarService.instance` directly in repo |
