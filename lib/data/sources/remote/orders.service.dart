import 'base/api_caller.dart';

class OrdersService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future<dynamic> getOrders({int userID, int pageIndex, int perPage}) async {
    String url = "/orders?customer=$userID&per_page=$perPage&page=$pageIndex";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {});
  }

  Future<dynamic> getOrderNote({int orderId, int userID, int page, int perPage}) async {
    String url = "orders/$orderId/notes?customer=$userID&per_page=$perPage";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {});
  }
}
