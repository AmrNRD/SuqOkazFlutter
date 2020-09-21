import 'package:suqokaz/data/models/order_model.dart';

import '../../../main.dart';
import 'base/api_caller.dart';

class OrdersService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future<dynamic> getOrders({int userID, int pageIndex, int perPage}) async {
    print('heeeeeeeeeee');
    print(Root.user);
    print(Root.user.id);
    print(Root.user.name);
    String url = "/orders?customer=${Root.user.id}&per_page=$perPage&page=$pageIndex";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {},needAuthorization: true);
  }

  Future<dynamic> getOrderNote({int orderId, int userID, int page, int perPage}) async {
    String url = "/orders/$orderId/notes?customer=${Root.user.id}&per_page=$perPage";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {},needAuthorization: true);
  }

  Future<dynamic> createOrder(OrderModel order) async {
    String url = "/orders";
    final String oAuthUrl = apiCaller.getOAuthURL("POST", url, true);
    print(order.toOrderJson());
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.postData(headers: {},body: order.toOrderJson(),needAuthorization:true);
  }
}
