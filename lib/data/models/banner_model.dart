class BannerModel {
  int id;
  String slug;
  String categoryId;
  String categoryName;
  String image;

  BannerModel({
    this.id,
    this.slug,
    this.categoryId,
    this.categoryName,
    this.image,
  });

  BannerModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    categoryId = parsedJson["acf"]["category_id"];
    categoryName = parsedJson["acf"]["category_name"];
    image = parsedJson["acf"]["imagelink"];
    slug = parsedJson["slug"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "categoryId": categoryId,
      "category_name": categoryName,
      "image": image,
    };
  }
}
