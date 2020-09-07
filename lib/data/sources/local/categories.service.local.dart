import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

class CategoriesServiceLocal {
  // Create ApiCaller instance
  final AppDataBase appDataBase;

  CategoriesServiceLocal(this.appDataBase);

  Future<List<CategoryData>> getAllCategories({parentOnly = false}) async {
    if (parentOnly) {
      return await appDataBase.getAllParentCategories();
    } else {
      return await appDataBase.getAllCategories();
    }
  }

  Future<dynamic> getCategoryById(int id) async {
    return await appDataBase.getCategoriesById(id);
  }

  Future<dynamic> insertCategory(List<CategoryModel> categories) async {
    assert(categories != null);
    await Future.forEach(categories, (CategoryModel element) async {
      CategoryData categoryData;
      categoryData = CategoryData(
        id: element.id,
        name: element.name,
        image: element.image ?? "",
        parent: element.parent,
        menuOrder: element.menuOrder,
        totalProduct: element.totalProduct,
      );
      await appDataBase.insertCategory(categoryData);
    });
    return null;
  }

  Future<dynamic> deleteCategory(int id) async {
    return await appDataBase.deleteCategory(id);
  }

  Future<dynamic> updateCategory(CategoryData categoryData) async {
    return await appDataBase.updateCategory(categoryData);
  }
}
