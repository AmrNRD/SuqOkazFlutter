import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:suqokaz/bloc/review/review_bloc.dart';
import 'package:suqokaz/data/models/review_model.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/star.rating.dart';
import 'package:suqokaz/ui/modules/product_details/components/add_review.sheet.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductDetailsReviewComponent extends StatelessWidget {
  final productId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProductDetailsReviewComponent(
      {Key key, @required this.productId, @required this.scaffoldKey})
      : super(key: key);
  @override //ReviewSubmitedState
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocListener<ReviewBloc, ReviewState>(
          listener: (BuildContext context, ReviewState state) {
            if (state is ReviewSubmitedState) {
              print("Completed");
              BlocProvider.of<ReviewBloc>(context).add(
                GetProductReviewsEvent(
                  productId.toString(),
                ),
              );
            }
          },
          child: BlocBuilder<ReviewBloc, ReviewState>(
            builder: (BuildContext context, ReviewState state) {
              if (state is ProductReviewsLoadedState) {
                if (state.reviews == null || state.reviews.isEmpty) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: GenericState(
                      size: 40,
                      margin: 20,
                      fontSize: 16,
                      removeButton: true,
                      imagePath: Constants.imagePath["empty_box"],
                      titleKey: AppLocalizations.of(context).translate("No reviews yet", defaultText: "No reviews yet"),
                      bodyKey: AppLocalizations.of(context).translate(
                          "No reviews added yet, be the first to rate this product.",
                          defaultText:
                          "No reviews added yet, be the first to rate this product."),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: state.reviews.length,
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ReviewComponent(
                        reviewModel: state.reviews[index],
                      );
                    },
                  );
                }
              } else if (state is ProductReviewLoadingState) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: LoadingWidget(
                    size: 50,
                  ),
                );
              } else if (state is ProductReviewErrorState) {
                return Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: GenericState(
                    size: 40,
                    margin: 20,
                    fontSize: 16,
                    removeButton: true,
                    imagePath: Constants.imagePath["error"],
                    titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
                    bodyKey: state.message,
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
          child: Container(
            child: Text(
              AppLocalizations.of(context).translate(
                "Add Review",
                defaultText: "Add Review",
              ),
              style: Theme.of(context).textTheme.headline4.copyWith(
                color: AppColors.primaryColors[50],
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          onPressed: () {
            _showModalSheet(
              context,
            );
          },
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black54,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (builder) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddReviewSheet(
            productId: productId,
            parentContext: context,
            scaffoldKey: scaffoldKey,
          ),
        );
      },
    );
  }
}

class ReviewComponent extends StatelessWidget {
  final ReviewModel reviewModel;
  const ReviewComponent({
    Key key,
    @required this.reviewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ImageProcessor().customImage(
            context,
            reviewModel.reviewrImage,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsetsDirectional.only(
                start: AppDimens.marginDefault8, end: AppDimens.marginDefault8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  reviewModel.reviewerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  DateFormat(
                    reviewModel.dateCreated,
                    AppLocalizations.of(context).currentLanguage,
                  ).format(
                    DateTime.now(),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.customGreyLevels[100]),
                ),
                SizedBox(
                  height: AppDimens.marginSeparator4,
                ),
                SmoothStarRating(
                    starCount: 5,
                    rating: reviewModel.rating + 0.0,
                    size: 16.0,
                    label: Text(""),
                    color: AppColors.primaryColors[50],
                    borderColor: AppColors.primaryColors[50],
                    spacing: 0.0),
                SizedBox(
                  height: AppDimens.marginSeparator8,
                ),
                Text(
                  reviewModel.review,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: AppDimens.marginSeparator8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
