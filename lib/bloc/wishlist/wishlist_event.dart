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
  final int productId;
  final int varId;

  AddProductToWishListEvent({this.productId, this.varId});
}

class RemoveWishListItemEvent extends WishlistEvent {
  final ProductModel productModel;

  RemoveWishListItemEvent(this.productModel);
}
