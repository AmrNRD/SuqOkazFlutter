part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();
}

class ReviewInitial extends ReviewState {
  @override
  List<Object> get props => [];
}

class ProductReviewLoadingState extends ReviewState {
  @override
  List<Object> get props => [];
}

class ProductReviewsLoadedState extends ReviewState {
  final List<ReviewModel> reviews;

  ProductReviewsLoadedState(this.reviews);
  @override
  List<Object> get props => [];
}

class ProductReviewErrorState extends ReviewState {
  final String message;

  ProductReviewErrorState(this.message);
  @override
  List<Object> get props => [];
}

class ReviewSubmitError extends ReviewState {
  final String message;

  ReviewSubmitError(this.message);
  @override
  List<Object> get props => [];
}

class ReviewSubmitLoadingState extends ReviewState {
  @override
  List<Object> get props => [];
}

class ReviewSubmitedState extends ReviewState {
  @override
  List<Object> get props => [];
}
