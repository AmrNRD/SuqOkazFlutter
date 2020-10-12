import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/models/review_model.dart';
import 'package:suqokaz/data/sources/remote/products.service.dart';

abstract class ProductsDataRepository {
  Future<dynamic> getCustomizableProducts(
      {int pageIndex,
      int perPage = 10,
      int categoryID,
      String tagID,
      double minPrice,
      double maxPrice,
      bool featured,
      bool onSale,
      String attribute,
      String attributeTerm,
      String order, // asc and desc. Default is desc
      String orderBy, // date, id, include, title and slug. Default is date
      String search,
      String lang});

  Future<dynamic> getFeaturedProducts({
    int pageIndex,
    int categoryId,
    bool featured,
  });
  Future<dynamic> getProductDetails({
    String productId,
  });
  Future<dynamic> getProductReviews({
    String productId,
  });

  Future<dynamic> submitReview({
    Map<String, dynamic> body,
  });

  Future<dynamic> getProductsWithInclude(List<int> include);

  Future<dynamic> getProductVariationsById(int id, int varId);

  Future<List<ProductVariation>> getProductVariations(int id);

  Future<dynamic> getApiProducts(
      {int pageIndex,
        int perPage = 10,
        String lang});
}

class ProductsRepository extends ProductsDataRepository {
  ProductsService productsService = new ProductsService();

  @override
  Future getCustomizableProducts(
      {int pageIndex,
      int perPage = 10,
      int categoryID,
      String tagID,
      double minPrice,
      double maxPrice,
      bool featured,
      bool onSale,
      String attribute,
      String attributeTerm,
      String order,
      String orderBy,
      String search,
      String lang}) async {

    return await productsService.getProducts(
      lang: lang,
      pageIndex: pageIndex,
      perPage: perPage,
      categoryID: categoryID,
      tagId: tagID,
      minPrice: minPrice,
      maxPrice: maxPrice,
      order: order,
      orderBy: orderBy,
      search: search,
      attribute: attribute,
      attributeTerm: attributeTerm,
      featured: featured,
      onSale: onSale,
    );
  }

  @override
  Future<dynamic> getFeaturedProducts({
    int pageIndex,
    int categoryId,
    bool featured,
  }) async {
    return await productsService.getProducts(
      featured: featured,
    );
  }

  @override
  Future<dynamic> getProductDetails({
    String productId,
  }) async {
    return await productsService.getProducts(
      productId: productId,
      getSingleProduct: true,
    );
  }

  @override
  Future getProductReviews({String productId}) async {
    final rawData = await productsService.getReviews(productId);
    List<ReviewModel> reviews = [];
    rawData.forEach((e) {
      reviews.add(
        ReviewModel.fromJson(e),
      );
    });
    return reviews;
  }

  @override
  Future submitReview({Map<String, dynamic> body}) async {
    return await productsService.submitReview(body);
  }

  @override
  Future getProductsWithInclude(List<int> include) async {
    return await productsService.getProductWithInclude(include);
  }

  @override
  Future<List<ProductVariation>> getProductVariations(int id) async {
    List<ProductVariation> temp = [];
    List<dynamic> rawData = await productsService.getProductVariation(id);
    rawData.forEach((element) {
      temp.add(ProductVariation.fromJson(element));
    });
    return temp;
  }

  @override
  Future getProductVariationsById(int id, int varId) async {
    return await productsService.getProductVariationById(id, varId);
  }

  @override
  Future getApiProducts(
      {int pageIndex,
        int perPage = 10,
        String lang}) async {

    return await productsService.getApiProducts(
      lang: lang,
      pageIndex: pageIndex,
      perPage: perPage
    );
  }
}
