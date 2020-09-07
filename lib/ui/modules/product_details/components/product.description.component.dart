import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductDescriptionComponent extends StatelessWidget {
  final String description;

  const ProductDescriptionComponent({
    Key key,
    @required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: description == null || description.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context).translate(
                  "no_description",
                  defaultText: "No description provided for this product.",
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: AppColors.customGreyLevels[600]),
              ),
            )
          : Text(
              description,
              style: Theme.of(context).textTheme.headline4,
            ),
    );
  }
}
