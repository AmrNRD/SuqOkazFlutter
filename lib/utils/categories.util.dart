import 'package:suqokaz/data/models/category_model.dart';

class CategoriesUtil {
  static List<CategoryModel> nestCategories(List<CategoryModel> categories) {
    List<CategoryModel> nestedCategories = [];

    for (CategoryModel category in categories) {
      if (category.parent == 0) {
        nestedCategories.add(category);
        category.sorted = true;
      } else {
        CategoryModel parentCategory = categories.firstWhere(
            (element) => element.id == category.parent,
            orElse: () => null);
        if (parentCategory != null) {
          parentCategory.children.add(category);

          category.sorted = true;
        }
      }
    }
    nestedCategories.addAll(
      categories.where((element) => element.sorted == false).toList(),
    );
    return nestedCategories;
  }
}
