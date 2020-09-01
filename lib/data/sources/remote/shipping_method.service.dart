import 'base/api_caller.dart';

class ShippingMethodService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future getShippingMethods() async {
    String url = "/shipping_methods";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {});
  }
}
