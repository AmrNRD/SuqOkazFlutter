//import 'package:flutter/material.dart';
//import 'package:localstorage/localstorage.dart';
//import 'package:quiver/strings.dart';
//import 'package:suqokaz/data/models/payment_method_model.dart';
//import 'package:suqokaz/data/models/product_model.dart';
//import 'package:suqokaz/data/models/shipping_method_model.dart';
//import 'package:suqokaz/data/models/shipping_method_zone_model.dart';
//import 'package:suqokaz/util/constants.dart';
//import 'package:suqokaz/util/tools.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//import 'address_model.dart';
//import 'coupon_model.dart';
//import 'user_model.dart';
//
//class CartModel with ChangeNotifier {
//
//  Address address;
//  ShippingMethodZone shippingMethod;
//  PaymentMethod paymentMethod;
//  Coupon couponObj;
//  String notes;
//  String currency;
//  double discountAmount = 0.0; //for magento
//
//  // The IDs and product Object currently in the cart.
//  final Map<int, ProductModel> item = {};
//
//  // The IDs and quantities of products currently in the cart.
//  final Map<String, int> _productsInCart = {};
//  Map<String, int> get productsInCart => Map.from(_productsInCart);
//
//  // The IDs and product variation of products currently in the cart.
//  final Map<String, ProductVariation> _productVariationInCart = {};
//  Map<String, ProductVariation> get productVariationInCart => Map.from(_productVariationInCart);
//
//  //This is used for magento
//  //The IDs and product sku of products currently in the cart.
//  final Map<String, String> _productSkuInCart = {};
//  Map<String, String> get productSkuInCart => Map.from(_productSkuInCart);
//
//  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);
//
//  double getSubTotal() {
//    return _productsInCart.keys.fold(0.0, (sum, key) {
//      if (_productVariationInCart[key] != null &&
//          _productVariationInCart[key].price != null &&
//          _productVariationInCart[key].price.isNotEmpty) {
//        return sum + double.parse(_productVariationInCart[key].price) * _productsInCart[key];
//      } else {
//        var productId;
//        if (key.contains("-")) {
//          productId = int.parse(key.split("-")[0]);
//        } else {
//          productId = int.parse(key);
//        }
//        String price = Tools.getPriceProductValue(item[productId], currency, onSale: true);
//        if (price.isNotEmpty) {
//          return sum + double.parse(price) * _productsInCart[key];
//        }
//        return sum;
//      }
//    });
//  }
//
//  double getItemTotal({ProductModel product, int quantity = 1}) {
//    double subtotal = double.parse(product.price) * quantity;
//    print('getItemTotal $subtotal');
//
//    if (couponObj != null) {
//      if (couponObj.discountType == "percent") {
//        return subtotal - subtotal * couponObj.amount / 100;
//      } else {
//        return subtotal - (couponObj.amount * quantity);
//      }
//    } else {
//      return subtotal;
//    }
//  }
//
//
//  double getTotal() {
//    double subtotal = getSubTotal();
//
//    if (couponObj != null) {
//      if (couponObj.discountType == "percent") {
//        subtotal -= subtotal * couponObj.amount / 100;
//      } else {
//        subtotal -= (couponObj.amount * totalCartQuantity);
//      }
//    }
//
//    // Add shipping fees
//    subtotal += getShippingCost();
//    return subtotal;
//  }
//
//  double getCouponCost() {
//    double subtotal = getSubTotal();
//    if (couponObj != null) {
//      if (couponObj.discountType == "percent") {
//        return subtotal * couponObj.amount / 100;
//      } else {
//        return couponObj.amount * totalCartQuantity;
//      }
//    } else {
//      return 0.0;
//    }
//  }
//
//  double getShippingCost() {
//    if (shippingMethod != null && shippingMethod.cost > 0) {
//      return shippingMethod.cost;
//    }
//    if (shippingMethod != null && isNotBlank(shippingMethod.classCost)) {
//      List items = shippingMethod.classCost.split("*");
//      String cost = items[0] != "[qty]" ? items[0] : items[1];
//      double shippingCost = double.parse(cost) != null ? double.parse(cost) : 0.0;
//      int count = 0;
//      _productsInCart.keys.forEach((key) {
//        count += _productsInCart[key];
//      });
//      return shippingCost * count;
//    }
//    return 0.0;
//  }
//
//  // Adds a product to the cart.
//  String addProductToCart({ProductModel product, int quantity = 1, ProductVariation variation, isSaveLocal = true}) {
//    String message = '';
//
//    var key = "${product.id}";
//    if (variation != null) {
//      if (variation.id != null) {
//        key += "-${variation.id}";
//      }
//      for (var attribute in variation.attributes) {
//        if (attribute.id == null) {
//          key += "-" + attribute.name + attribute.option;
//        }
//      }
//    }
//
//    //Check product's quantity before adding to cart
//    int total = !_productsInCart.containsKey(key) ? quantity : _productsInCart[key] + quantity;
//    int stockQuantity = variation == null ? product.stockQuantity : variation.stockQuantity;
//    print('stock is here');
//    print(product.manageStock);
//
//    if (product.manageStock == null || !product.manageStock) {
//      _productsInCart[key] = total;
//    } else if (total <= stockQuantity) {
//      if (product.minQuantity == null && product.maxQuantity == null) {
//        _productsInCart[key] = total;
//      } else if (product.minQuantity != null && product.maxQuantity == null) {
//        total < product.minQuantity ? message = 'Minimum quantity is ${product.minQuantity}' : _productsInCart[key] = total;
//      } else if (product.minQuantity == null && product.maxQuantity != null) {
//        total > product.maxQuantity
//            ? message = 'You can only purchase ${product.maxQuantity} for this product'
//            : _productsInCart[key] = total;
//      } else if (product.minQuantity != null && product.maxQuantity != null) {
//        if (total >= product.minQuantity && total <= product.maxQuantity) {
//          _productsInCart[key] = total;
//        } else {
//          if (total < product.minQuantity) {
//            message = 'Minimum quantity is ${product.minQuantity}';
//          }
//          if (total > product.maxQuantity) {
//            message = 'You can only purchase ${product.maxQuantity} for this product';
//          }
//        }
//      }
//    } else {
//      message = 'Currently we only have $stockQuantity of this product';
//    }
//
//    if (message.isEmpty) {
//      item[product.id] = product;
//      if (isSaveLocal) {
//        _productVariationInCart[key] = variation;
//        _productSkuInCart[key] = product.sku;
//        saveCartToLocal(product: product, quantity: quantity, variation: variation);
//      }
//    }
//
//    notifyListeners();
//    return message;
//  }
//
//  String updateQuantity(ProductModel product, String key, int quantity) {
//    String message = '';
//    int total = quantity;
//    ProductVariation variation;
//
//    if (key.contains('-')) {
//      variation = getProductVariationById(key);
//    }
//    int stockQuantity = variation == null ? product.stockQuantity : variation.stockQuantity;
//
//    if (product.manageStock == null || !product.manageStock) {
//      _productsInCart[key] = total;
//    } else if (total <= stockQuantity) {
//      if (product.minQuantity == null && product.maxQuantity == null) {
//        _productsInCart[key] = total;
//      } else if (product.minQuantity != null && product.maxQuantity == null) {
//        total < product.minQuantity ? message = 'Minimum quantity is ${product.minQuantity}' : _productsInCart[key] = total;
//      } else if (product.minQuantity == null && product.maxQuantity != null) {
//        total > product.maxQuantity
//            ? message = 'You can only purchase ${product.maxQuantity} for this product'
//            : _productsInCart[key] = total;
//      } else if (product.minQuantity != null && product.maxQuantity != null) {
//        if (total >= product.minQuantity && total <= product.maxQuantity) {
//          _productsInCart[key] = total;
//        } else {
//          if (total < product.minQuantity) {
//            message = 'Minimum quantity is ${product.minQuantity}';
//          }
//          if (total > product.maxQuantity) {
//            message = 'You can only purchase ${product.maxQuantity} for this product';
//          }
//        }
//      }
//    } else {
//      message = 'Currently we only have $stockQuantity of this product';
//    }
//    if (message.isEmpty) {
//      updateQuantityCartLocal(key: key, quantity: quantity);
//      notifyListeners();
//    }
//    return message;
//  }
//
//  // Removes an item from the cart.
//  void removeItemFromCart(String key) {
//    if (_productsInCart.containsKey(key)) {
//      _productsInCart.remove(key);
//      _productVariationInCart.remove(key);
//      _productSkuInCart.remove(key);
//      removeProductLocal(key);
////      if (_productsInCart[key] == 1) {
////        _productsInCart.remove(key);
////        _productVariationInCart.remove(key);
////        _productSkuInCart.remove(key);
////      } else {
////        _productsInCart[key]--;
////      }
//    }
//    notifyListeners();
//  }
//
//  void setAddress(data) {
//    address = data;
//    saveShippingAddress(data);
//  }
//
//  void setShippingMethod(data) {
//    shippingMethod = data;
//  }
//
//  void setPaymentMethod(data) {
//    paymentMethod = data;
//  }
//
//  // Returns the Product instance matching the provided id.
//  ProductModel getProductById(int id) {
//    return item[id];
//  }
//
//  // Returns the Product instance matching the provided id.
//  ProductVariation getProductVariationById(String key) {
//    return _productVariationInCart[key];
//  }
//
//  // Removes everything from the cart.
//  void clearCart() {
//    clearCartLocal();
//    _productsInCart.clear();
//    item.clear();
//    _productVariationInCart.clear();
//    _productSkuInCart.clear();
//    shippingMethod = null;
//    paymentMethod = null;
//    couponObj = null;
//    notes = null;
//    discountAmount = 0.0;
//    notifyListeners();
//  }
//
//
//  Future<void> saveShippingAddress(Address address) async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        await storage.setItem(Constants.kLocalKey["shippingAddress"], address);
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  Future<void> saveCartToLocal({
//    ProductModel product,
//    int quantity = 1,
//    ProductVariation variation,
//  }) async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        List items = await storage.getItem(Constants.kLocalKey["cart"]);
//
//        // Get language
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        var locale = prefs.getString("language") ?? Constants.kAdvanceConfig['DefaultLanguage'];
//
//        if (items != null && items.isNotEmpty) {
//          items.add({
//            "product": product,
//            "quantity": quantity,
//            "variation": variation != null ? variation.toJson() : "null"
//          });
//        } else {
//          items = [
//            {
//              "product": product,
//              "quantity": quantity,
//              "variation": variation != null ? variation.toJson() : "null"
//            }
//          ];
//        }
//        await storage.setItem(Constants.kLocalKey["cart"], items);
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  Future<void> updateQuantityCartLocal({String key, int quantity = 1}) async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        List items = await storage.getItem(Constants.kLocalKey["cart"]);
//        List results = [];
//        if (items != null && items.isNotEmpty) {
//          for (var item in items) {
//            final product = ProductModel.fromLocalJson(item["product"]);
//            final ids = key.split("-");
//            ProductVariation variant = item["variation"] != "null" ? ProductVariation.fromLocalJson(item["variation"]) : null;
//            if ((product.id == int.parse(ids[0]) && ids.length == 1) ||
//                (variant != null && product.id == int.parse(ids[0]) && variant.id == int.parse(ids[1]))) {
//              results.add(
//                {"product": product.toJson(), "quantity": quantity, "variation": variant},
//              );
//            } else {
//              results.add(item);
//            }
//          }
//        }
//        await storage.setItem(Constants.kLocalKey["cart"], results);
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  Future<void> getCartInLocal() async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        List items = await storage.getItem(Constants.kLocalKey["cart"]);
//        if (items != null && items.isNotEmpty) {
//          items.forEach((item) {
//            addProductToCart(
//                product: ProductModel.fromLocalJson(item["product"]),
//                quantity: item["quantity"],
//                variation: item["variation"] != "null" ? ProductVariation.fromLocalJson(item["variation"]) : null,
//                isSaveLocal: false);
//          });
//        }
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  Future<void> clearCartLocal() async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        await storage.deleteItem(Constants.kLocalKey["cart"]);
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  Future<void> removeProductLocal(String key) async {
//    final LocalStorage storage = LocalStorage("fstore");
//    try {
//      final ready = await storage.ready;
//      if (ready) {
//        List items = await storage.getItem(Constants.kLocalKey["cart"]);
//        if (items != null && items.isNotEmpty) {
//          final ids = key.split("-");
//          var item = items.firstWhere((item) => ProductModel.fromLocalJson(item["product"]).id == int.parse(ids[0]), orElse: () => null);
//          if (item != null) {
//            items.remove(item);
////            if (item["quantity"] == 1) {
////              items.remove(item);
////            } else {
////              item["quantity"]--;
////            }
//          }
//          await storage.setItem(Constants.kLocalKey["cart"], items);
//        }
//      }
//    } catch (err) {
//      print(err);
//    }
//  }
//
//  void setOrderNotes(String note) {
//    notes = note;
//    notifyListeners();
//  }
//
//  Future getCurrency() async {
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      currency = Utils.translateCurrency(prefs.getString("currency") ?? (Constants.kAdvanceConfig['DefaultCurrency'] as Map)['currency']);
//    } catch (e) {
//      currency = Utils.translateCurrency((Constants.kAdvanceConfig['DefaultCurrency'] as Map)['currency']);
//    }
//  }
//
//  void changeCurrency(value) {
//    currency = value;
//  }
//}
