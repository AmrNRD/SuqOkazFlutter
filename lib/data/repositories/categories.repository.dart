import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/data/sources/local/categories.service.local.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/data/sources/remote/categories.service.dart';

abstract class CategoriesDataRepository {
  Future loadCategories(int pageIndex, bool parentOnly);
  Future<List<CategoryData>> loadLocalCategories();
  Future saveLocalCategories(List<CategoryModel> categories);
  Future<List<CategoryData>> getAllCategories();
  Future resetAllCategories();
}

class CategoriesRepository extends CategoriesDataRepository {
  CategoriesService _categoriesService;
  CategoriesServiceLocal _categoriesLocalService;
  CategoriesRepository(AppDataBase _appDataBase) {
    _categoriesService = CategoriesService();
    _categoriesLocalService = CategoriesServiceLocal(_appDataBase);
  }
  @override
  Future loadCategories(int pageIndex, bool parentOnly) async {
    return await _categoriesService.getCategoriesByPage(
      page: pageIndex,
      parentOnly: parentOnly,
    );
  }

  @override
  Future<List<CategoryData>> loadLocalCategories() {
    return _categoriesLocalService.getAllCategories();
  }

  @override
  Future<List<CategoryData>> getAllCategories() {
    return _categoriesLocalService.getAllCategories();
  }

  @override
  Future saveLocalCategories(List<CategoryModel> categories) {
    return _categoriesLocalService.insertCategory(categories);
  }

  @override
  Future resetAllCategories() {
    return _categoriesLocalService.deleteAllCategories();
  }
}
