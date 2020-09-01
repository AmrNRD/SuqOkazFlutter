import 'package:suqokaz/data/models/payment_method_model.dart';
import 'package:suqokaz/data/sources/remote/payment_method.service.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> loadPaymentMethod();
}

class PaymentMethodDataRepository extends PaymentMethodRepository {
  PaymentMethodService _shippingMethodService;
  PaymentMethodDataRepository() {
    _shippingMethodService = PaymentMethodService();
  }
  @override
  Future<List<PaymentMethod>> loadPaymentMethod() async {
    var res = await _shippingMethodService.getPaymentMethods();

    List<PaymentMethod> list = [];
    for (var itemData in res) {
      var item = PaymentMethod.fromJson(itemData);
      list.add(item);
    }
    return list;
  }
}
