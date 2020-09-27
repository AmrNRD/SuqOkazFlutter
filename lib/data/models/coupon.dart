class Coupon {
  int id;
  String code;
  double amount;
  String discountType;
  // discount_type
  String description;

  Coupon.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      amount = double.tryParse(json['amount'].toString());
      discountType = json['discount_type'];
      description = json['description'];

    } catch (e) {
      print(e.toString());
    }
  }


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "discount": amount.toStringAsFixed(2),
      "discount_tax": "0",
    };
  }
}