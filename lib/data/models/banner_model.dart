class BannerModel {
  BannerModel({
    this.categoryId,
    this.categoryName,
    this.imagelink,
  });

  String categoryId;
  String categoryName;
  String imagelink;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    categoryId: json["category_id"] == null ? null : json["category_id"],
    categoryName: json["category_name"] == null ? null : json["category_name"],
    imagelink: json["imagelink"] == null ? null : json["imagelink"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId == null ? null : categoryId,
    "category_name": categoryName == null ? null : categoryName,
    "imagelink": imagelink == null ? null : imagelink,
  };
}
