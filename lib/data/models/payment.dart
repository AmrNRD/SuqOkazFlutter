class Payment{
String id;
String status;
int amount;
int refunded;
int captured;
int fee;
String amountFormat;

Payment.fromJson(Map<String, dynamic> json) {
  try {
    id = json['id'];
    status = json['code'];
    amount = int.tryParse(json['amount'].toString());
    refunded = int.tryParse(json['refunded'].toString());
    captured = int.tryParse(json['captured'].toString());
    fee = int.tryParse(json['fee'].toString());
    amountFormat = json['amount_format'];
  } catch (e) {
    print(e.toString());
  }
}


}