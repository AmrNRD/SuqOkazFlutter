import 'package:suqokaz/data/models/coupon.dart';
import 'package:suqokaz/data/models/payment_method_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

import '../../main.dart';
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
  String paymentMethodId;
  String paymentMethodTitle;
  String shippingMethodTitle;
  String customerNote;
  List<ProductItem> lineItems = [];
  AddressModel billing;
  bool isPaid;
  AddressModel shipping;
  Coupon coupon;
  ShippingMethod shippingMethod;
  PaymentMethod paymentMethod;
  String currency;

  OrderModel({this.id, this.number, this.status, this.createdAt, this.total,this.lineItems,this.isPaid=false,this.paymentMethod});

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
    paymentMethodId = GuardParser.safeCast<String>(parsedJson["payment_method"]);

    currency = GuardParser.safeCast<String>(parsedJson["currency"]);

    parsedJson["line_items"].forEach((item) {
      lineItems.add(ProductItem.fromJson(item));
    });

    billing = AddressModel.fromJson(parsedJson["billing"]);
    shippingMethodTitle = parsedJson["shipping_lines"] != null && parsedJson["shipping_lines"].length > 0
        ? parsedJson["shipping_lines"][0]["method_title"]
        : null;
  }


  Map<String, dynamic> toJson() {
    var items = lineItems.map((index) {
      return index.toJson();
    }).toList();


    return {
      "set_paid":isPaid,
      "status": status,
      "total": total.toString(),
      "payment_method": paymentMethod?.id??paymentMethod,
      "payment_method_title": paymentMethod?.title??paymentMethodTitle,
      "number": number,
      "id": id,
      "line_items": items,
      "customer_id": Root.user.id,
      "date_created": createdAt.toString(),
      "shipping_lines":[{
        "method_id":shippingMethod?.id,
        "method_title":shippingMethod?.title
      }]
    };
  }




  Map<String, dynamic> toOrderJson() {
      var items = lineItems.map((index) {
        return index.toJson();
      }).toList();
    Map<String, dynamic>  json ={
    "set_paid":isPaid,
    "status": status,
    "total": total.toString(),
    "payment_method": paymentMethod.id,
    "payment_method_title": paymentMethod.title,
    "number": number,
    "billing": billing.toJson(),
    "shipping":shipping.toJson(),
    "line_items": items,
    "customer_id": Root.user.id,
    "date_created": createdAt.toString(),
    "shipping_lines":[{
    "method_id":shippingMethod.id,
    "method_title":shippingMethod.title
    }]
  };
    if(coupon!=null){
      json['coupon_lines']=[coupon.toJson(),];
    }
      return json;
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
  List<String> images;
  String imageFeature;

  ProductItem({
    this.productId,
    this.variationId,
    this.name,
    this.quantity,
    this.total,
    this.featuredImage,
    this.price,
    this.attribute,
    this.images,
    this.imageFeature
  });

  ProductItem.fromJson(Map<String, dynamic> parsedJson) {
    productId = GuardParser.safeCast<int>(parsedJson["product_id"]);
    variationId = GuardParser.safeCast<int>(parsedJson["variation_id"]);
    name = GuardParser.safeCast<String>(parsedJson["name"]);
    price = GuardParser.safeCast<String>(parsedJson["price"]);
    quantity = GuardParser.safeCast<int>(parsedJson["quantity"]);
    total = GuardParser.safeCast<String>(parsedJson["total"]);

    // get images links from meta data
    if (parsedJson.containsKey("meta_data")&&parsedJson['meta_data']!=[]) {
       List<String> list = [];
      var metaDataImages = parsedJson['meta_data'].firstWhere(
            (item) => item['key'] == '_knawatfibu_wcgallary',
        orElse: () => null,
      );
      if (metaDataImages != null) {
        var metaDataImagesList = metaDataImages['value'] as List;
        if (metaDataImagesList != null) {
          metaDataImagesList.forEach((element) {
            if (element['url'] is String) {
              list.add(element['url'] as String);
            }
          });
        }
        for (var item in parsedJson["images"]) {
          if (item is Map) {
            list.add(item["src"]);
          } else {
            list.add(item);
          }
        }
        images = list;
        imageFeature = images[0];
      }
      }

  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "quantity": quantity,
      "total": total,
      "price": price,
      "image_feature":imageFeature
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
