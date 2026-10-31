import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/app_router.dart';
import '../logic/shop_cubit.dart';
import '../../../features/home/presentation/home_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => MainShell(
        currentRoute: AppRoutes.cart,
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state.cart.isEmpty) {
              return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.shopping_cart_outlined, size: 72, color: Color(0xFF40BFFF)),
                SizedBox(height: 16),
                Text('Your cart is empty', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Add products and they will appear here.'),
              ]));
            }
            final lines = state.cart.values.toList();
            final total = context.read<ShopCubit>().cartTotal;
            return Column(children: [
              const Padding(
                padding: EdgeInsets.all(18),
                child: Align(alignment: Alignment.centerLeft,
                  child: Text('My Cart', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        SizedBox(width: 76, height: 76,
                          child: Image.network(line.product.thumbnail, fit: BoxFit.contain)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(line.product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          Text('\$${line.product.discountedPrice.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFF40BFFF), fontWeight: FontWeight.bold)),
                          Row(children: [
                            IconButton(onPressed: () => context.read<ShopCubit>().changeQuantity(line.product.id, -1),
                                icon: const Icon(Icons.remove_circle_outline)),
                            Text('${line.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(onPressed: () => context.read<ShopCubit>().changeQuantity(line.product.id, 1),
                                icon: const Icon(Icons.add_circle_outline)),
                            const Spacer(),
                            IconButton(onPressed: () => context.read<ShopCubit>().removeFromCart(line.product.id),
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                          ]),
                        ])),
                      ]),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Row(children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF40BFFF))),
                  ]),
                ),
              ),
            ]);
          },
        ),
      );
}
