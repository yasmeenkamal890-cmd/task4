import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_model.dart';
import '../data/products_repository.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final ProductsStatus status;
  final List<Product> products;
  final String? errorMessage;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) =>
      ProductsState(
        status: status ?? this.status,
        products: products ?? this.products,
        errorMessage: errorMessage,
      );
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());
  final ProductsRepository _repository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, errorMessage: null));
    try {
      final products = await _repository.getProducts();
      emit(state.copyWith(status: ProductsStatus.success, products: products));
    } catch (_) {
      emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: 'Could not load products. Check your internet connection.',
      ));
    }
  }
}
