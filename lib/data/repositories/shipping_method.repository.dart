import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/sources/remote/shipping_method.service.dart';

abstract class ShippingMethodRepository {
  Future<List<ShippingMethod>> loadShippingMethod();
}

class ShippingMethodDataRepository extends ShippingMethodRepository {
  ShippingMethodService _shippingMethodService;
  ShippingMethodDataRepository() {
    _shippingMethodService = ShippingMethodService();
  }
  @override
  Future<List<ShippingMethod>> loadShippingMethod() async {
    var res = await _shippingMethodService.getShippingMethods();

    List<ShippingMethod> list = [];
    for (var itemData in res) {
      var item = ShippingMethod.fromJson(itemData);
      list.add(item);
    }
    return list;
  }
}
