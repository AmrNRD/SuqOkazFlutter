import 'base/api_caller.dart';

class CategoriesService {
  // Create ApiCaller instance
  APICaller apiCaller = new APICaller();

  Future<dynamic> getCategoriesByPage(
      {lang, page, bool parentOnly = false}) async {
    // Create URL
    String url = "/products/categories?per_page=100&page=$page";

    // Set parent only flag
    if (parentOnly)
      url = "/products/categories?per_page=100&parent=0&page=$page";

    // Set language
    if (lang != null) url += "&lang=$lang";

    // Get OAuth URL
    final String oAuthUrl = apiCaller.getOAuthURL("GET", url, true);

    // Set url to caller
    apiCaller.setUrl(oAuthUrl);

    // Make GET request and return result
    return await apiCaller.getData(headers: {});
  }
}
