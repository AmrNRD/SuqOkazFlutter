part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class GetWishListEvent extends WishlistEvent {
  GetWishListEvent();
}

class AddProductToWishListEvent extends WishlistEvent {
  final ProductModel productModel;
  final int varId;
  final int productId;

  AddProductToWishListEvent({
    this.productModel,
    this.varId,
    this.productId,
  });
}

class RemoveWishListItemEvent extends WishlistEvent {
  final int varId;
  final int productId;

  RemoveWishListItemEvent({
    this.productId,
    this.varId,
  });
}
