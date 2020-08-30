import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/review_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ProductsRepository _productsRepository;
  ReviewBloc(this._productsRepository) : super(ReviewInitial());

  @override
  Stream<ReviewState> mapEventToState(
    ReviewEvent event,
  ) async* {
    try {
      if (event is GetProductReviewsEvent) {
        yield ProductReviewLoadingState();
        List<ReviewModel> reviewModel =
            await _productsRepository.getProductReviews(
          productId: event.id ?? "1",
        );
        yield ProductReviewsLoadedState(
          reviewModel,
        );
      }
    } catch (e) {
      yield ProductReviewErrorState(e.toString());
    }
    try {
      if (event is SubmitProductReviewEvent) {
        yield ReviewSubmitLoadingState();
        await _productsRepository.submitReview(
          body: event.review.toJson(),
        );
        yield ReviewSubmitedState();
      }
    } catch (e) {
      print(e.toString());
      yield ReviewSubmitError(e.toString());
    }
  }
}
