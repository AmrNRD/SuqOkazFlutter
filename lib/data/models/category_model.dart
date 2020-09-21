import 'package:html_unescape/html_unescape.dart';
import 'package:suqokaz/utils/GuardParser.dart';
import 'package:suqokaz/utils/constants.dart';

class CategoryModel {
  int id;
  String name;
  String image;
  int parent;
  int menuOrder;
  int totalProduct;
  bool sorted;
  String banner;
  List<CategoryModel> children = [];

  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.menuOrder,
    this.parent,
    this.totalProduct,
    this.sorted = false,
    this.banner
  });

  CategoryModel.fromJson(Map<String, dynamic> parsedJson) {
    id = GuardParser.safeCast<int>(parsedJson["id"]);
    name = HtmlUnescape()
        .convert(GuardParser.safeCast<String>(parsedJson["name"]));
    parent = GuardParser.safeCast<int>(parsedJson["parent"]);
    totalProduct = GuardParser.safeCast<int>(parsedJson["count"]);
    menuOrder = GuardParser.safeCast<int>(parsedJson["menu_order"]);

    if (parsedJson["image"] != null) {
      final image = GuardParser.safeCast<Map>(parsedJson["image"]);
      if (image != null) {
        this.image = image["src"].toString();
      } else {
        this.image = Constants.kDefaultImage;
      }
    }
  }

  @override
  String toString() =>
      'Category { id: $id  name: $name, parent: $parent, childrens : ${children.length} }';
}
