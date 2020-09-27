import 'package:suqokaz/data/sources/remote/base/api_caller.dart';

class CouponService {
  APICaller _apiCaller = new APICaller();

  Future checkCoupon(String code) async {
    String url = "/coupons?code=$code";

    final String oAuthUrl = _apiCaller.getOAuthURL("GET", url, true);
    // Set url to caller
    _apiCaller.setUrl(oAuthUrl);
    // Make GET request and return result
    return await _apiCaller.getData(headers: {});
  }
}
