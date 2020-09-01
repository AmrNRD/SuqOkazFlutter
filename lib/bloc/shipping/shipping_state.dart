part of 'shipping_bloc.dart';

@immutable
abstract class ShippingState {}

class ShippingInitial extends ShippingState {}


class ShippingLoadingState extends ShippingState {}

class ShippingListLoadedState extends ShippingState {
  final List<ShippingMethod> shippingMethods;

  ShippingListLoadedState(this.shippingMethods);
}

class ShippingErrorState extends ShippingState {
  final String message;

  ShippingErrorState(this.message);
}