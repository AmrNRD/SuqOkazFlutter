import 'package:html/parser.dart';
import 'package:suqokaz/utils/GuardParser.dart';

class ReviewModel {
  int id;
  int productId;
  String reviewerName;
  String reviewrImage;
  String dateCreated;
  String review;
  String reviewerEmail;
  int rating;

  ReviewModel({
    this.id,
    this.reviewerName,
    this.reviewrImage,
    this.dateCreated,
    this.reviewerEmail,
    this.review,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "reviewer": reviewerName,
      "review": review,
      "reviewer_email": reviewerEmail,
      "rating": rating,
    };
  }

  ReviewModel.fromJson(Map<String, dynamic> parsedJson) {
    id = GuardParser.safeCast<int>(parsedJson["id"]);
    productId = GuardParser.safeCast<int>(parsedJson["product_id"]);
    reviewerName = parse(GuardParser.safeCast<String>(parsedJson["reviewer"]))
        .documentElement
        .text;
    rating = GuardParser.safeCast<int>(parsedJson["rating"]);
    review = parse(GuardParser.safeCast<String>(parsedJson["review"]))
        .documentElement
        .text;
    reviewerEmail = GuardParser.safeCast<String>(parsedJson["reviewer_email"]);
    reviewrImage =
        GuardParser.safeCast<String>(parsedJson["reviewer_avatar_urls"]["96"]);
    dateCreated = GuardParser.safeCast<String>(parsedJson["date_created"]);
  }
}
