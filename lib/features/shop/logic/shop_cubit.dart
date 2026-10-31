import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/data/product_model.dart';

class ShopState {
  const ShopState({this.favorites = const {}, this.cart = const {}});
  final Map<int, Product> favorites;
  final Map<int, CartLine> cart;

  ShopState copyWith({
    Map<int, Product>? favorites,
    Map<int, CartLine>? cart,
  }) => ShopState(
        favorites: favorites ?? this.favorites,
        cart: cart ?? this.cart,
      );
}

class CartLine {
  const CartLine({required this.product, required this.quantity});
  final Product product;
  final int quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);
}

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(const ShopState());

  void toggleFavorite(Product product) {
    final updated = Map<int, Product>.from(state.favorites);
    if (updated.containsKey(product.id)) {
      updated.remove(product.id);
    } else {
      updated[product.id] = product;
    }
    emit(state.copyWith(favorites: updated));
  }

  bool isFavorite(int id) => state.favorites.containsKey(id);

  void addToCart(Product product) {
    final updated = Map<int, CartLine>.from(state.cart);
    final current = updated[product.id];
    updated[product.id] = CartLine(
      product: product,
      quantity: (current?.quantity ?? 0) + 1,
    );
    emit(state.copyWith(cart: updated));
  }

  void changeQuantity(int id, int delta) {
    final updated = Map<int, CartLine>.from(state.cart);
    final current = updated[id];
    if (current == null) return;
    final quantity = current.quantity + delta;
    if (quantity <= 0) {
      updated.remove(id);
    } else {
      updated[id] = current.copyWith(quantity: quantity);
    }
    emit(state.copyWith(cart: updated));
  }

  void removeFromCart(int id) {
    final updated = Map<int, CartLine>.from(state.cart)..remove(id);
    emit(state.copyWith(cart: updated));
  }

  int get cartCount => state.cart.values.fold(0, (sum, line) => sum + line.quantity);
  double get cartTotal => state.cart.values.fold(
        0.0, (sum, line) => sum + line.product.discountedPrice * line.quantity);
}
