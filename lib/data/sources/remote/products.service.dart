import 'base/api_caller.dart';

class ProductsService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future<dynamic> getReviews(String productId) async {
    String url = "/products/reviews?product=$productId";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(headers: {});
  }

  Future<dynamic> submitReview(Map<String, dynamic> body) async {
    String url = "/products/reviews";
    final String oAuthUrl = apiCaller.getOAuthURL("POST", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.postData(body: body);
  }

  Future<dynamic> getProductWithInclude(List<int> include) async {
    String ids = "";
    include.forEach((element) {
      ids += element.toString() + ",";
    });
    String url = "/products?include=$ids";
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);
    apiCaller.setUrl(oAuthUrl);
    return await apiCaller.getData(
      headers: {},
    );
  }

  Future<dynamic> getProducts({
    lang = "en",
    pageIndex,
    perPage = 10,
    categoryID,
    tagId,
    minPrice,
    maxPrice,
    order,
    orderBy,
    attribute,
    attributeTerm,
    featured,
    onSale,
    String search,
    getSingleProduct = false,
    productId,
  }) async {
    String url;
    if (getSingleProduct) {
      // Create URL
      url = "/products/$productId";
      print(url);
    } else {
      // Create URL
      url =
          "/products?status=publish&lang=$lang&per_page=$perPage&page=$pageIndex";

      // Concatenate request extras
      if (categoryID != null) url += "&category=$categoryID";
      if (tagId != null) url += "&tag=$tagId";
      if (minPrice != null)
        url += "&min_price=${(minPrice as double).toInt().toString()}";
      if (maxPrice != null && maxPrice > 0)
        url += "&max_price=${(maxPrice as double).toInt().toString()}";
      if (order != null) url += "&order=$order";
      if (orderBy != null) url += "&order_by=$orderBy";
      if (attribute != null && attributeTerm != null)
        url += "&attribute=$attribute&attribute_term=$attributeTerm";
      if (featured != null) url += "&featured=$featured";
      if (onSale != null) url += "&on_sale=$onSale";
      if (search != null) url += "&search=$search";
    } // Get OAuth URL
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);

    // Set url to caller
    apiCaller.setUrl(oAuthUrl);

    // Make GET request and return result
    return await apiCaller.getData(headers: {});
  }
}
