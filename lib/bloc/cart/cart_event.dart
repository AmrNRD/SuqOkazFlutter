part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddProductToCartEvent extends CartEvent {
  final ProductModel _productModel;
  final int quantity;
  final int variationId;
  final List<Attribute> attributes;
  AddProductToCartEvent(
    this._productModel,
    this.quantity,
    this.variationId,
    this.attributes,
  );

  @override
  List<Object> get props => [this._productModel];
}

class GetCartEvent extends CartEvent {
  @override
  List<Object> get props => [];
}

class IncreaseItemInCartEvent extends CartEvent {
  final int productId;
  final int variationId;

  IncreaseItemInCartEvent(this.productId, this.variationId);
  @override
  List<Object> get props => [this.productId];
}

class RemovedItemInCartEvent extends CartEvent {
  final int productId;
  final int variationId;

  RemovedItemInCartEvent(this.productId, this.variationId);
  @override
  List<Object> get props => [this.productId];
}

class DecreaseItemInCartEvent extends CartEvent {
  final int productId;
  final int variationId;

  DecreaseItemInCartEvent(this.productId, this.variationId);
  @override
  List<Object> get props => [this.productId];
}

class SetUserEmailEvent extends CartEvent {
  final String userEmail;

  SetUserEmailEvent(this.userEmail);
  @override
  List<Object> get props => [this.userEmail];
}

class CheckoutCartEvent extends CartEvent {
  CheckoutCartEvent();
  @override
  List<Object> get props => [];
}
