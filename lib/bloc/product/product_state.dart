part of 'product_bloc.dart';

abstract class ProductState {
  const ProductState();
}

class ProductsInitial extends ProductState {}

class ProductsLoadingState extends ProductState {
  final bool isLoadMoreMode;

  ProductsLoadingState({this.isLoadMoreMode = false});
}

class ProductsLoadedState extends ProductState {
  final List<ProductModel> products;
  final bool isLoadMoreMode;
  final bool lastPageReached;

  ProductsLoadedState({this.products, this.isLoadMoreMode, this.lastPageReached});
}

class ProductsErrorState extends ProductState {
  final String message;

  ProductsErrorState({this.message});
}

class ProductVariationsLoadedState extends ProductState {
  final ProductModel productModel;

  ProductVariationsLoadedState({this.productModel});
}

class ProductDetailsLoadedState extends ProductState {
  final ProductModel productModel;

  ProductDetailsLoadedState({this.productModel});
}
