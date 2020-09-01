part of 'payment_method_bloc.dart';

@immutable
abstract class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoadingState extends PaymentMethodState {}

class PaymentMethodListLoadedState extends PaymentMethodState {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodListLoadedState(this.paymentMethods);
}

class PaymentMethodErrorState extends PaymentMethodState {
  final String message;

  PaymentMethodErrorState(this.message);
}