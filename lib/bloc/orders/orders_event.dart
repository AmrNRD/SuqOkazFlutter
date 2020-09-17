part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}


class GetOrdersEvent extends OrdersEvent {

  final bool isLoadMoreMode;
  final int perPage = 3;

  final int userID;

  GetOrdersEvent({
    this.isLoadMoreMode = false,
    this.userID,
  });

  @override
  List<Object> get props => [];
}


class CreateOrder extends OrdersEvent{
  final OrderModel order;

  CreateOrder(this.order);
}