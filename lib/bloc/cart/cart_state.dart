part of 'cart_bloc.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {}

class CartLoadingState extends CartState {}

class CartErrorState extends CartState {
  final String message;

  CartErrorState(this.message);
}

class CartLoadedState extends CartState {
  final List<ProductItem> products;
  final Map<String, CartItem> productIdToCartItem;
  final int counter;

  CartLoadedState(this.products, this.counter, this.productIdToCartItem);
}

class CartNeedLoginState extends CartState {}

class CartCheckoutLoadedState extends CartState {
  final List<AddressModel> addressModel;
  final List<ShippingMethod> shippingModel;

  CartCheckoutLoadedState(this.addressModel, this.shippingModel);
}

class CartItemAddedFromProductDetailsState extends CartState {}
