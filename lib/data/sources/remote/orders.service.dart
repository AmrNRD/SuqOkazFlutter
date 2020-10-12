import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/utils/constants.dart';

import '../../../main.dart';
import 'base/api_caller.dart';

class OrdersService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future<dynamic> getOrders({int userID, int pageIndex, int perPage}) async {
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
  Future<dynamic> setOrderPayed(int orderId) async {
    String url = "/orders/"+orderId.toString();
    final String oAuthUrl = apiCaller.getOAuthURL("POST", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.putData(headers: {},body: {
      "set_paid": true
    },needAuthorization:true);
  }

  Future<dynamic> createPayment(double amount,String name,String number,int cvc,int month,int year) async {

    apiCaller.setUrl("https://api.moyasar.com/v1/payments");
    return await apiCaller.postData(headers: {},body: {
      "amount":(amount*100).toInt(),
      "publishable_api_key":Constants.livePublishableKey,
      "source":{
        "type":"creditcard",
        "company":"mada",
        "name":name,
        "number":number,
        "message":"message",
        "cvc":cvc,
        "month":month,
        "year":year
      },
      "callback_url":"https://example.com/orders"
    });
  }
}
