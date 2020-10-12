part of 'home_products_bloc.dart';

abstract class HomeProductsState {
  const HomeProductsState();
}

class HomeProductsLoadingState extends HomeProductsState {
  final bool isLoadMoreMode;

  HomeProductsLoadingState({this.isLoadMoreMode = false});
}

class HomeProductsLoadedState extends HomeProductsState {
  final List<ProductModel> products;
  final bool isLoadMoreMode;
  final bool lastPageReached;

  HomeProductsLoadedState({this.products, this.isLoadMoreMode, this.lastPageReached});
}

class HomeProductsErrorState extends HomeProductsState {
  final String message;
  final bool isLoadMoreMode;

  HomeProductsErrorState( {
    this.isLoadMoreMode,
    this.message,
  });
}
