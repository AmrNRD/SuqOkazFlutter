import 'package:html/parser.dart';
import 'package:quiver/strings.dart';
import 'package:suqokaz/utils/GuardParser.dart';

class ProductModel {
  int id;
  String sku;
  String name;
  String description;
  String permalink;
  String price;
  String regularPrice;
  String salePrice;
  bool onSale;
  bool inStock;
  double averageRating;
  int ratingCount;
  List<String> images;
  String categoryName;
  String imageFeature;
  List<ProductAttribute> attributes;
  List<ProductAttribute> infors = [];
  List<ProductVariation> variations = [];
  int categoryId;
  String videoUrl;
  String status;
  List<int> groupedProducts;
  List<String> files;
  int stockQuantity;
  int minQuantity;
  int maxQuantity;
  int defaultVariationId;
  bool manageStock;

  /// is to check the type affiliate, simple, variant
  String type;
  String affiliateUrl;
  Map<String, dynamic> multiCurrencies;

  String storeId;

  ProductModel();

  ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson["id"];
      defaultVariationId = parsedJson["variations"][0];
      categoryName = parsedJson["categories"][0]["name"];
      name = parsedJson["name"];
      type = parsedJson["type"];
      description = isNotBlank(parsedJson["description"]) ? parsedJson["description"] : parsedJson["short_description"];
      permalink = parsedJson["permalink"];
      price = parsedJson["price"] != null ? double.parse(parsedJson["price"].toString()).toStringAsFixed(2) : "";

      regularPrice = parsedJson["regular_price"] != null ? parsedJson["regular_price"].toString() : null;
      salePrice = parsedJson["sale_price"] != null ? parsedJson["sale_price"].toString() : null;
      onSale = parsedJson["on_sale"] == null ? false : parsedJson["on_sale"];
      ;
      inStock = parsedJson["in_stock"] ?? parsedJson["stock_status"] == "instock";

      averageRating = double.parse(parsedJson["average_rating"]);
      ratingCount = int.parse(parsedJson["rating_count"].toString());

      categoryId = parsedJson["categories"] != null && parsedJson["categories"].length > 0
          ? parsedJson["categories"][0]["id"]
          : 0;

      manageStock = parsedJson['manage_stock'] ?? false;

      // add stock limit
      if (parsedJson['manage_stock'] == true) {
        stockQuantity = parsedJson['stock_quantity'];
      }

      //minQuantity = parsedJson['meta_data']['']

      List<ProductAttribute> attributeList = [];
      parsedJson["attributes"].forEach((item) {
        if (item['visible'] && item['variation']) {
          attributeList.add(ProductAttribute.fromJson(item));
        }
      });
      attributes = attributeList;

      parsedJson["attributes"].forEach((item) {
        infors.add(ProductAttribute.fromJson(item));
      });

      List<String> list = [];

      // get images links from meta data
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
      }

      for (var item in parsedJson["images"]) {
        list.add(item["src"]);
      }

      images = list;
      imageFeature = images[0];

      // get video link
      var video = parsedJson['meta_data'].firstWhere(
        (item) => item['key'] == '_video_url' || item['key'] == '_woofv_video_embed',
        orElse: () => null,
      );
      if (video != null) {
        videoUrl = video['value'] is String ? video['value'] : video['value']['url'] ?? '';
      }

      affiliateUrl = parsedJson['external_url'];
      multiCurrencies = parsedJson['multi-currency-prices'];

      List<int> groupedProductList = [];
      parsedJson['grouped_products'].forEach((item) {
        groupedProductList.add(item);
      });
      groupedProducts = groupedProductList;
      List<String> files = [];
      parsedJson['downloads'].forEach((item) {
        files.add(item['file']);
      });
      this.files = files;
      for (var item in parsedJson['meta_data']) {
        try {
          if (item['key'] == '_minmax_product_max_quantity') {
            int quantity = int.parse(item['value']);
            quantity == 0 ? maxQuantity = null : maxQuantity = quantity;
          }
        } catch (e) {
          print('maxQuantity $e');
        }

        try {
          if (item['key'] == '_minmax_product_min_quantity') {
            int quantity = int.parse(item['value']);
            quantity == 0 ? minQuantity = null : minQuantity = quantity;
          }
        } catch (e) {
          print('minQuantity $e');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sku": sku,
      "name": name,
      "description": description,
      "permalink": permalink,
      "price": price,
      "regularPrice": regularPrice,
      "salePrice": salePrice,
      "onSale": onSale,
      "inStock": inStock,
      "averageRating": averageRating,
      "ratingCount": ratingCount,
      "images": images,
      "imageFeature": imageFeature,
      "attributes": attributes,
      "categoryId": categoryId,
      "multiCurrencies": multiCurrencies,
      "stock_quantity": stockQuantity
    };
  }

  ProductModel.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      sku = json['sku'];
      name = json['name'];
      description = parse(GuardParser.safeCast<String>(json['description'])).documentElement.text;
      permalink = json['permalink'];
      price = json['price'];
      regularPrice = json['regularPrice'];
      salePrice = json['salePrice'];
      onSale = json['onSale'] == null ? false : json['onSale'];
      inStock = json['inStock'];
      averageRating = json['averageRating'];
      ratingCount = json['ratingCount'];
      List<String> imgs = [];
      for (var item in json['images']) {
        imgs.add(item);
      }
      images = imgs;
      imageFeature = json['imageFeature'];
      List<ProductAttribute> attrs = [];
      for (var item in json['attributes']) {
        attrs.add(ProductAttribute.fromLocalJson(item));
      }
      attributes = attrs;
      categoryId = json['categoryId'];
      multiCurrencies = json['multiCurrencies'];
      stockQuantity = json['stock_quantity'];
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() => 'Product { id: $id name: $name }';
}

class ProductAttribute {
  int id;
  String name;
  List options = [];

  ProductAttribute.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["name"];
    parsedJson["options"].forEach(
      (element) {
        options.add(element);
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "options": options};
  }

  ProductAttribute.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      options = json['options'];
    } catch (e) {
      print(e.toString());
    }
  }
}

class Attribute {
  int id;
  String name;
  String option;

  Attribute();

  Attribute.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["name"];
    var sad = int.tryParse(parsedJson["option"]);
    if (sad == null) {
      option = Uri.decodeFull(parsedJson["option"]).toString().toUpperCase();
      print(option);
    } else {
      option = parsedJson["option"].toString().toUpperCase();
    }
  }

  Attribute.fromLocalJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    name = parsedJson["name"];
    option = parsedJson["option"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "option": option};
  }
}

class ProductVariation {
  int id;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String image;
  bool onSale;
  bool inStock;
  int stockQuantity;
  String imageFeature;
  List<Attribute> attributes = [];
  Map<String, dynamic> multiCurrencies;

  ProductVariation();

  ProductVariation.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    image = parsedJson["image"]["src"];
    price = parsedJson["price"] != null || parsedJson["sale_price"].isNotEmpty
        ? double.parse(parsedJson["price"].toString()).toStringAsFixed(2)
        : "";
    regularPrice = parsedJson["regular_price"] != null || parsedJson["sale_price"].isNotEmpty
        ? double.parse(parsedJson["regular_price"].toString()).toStringAsFixed(2)
        : "";
    salePrice = parsedJson["sale_price"] != null && parsedJson["sale_price"].isNotEmpty
        ? double.parse(parsedJson["sale_price"].toString()).toStringAsFixed(2)
        : "";
    onSale = parsedJson["on_sale"] == null ? false : parsedJson["on_sale"];
    inStock = parsedJson["stock_status"] == "instock";
    inStock ? stockQuantity = parsedJson["stock_quantity"] : stockQuantity = 0;
    imageFeature = parsedJson["image"]["src"];
    List<Attribute> attributeList = [];
    parsedJson["attributes"].forEach((item) {
      attributeList.add(Attribute.fromJson(item));
    });
    attributes = attributeList;
    multiCurrencies = parsedJson['multi-currency-prices'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "price": price,
      "regularPrice": regularPrice,
      "sale_price": salePrice,
      "on_sale": onSale,
      "in_stock": inStock,
      "stock_quantity": stockQuantity,
      "image": {"src": imageFeature},
      "attributes": attributes.map((item) {
        return item.toJson();
      }).toList()
    };
  }

  ProductVariation.fromLocalJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      price = json['price'];
      regularPrice = json['regularPrice'];
      onSale = json["on_sale"] == null ? false : json["on_sale"];
      salePrice = json['salePrice'];
      inStock = json['inStock'];
      inStock ? stockQuantity = json["stock_quantity"] : stockQuantity = 0;
      imageFeature = json['image']["src"];
      List<Attribute> attributeList = [];
      for (var item in json['attributes']) {
        attributeList.add(Attribute.fromLocalJson(item));
      }
      attributes = attributeList;
    } catch (e) {
      print(e.toString());
    }
  }
}

class BookingDate {
  int value;
  String unit;

  BookingDate.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
  }
}
