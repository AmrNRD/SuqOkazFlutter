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


class CreatePayment extends OrdersEvent{
  final int orderId;
  final double amount;
  final String name;
  final String number;
  final int month;
  final int cvc;
  final int year;

  CreatePayment({this.orderId, this.name, this.number, this.month, this.year, this.amount, this.cvc});
}

class SetOrderPayed extends OrdersEvent{
  final int orderId;

  SetOrderPayed({this.orderId});
}




class GetOrderDetails extends OrdersEvent{
  final OrderModel order;
  GetOrderDetails(this.order);
}