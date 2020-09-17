import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

import '../../utils/GuardParser.dart';
import 'address_model.dart';

class OrderModel {
  int id;
  String number;
  String status;
  DateTime createdAt;
  DateTime dateModified;
  double total;
  double totalTax;
  String paymentMethodTitle;
  String shippingMethodTitle;
  String customerNote;
  List<ProductItem> lineItems = [];
  AddressModel billing;
  bool isPaid;
  AddressModel shipping;
  ShippingMethod shippingMethod;
  String currency;

  OrderModel({this.id, this.number, this.status, this.createdAt, this.total,this.lineItems,this.isPaid=false});

  OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    id = GuardParser.safeCast<int>(parsedJson["id"]);
    customerNote = GuardParser.safeCast<String>(parsedJson["customer_note"]);
    number = GuardParser.safeCast<String>(parsedJson["number"]);
    status = GuardParser.safeCast<String>(parsedJson["status"]);
    createdAt = parsedJson["date_created"] != null ? DateTime.parse(parsedJson["date_created"]) : DateTime.now();
    dateModified = parsedJson["date_modified"] != null ? DateTime.parse(parsedJson["date_modified"]) : DateTime.now();
    total = GuardParser.safeCast<double>(parsedJson["total"] != null ? double.parse(parsedJson["total"]) : 0.0);
    totalTax =
        GuardParser.safeCast<double>(parsedJson["total_tax"] != null ? double.parse(parsedJson["total_tax"]) : 0.0);
    paymentMethodTitle = GuardParser.safeCast<String>(parsedJson["payment_method_title"]);
    currency = GuardParser.safeCast<String>(parsedJson["currency"]);

    parsedJson["line_items"].forEach((item) {
      lineItems.add(ProductItem.fromJson(item));
    });

    billing = AddressModel.fromJson(parsedJson["billing"]);
    shippingMethodTitle = parsedJson["shipping_lines"] != null && parsedJson["shipping_lines"].length > 0
        ? parsedJson["shipping_lines"][0]["method_title"]
        : null;
  }

  Map<String, dynamic> toOrderJson() {
      var items = lineItems.map((index) {
        return index.toJson();
      }).toList();

      return {
        "set_paid":isPaid,
        "status": status,
        "total": total.toString(),
        "shipping_lines": [
          {"method_title": shippingMethodTitle}
        ],
        "number": number,
        "billing": billing.toJson(),
        "shipping":shipping.toJson(),
        "line_items": items,
        "date_created": createdAt.toString(),
        "payment_method_title": paymentMethodTitle
      };
    }



  @override
  String toString() => 'Order { id: $id  number: $number}';
}

class ProductItem {
  int productId;
  int variationId;
  String name;
  String featuredImage;
  int quantity;
  String total;
  String price;
  List<Attribute> attribute;

  ProductItem({
    this.productId,
    this.variationId,
    this.name,
    this.quantity,
    this.total,
    this.featuredImage,
    this.price,
    this.attribute,
  });

  ProductItem.fromJson(Map<String, dynamic> parsedJson) {
    productId = GuardParser.safeCast<int>(parsedJson["product_id"]);
    variationId = GuardParser.safeCast<int>(parsedJson["variation_id"]);
    name = GuardParser.safeCast<String>(parsedJson["name"]);
    quantity = GuardParser.safeCast<int>(parsedJson["quantity"]);
    total = GuardParser.safeCast<String>(parsedJson["total"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "quantity": quantity,
      "total": total,
      "price": price,
    };
  }


}

class ProductItemAttribute {
  int id;
  String name;
  String value;

  ProductItemAttribute();

  ProductItemAttribute.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["key"];
    var sad = int.tryParse(parsedJson["value"]);
    if (sad == null) {
      value = Uri.decodeFull(parsedJson["value"]).toString().toUpperCase();
      print(value);
    } else {
      value = parsedJson["value"].toString().toUpperCase();
    }
  }

  ProductItemAttribute.fromLocalJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["key"];
    value = parsedJson["value"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "key": name, "value": value};
  }
}
