import 'package:suqokaz/data/models/category_model.dart';

class CategoriesUtil {
  static List<dynamic> nestCategories(var categories) {
    var nestedCategories = [];

    for (var category in categories) {
      if (category.parent == 0) {
        nestedCategories.add(category);
        category.sorted = true;
      } else {
        var parentCategory = categories.firstWhere(
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
