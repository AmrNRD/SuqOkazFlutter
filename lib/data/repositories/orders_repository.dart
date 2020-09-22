import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/sources/remote/orders.service.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:suqokaz/utils/constants.dart';

abstract class OrdersRepository {
  Future<dynamic> getOrders({int pageIndex, int perPage = 20, int userID});
  Future createOrder(OrderModel order);
  Future<String> getCheckoutUrl(Map<String, dynamic> params);
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
      print(res['id']);
     return OrderModel.fromJson(res);
  }

  @override
  Future<String> getCheckoutUrl(Map<String, dynamic> params) async {
    try {
      var str = convert.jsonEncode(params);
      var bytes = convert.utf8.encode(str);
      var base64Str = convert.base64.encode(bytes);
      print("${Constants.baseUrl}/wp-json/api/flutter_user/checkout");

      final http.Response response =
      await http.post("${Constants.baseUrl}/wp-json/api/flutter_user/checkout",
          body: convert.jsonEncode({
            "order": base64Str,
          }));
      var body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && body is String) {
        return "${Constants.baseUrl}/mstore-checkout?code=$body";
      } else {
        var message = body["message"];
        throw Exception(
            message != null ? message : "Can't save the order to website");
      }
    } catch (err) {
      rethrow;
    }
  }
}
