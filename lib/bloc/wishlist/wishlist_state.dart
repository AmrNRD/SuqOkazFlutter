part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final List<ProductModel> products;

  WishlistLoadedState(this.products);
}

class WishlistErrorState extends WishlistState {
  final String message;

  WishlistErrorState(this.message);
}