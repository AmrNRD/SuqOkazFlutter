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

  OrderLoadedState({this.order});
}

class OrdersErrorState extends OrdersState {
  final String message;

  OrdersErrorState({this.message});
}
