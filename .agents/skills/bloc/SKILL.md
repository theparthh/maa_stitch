---
name: bloc-cubit
description: "BLoC state management patterns using flutter_bloc for this Flutter app. Use for all application/feature state. Never use setState — use ValueNotifier for small local state, BLoC for feature-level state. Covers Events, States, BLoC wiring, and BlocBuilder/BlocListener usage."
---

# BLoC Skill (flutter_bloc)

## When to Use

- **BLoC**: Always — for all feature-level and application state
- **ValueNotifier**: ONLY for tiny local UI state (button press scale, toggle visibility)
- **NEVER**: `setState` anywhere in the codebase
- **NEVER**: Cubit — always use BLoC with explicit events

---

## Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5
```

---

## File Structure (Per Feature)

```
lib/features/<feature>/controllers/
├── controllers.dart          ← barrel
├── <feature>_bloc.dart       ← BLoC class
├── <feature>_event.dart      ← Events
└── <feature>_state.dart      ← States
```

---

## BLoC Pattern (Events + States)

### State

```dart
// <feature>_state.dart
part of '<feature>_bloc.dart';

sealed class <Feature>State extends Equatable {
  const <Feature>State();
  @override List<Object?> get props => [];
}

final class <Feature>Initial extends <Feature>State {
  const <Feature>Initial();
}

final class <Feature>Loading extends <Feature>State {
  const <Feature>Loading();
}

final class <Feature>Loaded extends <Feature>State {
  const <Feature>Loaded(this.data);
  final SomeModel data;
  @override List<Object?> get props => [data];
}

final class <Feature>Error extends <Feature>State {
  const <Feature>Error(this.message);
  final String message;
  @override List<Object?> get props => [message];
}
```

### Event

```dart
// <feature>_event.dart
part of '<feature>_bloc.dart';

sealed class <Feature>Event extends Equatable {
  const <Feature>Event();
  @override List<Object?> get props => [];
}

final class Load<Feature>Event extends <Feature>Event {
  const Load<Feature>Event();
}

final class Delete<Feature>Event extends <Feature>Event {
  const Delete<Feature>Event(this.id);
  final String id;
  @override List<Object?> get props => [id];
}
```

### BLoC

```dart
// <feature>_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scorer/features/<feature>/<feature>.dart';

part '<feature>_event.dart';
part '<feature>_state.dart';

class <Feature>Bloc extends Bloc<<Feature>Event, <Feature>State> {
  <Feature>Bloc({required <Feature>Repository repository})
      : _repository = repository,
        super(const <Feature>Initial()) {
    on<Load<Feature>Event>(_onLoad);
    on<Delete<Feature>Event>(_onDelete);
  }

  final <Feature>Repository _repository;

  Future<void> _onLoad(
    Load<Feature>Event event,
    Emitter<<Feature>State> emit,
  ) async {
    emit(const <Feature>Loading());
    try {
      final data = await _repository.getData();
      emit(<Feature>Loaded(data));
    } catch (e) {
      emit(<Feature>Error(e.toString()));
    }
  }

  Future<void> _onDelete(
    Delete<Feature>Event event,
    Emitter<<Feature>State> emit,
  ) async {
    emit(const <Feature>Loading());
    try {
      await _repository.delete(event.id);
      final data = await _repository.getData();
      emit(<Feature>Loaded(data));
    } catch (e) {
      emit(<Feature>Error(e.toString()));
    }
  }
}
```

---

## UI: BlocBuilder & BlocListener

### BlocBuilder — Rebuild UI on state

```dart
BlocBuilder<<Feature>Bloc, <Feature>State>(
  builder: (context, state) {
    return switch (state) {
      <Feature>Initial() => const SizedBox.shrink(),
      <Feature>Loading() => const CircularProgressIndicator(),
      <Feature>Loaded(:final data) => YourContentWidget(data: data),
      <Feature>Error(:final message) => Text(message),
    };
  },
)
```

### BlocListener — Side effects (navigation, snackbar)

```dart
BlocListener<<Feature>Bloc, <Feature>State>(
  listener: (context, state) {
    if (state is <Feature>Error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)
```

### BlocConsumer — Both rebuild + side effects

```dart
BlocConsumer<<Feature>Bloc, <Feature>State>(
  listener: (context, state) { /* side effects */ },
  builder: (context, state) {
    return switch (state) {
      <Feature>Initial() => const SizedBox.shrink(),
      <Feature>Loading() => const CircularProgressIndicator(),
      <Feature>Loaded(:final data) => YourContentWidget(data: data),
      <Feature>Error(:final message) => Text(message),
    };
  },
)
```

### MultiBlocProvider — Provide multiple BLoCs

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<<Feature>Bloc>()..add(const Load<Feature>Event())),
    BlocProvider(create: (_) => getIt<OtherBloc>()),
  ],
  child: const <Feature>Screen(),
)
```

### BlocSelector — Rebuild only when selected state changes

```dart
BlocSelector<<Feature>Bloc, <Feature>State, bool>(
  selector: (state) => state is <Feature>Loading,
  builder: (context, isLoading) {
    return isLoading ? const CircularProgressIndicator() : const Content();
  },
)
```

---

## Provided via DI (get_it)

```dart
// In UI — access BLoC from DI
BlocProvider(
  create: (_) => getIt<<Feature>Bloc>()..add(const Load<Feature>Event()),
  child: const <Feature>Screen(),
)
```

### Accessing BLoC in descendants

```dart
// Using context.read to dispatch events (no rebuild)
context.read<<Feature>Bloc>().add(const SomeEvent());

// Using BlocBuilder is preferred for reading state
// Avoid context.watch — use BlocBuilder or BlocSelector instead
```

---

## Local State (ValueNotifier — Not BLoC)

```dart
// For small UI-only state on a single widget
final ValueNotifier<bool> _isExpanded = ValueNotifier<bool>(false);

// In build:
ValueListenableBuilder<bool>(
  valueListenable: _isExpanded,
  builder: (context, isExpanded, child) {
    return GestureDetector(
      onTap: () => _isExpanded.value = !_isExpanded.value,
      child: Text(isExpanded ? 'Less' : 'More'),
    );
  },
)

// Dispose:
@override
void dispose() {
  _isExpanded.dispose();
  super.dispose();
}
```

---

## Rules Summary

| ✅ Do                                      | ❌ Don't                           |
| ------------------------------------------ | ---------------------------------- |
| Use `flutter_bloc` package                 | Use `bloc` package directly        |
| Use BLoC with Events for all feature state | Use setState                       |
| Use `sealed class` for states and events   | Use Cubit                          |
| Use `Equatable` on states/events           | Mix business logic into UI         |
| Use `BlocBuilder` for UI rebuilds          | Use raw strings/enums for state    |
| Use `BlocListener` for side effects        | Forget to implement props          |
| Use `ValueNotifier` for local UI           | Use BLoC for single-widget toggles |
| Use `context.read` to dispatch events      | Use `context.watch` for events     |
| Dispose controllers                        | Forget dispose                     |
