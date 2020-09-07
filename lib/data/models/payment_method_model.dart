import 'package:quiver/strings.dart';

class PaymentMethod {
  String id;
  String title;
  String description;
  bool enabled;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "enabled": enabled
    };
  }

  PaymentMethod.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["id"];
    title = isNotBlank(parsedJson["title"])
        ? parsedJson["title"]
        : parsedJson["method_title"];
    description = parsedJson["description"];
    enabled = parsedJson["enabled"];
  }
}
