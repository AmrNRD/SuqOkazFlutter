import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suqokaz/ui/common/star.rating.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductDetailsReviewComponent extends StatelessWidget {
  // ReviewModel reviewModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ImageProcessor().customImage(
                context,
                "https://torky.dev/img/hero/me_mini.png",
                //reviewModel.reviewrImage,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    start: AppDimens.marginDefault8,
                    end: AppDimens.marginDefault8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Test",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      DateFormat(
                        "d MMM y",
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
                        rating: 5, //reviewModel.rating + 0.0,
                        size: 16.0,
                        label: Text(""),
                        color: AppColors.primaryColors[50],
                        borderColor: AppColors.primaryColors[50],
                        spacing: 0.0),
                    SizedBox(
                      height: AppDimens.marginSeparator8,
                    ),
                    Text(
                      "Very nice product!", //reviewModel.review,
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
      },
    );
  }
}
