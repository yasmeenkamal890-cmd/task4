import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_router.dart';
import '../../home/logic/products_cubit.dart';
import '../../home/presentation/home_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.explore,
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ProductsStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Could not load products'));
            }
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text('Explore', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Find something you will love.', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (query) {},
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                ...state.products.take(8).map((product) => ListTile(
                  leading: SizedBox(width: 54, child: Image.network(product.thumbnail, fit: BoxFit.contain)),
                  title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('\$${product.discountedPrice.toStringAsFixed(2)}'),
                )),
              ],
            );
          },
        ),
      );
}
