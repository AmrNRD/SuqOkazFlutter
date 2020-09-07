part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();
}

class GetProductReviewsEvent extends ReviewEvent {
  final String id;

  GetProductReviewsEvent(this.id);
  @override
  List<Object> get props => [this.id];
}

class SubmitProductReviewEvent extends ReviewEvent {
  final ReviewModel review;

  SubmitProductReviewEvent(this.review);
  @override
  List<Object> get props => [this.review];
}
