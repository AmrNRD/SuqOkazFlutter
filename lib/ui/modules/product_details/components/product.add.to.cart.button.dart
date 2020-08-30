import 'package:flutter/material.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.marginEdgeCase24,
            vertical: AppDimens.marginDefault12,
          ),
          color: Color(0xFFF0F0F0),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "-",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "1",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "+",
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              color: AppColors.primaryColors[50],
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).padding.bottom <= 20
                          ? 20
                          : MediaQuery.of(context).padding.bottom - 5),
                  child: Text(
                    AppLocalizations.of(context).translate("add_cart"),
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
