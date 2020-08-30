
class ShippingMethod {
  String id;
  String title;
  String description;

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title};
  }

  ShippingMethod.fromJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson["id"];
      title =parsedJson["title"];
      description = parsedJson["description"];
    } catch (e) {
      print('error parsing Shipping method');
    }
  }
}
