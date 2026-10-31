import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../data/product_model.dart';
import '../logic/products_cubit.dart';
import '../../shop/logic/shop_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.home,
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProductsStatus.failure) {
              return _MessageState(
                message: state.errorMessage ?? 'Something went wrong',
                onRetry: () => context.read<ProductsCubit>().loadProducts(),
              );
            }
            if (state.products.isEmpty) return const Center(child: Text('No products found'));
            return RefreshIndicator(
              onRefresh: () => context.read<ProductsCubit>().loadProducts(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Lafyuu collection', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF223263))),
                            SizedBox(height: 6),
                            Text('Discover your everyday essentials', style: TextStyle(color: Color(0xFF667085))),
                          ])),
                          Icon(Icons.shopping_bag_outlined, size: 42, color: Color(0xFF40BFFF)),
                        ]),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(product: state.products[index]),
                        childCount: state.products.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: .62,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (context, shopState) {
        final favorite = shopState.favorites.containsKey(product.id);
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.pushNamed('productDetails', pathParameters: {'id': '${product.id}'}),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => context.read<ShopCubit>().toggleFavorite(product),
                    icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                        color: favorite ? Colors.redAccent : Colors.grey),
                  ),
                ]),
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 5),
                Text('\$${product.discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5559D9))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 17, color: Colors.amber),
                  Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context.read<ShopCubit>().addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                  ),
                ]),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ]),
        ),
      );
}

/// Shared Figma-inspired scaffold. Bottom tabs map to named GoRouter routes.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.currentRoute, required this.child});
  final String currentRoute;
  final Widget child;

  int _selectedIndex() {
    switch (currentRoute) {
      case AppRoutes.explore: return 1;
      case AppRoutes.favorites: return 1;
      case AppRoutes.cart: return 2;
      case AppRoutes.offers: return 3;
      case AppRoutes.account: return 4;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinations = [
      (label: 'Home', icon: Icons.home_outlined, active: Icons.home_rounded, route: AppRoutes.home),
      (label: 'Explore', icon: Icons.search, active: Icons.search_rounded, route: AppRoutes.explore),
      (label: 'Cart', icon: Icons.shopping_cart_outlined, active: Icons.shopping_cart_rounded, route: AppRoutes.cart),
      (label: 'Offer', icon: Icons.local_offer_outlined, active: Icons.local_offer_rounded, route: AppRoutes.offers),
      (label: 'Account', icon: Icons.person_outline, active: Icons.person_rounded, route: AppRoutes.account),
    ];
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E8EF))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: List.generate(destinations.length, (index) {
                final item = destinations[index];
                final selected = _selectedIndex() == index;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (currentRoute != item.route) context.go(item.route);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(clipBehavior: Clip.none, children: [
                          Icon(selected ? item.active : item.icon,
                              size: 22, color: selected ? const Color(0xFF40BFFF) : const Color(0xFF9098B1)),
                          if (index == 2)
                            Positioned(
                              right: -9, top: -8,
                              child: BlocBuilder<ShopCubit, ShopState>(
                                builder: (context, state) {
                                  final count = context.read<ShopCubit>().cartCount;
                                  if (count == 0) return const SizedBox.shrink();
                                  return Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                    child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9)),
                                  );
                                },
                              ),
                            ),
                        ]),
                        const SizedBox(height: 4),
                        Text(item.label, style: TextStyle(
                          fontSize: 10,
                          color: selected ? const Color(0xFF40BFFF) : const Color(0xFF9098B1),
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
