import 'package:suqokaz/utils/GuardParser.dart';

class ProductItem {
  int productId;
  String name;
  String featuredImage;
  int quantity;
  String total;
  String price;

  ProductItem({
    this.productId,
    this.name,
    this.quantity,
    this.total,
    this.featuredImage,
    this.price,
  });

  ProductItem.fromJson(Map<String, dynamic> parsedJson) {
    productId = GuardParser.safeCast<int>(parsedJson["product_id"]);
    name = GuardParser.safeCast<String>(parsedJson["name"]);
    quantity = GuardParser.safeCast<int>(parsedJson["quantity"]);
    total = GuardParser.safeCast<String>(parsedJson["total"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "quantity": quantity,
      "total": total
    };
  }
}
