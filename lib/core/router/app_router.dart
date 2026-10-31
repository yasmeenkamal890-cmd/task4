import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/product_details/presentation/product_details_screen.dart';
import '../../features/shop/presentation/cart_screen.dart';
import '../../features/shop/presentation/favorites_screen.dart';
import '../../features/shop/presentation/offers_screen.dart';
import '../../features/shop/presentation/account_screen.dart';
import '../../features/shop/presentation/explore_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const explore = '/explore';
  static const cart = '/cart';
  static const favorites = '/favorites';
  static const offers = '/offers';
  static const account = '/account';
  static const productDetails = '/product/:id';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.login, name: 'login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.home, name: 'home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: AppRoutes.explore, name: 'explore', builder: (_, __) => const ExploreScreen()),
    GoRoute(path: AppRoutes.cart, name: 'cart', builder: (_, __) => const CartScreen()),
    GoRoute(path: AppRoutes.favorites, name: 'favorites', builder: (_, __) => const FavoritesScreen()),
    GoRoute(path: AppRoutes.offers, name: 'offers', builder: (_, __) => const OffersScreen()),
    GoRoute(path: AppRoutes.account, name: 'account', builder: (_, __) => const AccountScreen()),
    GoRoute(
      path: AppRoutes.productDetails,
      name: 'productDetails',
      builder: (context, state) => ProductDetailsScreen(
        productId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
