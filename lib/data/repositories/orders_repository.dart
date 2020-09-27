import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/remote/orders.service.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:suqokaz/utils/constants.dart';

abstract class OrdersRepository {
  Future<dynamic> getOrders({int pageIndex, int perPage = 20, int userID});
  Future createOrder(OrderModel order);
  Future<String> getCheckoutUrl(Map<String, dynamic> params);
  Future getOrderDetails(List<ProductItem> products);
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
  Future getOrderDetails(List<ProductItem> products) async{
    List<ProductItem> detailProduct=[];
    print(products.length);
    await Future.forEach(products, (ProductItem element) async {

      var productRawData = await ProductsRepository().getProductDetails(productId: element.productId.toString());
      ProductItem productModel = ProductItem.fromJson(productRawData);
      print("price");
      print(element.price);
      ProductItem parsed=ProductItem(
          productId: productModel.productId,
          name: productModel.name,
          featuredImage: productModel.featuredImage,
          variationId:element.variationId,
          quantity: element.quantity,
          price:productModel.price,
          total: (double.tryParse(productModel.price) * element.quantity).toStringAsFixed(2),
          images: productModel.images,
          imageFeature: productModel.imageFeature
      );
       detailProduct.add(parsed);
    });
    return detailProduct;
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

      final http.Response response =
      await http.post("${Constants.baseUrl}/wp-json/api/flutter_user/checkout",
          body: convert.jsonEncode({
            "order": base64Str,
          }));
      var body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && body is String) {
        return "${Constants.baseUrl}/checkout?code=$body";
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
