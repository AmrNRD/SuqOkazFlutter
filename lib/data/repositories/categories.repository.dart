import 'package:suqokaz/data/sources/remote/categories.service.dart';

abstract class CategoriesDataRepository {
  Future loadCategories(int pageIndex, bool parentOnly);
}

class CategoriesRepository extends CategoriesDataRepository {
  CategoriesService _categoriesService;
  CategoriesRepository() {
    _categoriesService = CategoriesService();
  }
  @override
  Future loadCategories(int pageIndex, bool parentOnly) async {
    return await _categoriesService.getCategoriesByPage(
      page: pageIndex,
      parentOnly: parentOnly,
    );
  }
}
