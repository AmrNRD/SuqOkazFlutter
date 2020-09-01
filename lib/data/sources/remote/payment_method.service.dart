import 'base/api_caller.dart';

class PaymentMethodService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future getPaymentMethods() async {
    String url = "/payment_gateways";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {});
  }


}
