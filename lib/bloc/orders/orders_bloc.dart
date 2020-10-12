import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:suqokaz/data/models/cart_model.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/payment.dart';
import 'package:suqokaz/data/repositories/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(this.ordersRepository) : super(OrdersInitial());

  /// Variables

  // Core
  bool isLoading = false;

  // Pagination
  int currentPage = 1;
  bool lastPageReached = false;

  // Repos
  final OrdersRepository ordersRepository;

  /// Mappers
  ///
  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    try{
      /// Get products event
      if (event is GetOrdersEvent) {
        if (!lastPageReached && !isLoading) {

          // Mark as loading
          isLoading = true;

          // Set loading state
          yield OrdersLoadingState(isLoadMoreMode: event.isLoadMoreMode);

          // Load data
          var ordersList = await ordersRepository.getOrders(
            pageIndex: currentPage,
            perPage: event.perPage,
            userID: event.userID);
          // Process data
          if (ordersList is List) {
            // Init data holder
            List<OrderModel> dataList = [];
            // Loop on data
            for (var item in ordersList) {
              var order = OrderModel.fromJson(item);
              dataList.add(order);
            }

            // Go to next page
            currentPage++;

            // Check last page
            if (ordersList.isEmpty) lastPageReached = true;
            // Yield result
            yield OrdersLoadedState(orders:dataList,isLoadMoreMode: event.isLoadMoreMode, lastPageReached: lastPageReached);
          } else {
            // Yield Error
            yield OrdersErrorState(message: "Error occurred"); // TODO: translate
          }
        }
      } else if(event is CreateOrder) {
        OrderModel order=await ordersRepository.createOrder(event.order);
        // if(order.status=="pending"&&order.paymentMethodId!="cod")
        // {
        //  String url= await ordersRepository.getCheckoutUrl(order.toJson());
        //
        //  yield OrderUrlLoadedState(order: order,url: url);
        // }else {
          yield OrderLoadedState(order: order);
        // }
      } else if(event is CreateOrder) {
        OrderModel order=await ordersRepository.createOrder(event.order);
        yield OrderLoadedState(order: order);
      }else if(event is CreatePayment){
      Payment payment=await ordersRepository.createPayment(event.amount, event.name, event.number, event.cvc, event.month, event.year);
      yield PaymentSuccessfulState(payment,event.orderId);
      }else if(event is SetOrderPayed){
        await ordersRepository.setOrderPayed(event.orderId);
        yield SetPayedSuccessfullyState();
      } else if(event is GetOrderDetails){
        yield OrdersLoadingState();
        List<ProductItem>detailProducts=await ordersRepository.getOrderDetails(event.order.lineItems);
          print("out");
          print("-------------------------------------------------");
          print(detailProducts.length);
          OrderModel order=event.order;
          print(detailProducts[0].imageFeature);
          yield OrderLoadedState(order: order,products: detailProducts);


      }}catch(error){
      yield OrdersErrorState(message: error.toString());
    }

  }

  void resetBloc(){
    currentPage = 1;
    lastPageReached = false;
  }
}
