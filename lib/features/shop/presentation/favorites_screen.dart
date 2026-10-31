import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_router.dart';
import '../../home/presentation/home_screen.dart';
import '../logic/shop_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.explore,
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            final products = state.favorites.values.toList();
            if (products.isEmpty) {
              return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.favorite_rounded, size: 72, color: Color(0xFFE94B77)),
                SizedBox(height: 16),
                Text('Your Favorites', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Products you love will appear here.'),
              ]));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: .62),
              itemBuilder: (_, index) => ProductCard(product: products[index]),
            );
          },
        ),
      );
}
