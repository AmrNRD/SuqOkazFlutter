import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/sources/remote/orders.service.dart';

abstract class OrdersRepository {
  Future<dynamic> getOrders({int pageIndex, int perPage = 20, int userID});
  Future createOrder(OrderModel order);
}

class OrdersDataRepository extends OrdersRepository {
  OrdersService productsService = new OrdersService();

  @override
  Future getOrders({int pageIndex, int perPage = 20, int userID}) async {
    return await productsService.getOrders(
      pageIndex: pageIndex,
      perPage: perPage,
      userID: userID
    );
  }

  @override
  Future createOrder(OrderModel order) async {
     var res=await productsService.createOrder(order);
     print("----------------------------------------------------------------------------------------------------");
     print(res);
  }

}
