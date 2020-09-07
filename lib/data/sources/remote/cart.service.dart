import 'package:suqokaz/data/sources/remote/base/api_caller.dart';

class CartRemoteService {
  APICaller _apiCaller = new APICaller();

  Future getShippingMethods() async {
    String url = "/shipping_methods";

    final String oAuthUrl = _apiCaller.getOAuthURL("GET", url, true);
    // Set url to caller
    _apiCaller.setUrl(oAuthUrl);
    // Make GET request and return result
    return await _apiCaller.getData(headers: {});
  }
}
