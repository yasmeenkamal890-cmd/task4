# Task 4 — Lafyuu Mini Shop (Flutter)

## Task requirements implemented
- Navigation refactored with **go_router** and named routes.
- Figma-inspired 5-item bottom navigation: **Home, Explore, Cart, Offer, Account**.
- Bottom navigation updates route using `context.go(...)`; product detail uses `context.pushNamed(...)`.
- DummyJSON authentication via `POST /auth/login`.
- Product listing and product details via DummyJSON + Dio.
- Favorites and cart are shared app state through `ShopCubit` (persist while navigating within app).
- Cart quantity controls, remove item, and total calculation.
- Cart badge count in bottom navigation.
- Product details screen and offer/favorites/account/explore screens.

## Run
1. Extract ZIP.
2. Open the extracted folder in VS Code.
3. In terminal:
   ```bash
   flutter pub get
   flutter run
   ```
4. Demo login:
   - Username: `emilys`
   - Password: `emilyspass`

## Main navigation architecture
- `lib/core/router/app_router.dart`: central route table and route names.
- `MainShell` in `home_screen.dart`: reusable Figma-inspired bottom navigation.
- `context.go(...)`: switches bottom tabs without stacking pages.
- `context.pushNamed('productDetails', pathParameters: {'id': ...})`: pushes product detail.
- `context.pop()`: returns from product details.

## API
Base URL: `https://dummyjson.com`
- `POST /auth/login`
- `GET /products?limit=30`
- `GET /products/{id}`

Official auth documentation: https://dummyjson.com/docs/auth#auth-login

## Notes
- Cart and favorites are in-memory state. They remain available during navigation while the app is running, but are not persisted after app termination.
- Offer cards are UI examples, as DummyJSON does not provide a store-specific promotions endpoint.
