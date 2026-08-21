---
name: flutter-api-master-utility
description: Use when implementing REST calls, bearer auth, token refresh, Either-based errors, or wiring repositories into BLoCs with master_utility; use when code uses raw Dio outside dioClient, skips getResponseWithMapper/fold (jsonMapper vs listJsonMapper), omits RefreshTokenConfiguration for JWT APIs, or calls APIService from BLoC widgets directly.
---

# Flutter API calls (master_utility)

## Overview

Configure **`dioClient`** once, call **`APIService().getResponseWithMapper`** from **repositories only**, return **`Either<APIException, T>`** (or your left/right failure type) to the **BLoC**. Interceptors own auth and refresh; **BLoC** only **fold**s the `Either` into states — no HTTP in UI, no repository imports of `flutter_bloc`.

---

## Either (dartz) — contract

`getResponseWithMapper` returns **`Either<ApiException, T>`** (`dartz`). Repositories should **not** throw for normal API failures; they **fold** into your app type:

| Concept                     | Role                                                                                                 |
| --------------------------- | ---------------------------------------------------------------------------------------------------- |
| **`right(value)`**          | Success after JSON map                                                                               |
| **`left(apiException)`**    | HTTP/Dio error already mapped to **`ApiException`** (`message`, `statusCode`, …)                     |
| **`fold(ifLeft, ifRight)`** | Single place to branch; use in **repository** (normalize message) and again in **BLoC** (emit state) |

**Typedef (recommended):** `typedef FutureEither<T> = Future<Either<APIException, T>>;` — keep **`APIException`** (or `Failure`) in **domain** or **app core**, not in `master_utility` types in the presentation layer if you wrap them.

**Repository:** map **`ApiException`** → your **`APIException`**, preserve **`statusCode`** for “force login” vs “toast”.

**BLoC:** **`await _repository.load();`** then **`result.fold((failure) => emit(XError(failure)), (data) => emit(XLoaded(data)));`** — do **not** wrap that in **`try/catch`** for expected API errors (only for unexpected bugs if you keep a narrow catch).

Add **`dartz`** to **`pubspec.yaml`** if the analyzer does not resolve **`Either`** / **`left`** / **`right`** (often already pulled transitively via **`master_utility`**; an explicit dependency is fine).

---

## `getResponseWithMapper` — object vs list

In **`master_utility`**, **`APIService().getResponseWithMapper<T>`** maps **`response.data`** in an isolate (**`compute`**) using **exactly one** of:

| Parameter           | Typedef (package) | Use when **`response.data`** is |
| ------------------- | ----------------- | ------------------------------- |
| **`jsonMapper`**    | **`JsonMapper<T>`** → **`T Function(Map<String, dynamic>)`** | A **JSON object** (`Map<String, dynamic>`) |
| **`listJsonMapper`**| **`ListJsonMapper<T>`** → **`T Function(List<dynamic>)`**   | A **JSON array** at the root (`List<dynamic>`) |

**Rules:**

- **Do not pass both** — the implementation **`assert`**s **`jsonMapper == null || listJsonMapper == null`** (“Can not provide both json mapper!”).
- **`T`** is whatever you return from the mapper (e.g. **`MyModel`** or **`List<MyModel>`**).
- If the server wraps the list in an object (e.g. **`{ "items": [ ... ] }`**), root **`response.data`** is a **Map**, not a **List** — use **`jsonMapper`** on a **wrapper model** that parses **`items`**, or map the outer map manually inside **`jsonMapper`**.
- If the shape does not match the branch you used (or **`jsonMapper` / `listJsonMapper`** is **`null`**), success falls through to **`right(response.data)`** (raw **`dynamic`**) — always pair **Map** with **`jsonMapper`** and **List** with **`listJsonMapper`**.

---

## Token refresh (JWT) — full mechanism

**Default (no refresh config):** only **`AuthTokenInterceptor`** runs: **`PreferenceHelper`** + **`HttpHeaders.authorizationHeader`** → **`Bearer`**. No automatic rotation.

**With refresh:** call **`dioClient.setRefreshTokenConfiguration`** **after** **`dioClient.setConfiguration`**. Then **`AuthTokenInterceptor` is skipped** and **`JwtHeroInterceptor`** runs instead.

**What JwtHero does (summary):**

1. **On request:** loads **`JwtToken`** from **`TokenStorage`**. If access token **`isValid`** (JWT **`exp`** checked via **`dart_jsonwebtoken`** inside **`master_utility`**), attaches **`Authorization: Bearer <access>`**. If expired, calls **`onRefresh`** (POST refresh endpoint), **`saveToken`**, then continues.
2. **On error:** if response is **401**, tries refresh + **retry** once; **`RevokeTokenException`** (e.g. refresh **401**) → **`sessionManager.expireSession()`**.

**You implement:**

1. **One shared `TokenStorage` and one `SessionManager`** for the app (top-level or registered in DI). Same instances must back **`RefreshTokenConfiguration`** and any **`sessionManager.sessionStatus`** listener.

2. **`TokenStorage`** — implement **`loadToken`**, **`saveToken`**, **`clear`**, and getters **`accessToken`** / **`refreshToken`** (commonly via **`PreferenceHelper`** or secure storage). Persist both tokens on login; **`clear`** removes both.

3. **`RefreshTokenConfiguration`**:
   - **`refreshTokenEndPoint`** — path relative to **`baseUrl`**
   - **`responseMapper`** — map the refresh API JSON to **`JwtToken(accessToken:, refreshToken:)`** (use your API’s keys, e.g. **`access_token`** / **`refresh_token`**, with safe fallbacks for nulls)
   - **`tokenStorage`**, **`sessionManager`**
   - **How the refresh token is sent on the refresh POST** (pick what matches your backend):
     - **Header-based (typical published `master_utility`):** **`refreshTokenHeaderKey`** defaults to **`HttpHeaders.authorizationHeader`**; the interceptor sets **`Bearer <refreshToken>`** on that header and POSTs the endpoint (no body). Override **`refreshTokenHeaderKey`** only if the API uses a custom header name.
     - **JSON body (OTT reference):** backends that expect a body such as **`{'refresh_token': <token>}`** should use **`bodyData`**: an async callback that reads **`await tokenStorage.refreshToken`** and returns the map. Published **`master_utility`** often sends refresh as **`Authorization: Bearer <refresh>`** only (empty POST body). If your API requires a JSON body, your dependency must wire **`bodyData`** into the refresh **`post`** (fork or patch **`RefreshTokenConfiguration`** + **`DioClient._addJWTInterceptor`** / **`JwtHeroInterceptor`** until upstream supports it).

**Reference shape (token storage + refresh config + mapper):**

```dart
final tokenStorage = OTTAppTokenStorage();
final sessionManager = SessionManager();

final refreshTokenConfig = RefreshTokenConfiguration(
  refreshTokenEndPoint: APIEndpoints.refreshToken,
  responseMapper: _mapRefreshTokenResponse,
  tokenStorage: tokenStorage,
  sessionManager: sessionManager,
  bodyData: () async {
    final refreshToken = await tokenStorage.refreshToken;
    return {'refresh_token': refreshToken};
  },
);

JwtToken _mapRefreshTokenResponse(dynamic responseData) {
  final data = responseData as Map<String, dynamic>? ?? {};
  final accessToken = data['access_token'] as String? ?? '';
  final refreshToken = data['refresh_token'] as String? ?? '';
  return JwtToken(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
```

**`TokenStorage` subclass (illustrative):** getters delegate to prefs; **`loadToken`** returns **`JwtToken`** with **`?? ''`** where appropriate; **`saveToken`** writes both keys; **`clear`** removes both.

**Bootstrap order:**

```dart
dioClient.setConfiguration(baseUrl);
dioClient.setRefreshTokenConfiguration(
  refreshTokenConfiguration: refreshTokenConfig,
);
```

For **header-only** refresh (no **`bodyData`**), omit **`bodyData`** and rely on **`refreshTokenHeaderKey`** + **`Bearer <refresh>`** as in your package’s **`DioClient`**.

4. **App shell:** listen to **`sessionManager.sessionStatus`**; on **`SessionStatus.expired`**, clear storage and navigate to login (**one** listener — not per feature BLoC).

**Login success:** **`await tokenStorage.saveToken(JwtToken(accessToken: a, refreshToken: r))`** so the next **`APIService`** call sees tokens. **Logout:** **`tokenStorage.clear()`** and drop refresh config only if you fully tear down **`dioClient`** (usually just clear storage + **`expireSession`**).

---

## Binding API → BLoC (controller)

| Layer          | Responsibility                                                                                                                                 |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Repository** | **`APIRequest`** + **`getResponseWithMapper`** + **`fold` → `FutureEither<Model>`**                                                            |
| **BLoC**       | Injects **abstract repository** (see **get-it-di**); **`on<Event>`** calls repository, **`fold`** → emit loading / loaded / error states          |
| **Screen**     | **`BlocProvider`**, **`BlocBuilder`** / **`BlocListener`** — no **`APIService`**                                                               |

**Pattern:**

```dart
Future<void> _onLoad(LoadFeature event, Emitter<FeatureState> emit) async {
  emit(const FeatureLoading());
  final result = await _repository.fetchThing();
  result.fold(
    (failure) => emit(FeatureError(failure.message, statusCode: failure.statusCode)),
    (data) => emit(FeatureLoaded(data)),
  );
}
```

**Registration:** **`getIt.registerFactory<FeatureBloc>(() => FeatureBloc(repository: getIt<FeatureRepository>()))`** — screen uses **`BlocProvider(create: (_) => getIt<FeatureBloc>()..add(const LoadFeature()))`**.

**Auth UX:** map **`failure.statusCode == 401`** in **`BlocListener`** (global or per-flow) to logout route — or rely on **`SessionManager`** when using JWT refresh. Avoid duplicating: pick **either** session stream **or** statusCode from **`fold`**, not both with conflicting rules.

---

## Core rules

1. **Repositories only** call **`APIService`**; no **`Bloc`** imports.
2. **Public routes:** **`APIRequest(..., isAuthorization: false)`**.
3. **Bearer-only apps:** store under **`HttpHeaders.authorizationHeader`** to match **`AuthTokenInterceptor`**.

---

## Model: single object (`fromJson`) vs root array (`fromList`)

Use **`fromJson`** for one object. For a **root-level JSON array**, add a **static** **`fromList`** that maps each element with **`fromJson`** and returns **`List<MyModel>`** — pass **`MyModel.fromList`** as **`listJsonMapper`** with generic **`List<MyModel>`**.

```dart
class MyModel {
  const MyModel({required this.id, required this.title});

  final String id;
  final String title;

  static MyModel fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  /// Root array: [ {...}, {...} ]
  static List<MyModel> fromList(List<dynamic> json) {
    return json
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

---

## Minimal repository (object and list)

**Single JSON object** — **`jsonMapper: MyModel.fromJson`**, **`T`** = **`MyModel`**:

```dart
FutureEither<MyModel> fetchThing() async {
  final request = APIRequest(
    url: APIEndpoints.somePath,
    methodType: MethodType.GET,
  );
  try {
    final response = await APIService().getResponseWithMapper<MyModel>(
      request,
      jsonMapper: MyModel.fromJson,
    );
    return response.fold(
      (l) => left(APIException(message: l.message, statusCode: l.statusCode)),
      right,
    );
  } on Exception catch (e, st) {
    // log e, st — unexpected only
    return left(APIException(message: '…'));
  }
}
```

**Root JSON array** — **`listJsonMapper: MyModel.fromList`**, **`T`** = **`List<MyModel>`**:

```dart
FutureEither<List<MyModel>> fetchThings() async {
  final request = APIRequest(
    url: APIEndpoints.thingsList,
    methodType: MethodType.GET,
  );
  try {
    final response = await APIService().getResponseWithMapper<List<MyModel>>(
      request,
      listJsonMapper: MyModel.fromList,
    );
    return response.fold(
      (l) => left(APIException(message: l.message, statusCode: l.statusCode)),
      right,
    );
  } on Exception catch (e, st) {
    return left(APIException(message: '…'));
  }
}
```

---

## Common mistakes

| Mistake                                                      | Fix                                                         |
| ------------------------------------------------------------ | ----------------------------------------------------------- |
| **`try/catch` around every API call in BLoC**                | Use **`fold`** on **`Either`** from repository.             |
| **`setRefreshTokenConfiguration` before `setConfiguration`** | **`setConfiguration` first** — **`Dio`** must exist.        |
| **Expecting refresh with only prefs bearer string**          | Implement **`TokenStorage` + `RefreshTokenConfiguration`**. |
| **Two `SessionManager` instances**                           | Single shared instance for interceptor + listener.          |
| **Refresh fails with 401 / wrong contract**                 | Match backend: header **`Bearer <refresh>`** vs JSON body **`refresh_token`**; **`responseMapper`** keys must match the real refresh response. |
| **`jsonMapper` + `listJsonMapper` together**               | Only one — **`assert`** in **`getResponseWithMapper`**.      |
| **Wrong mapper for shape**                                 | **`jsonMapper`** only when **`response.data`** is **`Map`**; **`listJsonMapper`** only when it is **`List`**. Wrapped **`{ "data": [ ] }`** → use **`jsonMapper`** (wrapper / extract array inside). |
| **Unmapped success (raw `dynamic`)**                       | Shape/mapper mismatch or omitted mapper → **`right(response.data)`** without isolate mapping — align **`jsonMapper` / `listJsonMapper`** with **`response.data`** and **`T`**. |
| **Repository imports `flutter_bloc`**                        | Forbidden — keep **Either** as the boundary.                |

---

## Cross-reference

**bloc-cubit** — events, states, **`BlocProvider`**. **get-it-di** — register repositories and BLoCs. **feature-architecture** — data/domain/presentation folders.
