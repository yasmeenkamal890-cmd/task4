import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/dio_client.dart';
import '../../../core/router/app_router.dart';
import '../../home/data/product_model.dart';
import '../../home/data/products_repository.dart';
import '../../shop/logic/shop_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final int productId;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductsRepository(DioClient.create()).getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios_new)),
          title: const Text('Product Details'),
          actions: [
            IconButton(onPressed: () => context.go(AppRoutes.cart), icon: const Icon(Icons.shopping_cart_outlined)),
          ],
        ),
        body: FutureBuilder<Product>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Could not load product'));
            }
            final product = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SizedBox(
                  height: 280,
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: Image.network(product.thumbnail, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 70)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(children: [
                  Text('\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, color: Color(0xFF40BFFF), fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber),
                  Text(product.rating.toStringAsFixed(1)),
                ]),
                const SizedBox(height: 16),
                Text(product.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
                const SizedBox(height: 12),
                Text('Brand: ${product.brand.isEmpty ? 'Unbranded' : product.brand}'),
                Text('Stock: ${product.stock}'),
                const SizedBox(height: 28),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () {
                    context.read<ShopCubit>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                ),
              ],
            );
          },
        ),
      );
}
