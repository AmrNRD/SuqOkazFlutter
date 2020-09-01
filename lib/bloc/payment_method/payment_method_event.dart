part of 'payment_method_bloc.dart';

@immutable
abstract class PaymentMethodEvent {}

class GetAllPaymentMethodEvent extends PaymentMethodEvent {}