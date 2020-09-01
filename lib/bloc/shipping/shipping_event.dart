part of 'shipping_bloc.dart';

@immutable
abstract class ShippingEvent {}

class GetAllShippingEvent extends ShippingEvent {}