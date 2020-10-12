part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoadingState extends OrdersState {
  final bool isLoadMoreMode;

  OrdersLoadingState({this.isLoadMoreMode = false});
}

class OrdersLoadedState extends OrdersState {
  final List<OrderModel> orders;
  final bool isLoadMoreMode;
  final bool lastPageReached;

  OrdersLoadedState({this.orders,this.isLoadMoreMode,this.lastPageReached});
}

class OrderLoadedState extends OrdersState {
  final OrderModel order;
  final List<ProductItem>products;
  OrderLoadedState({this.order,this.products});
}

class PaymentSuccessfulState extends OrdersState {
 final Payment payment;
 final int orderId;
  PaymentSuccessfulState(this.payment, this.orderId);
}

class SetPayedSuccessfullyState extends OrdersState {
  SetPayedSuccessfullyState();
}

class OrderUrlLoadedState extends OrdersState {
  final String url;
  final OrderModel order;

  OrderUrlLoadedState({this.order,this.url});
}

class OrdersErrorState extends OrdersState {
  final String message;

  OrdersErrorState({this.message});
}
