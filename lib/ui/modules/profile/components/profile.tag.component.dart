import 'package:flutter/material.dart';

import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class ProfileTagComponent extends StatelessWidget {
  final Object userModel;

  const ProfileTagComponent({
    Key key,
    @required this.userModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.customGreyLevels[300],
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
                width: 60,
                child: ImageProcessor().customImage(
                  context,
                  "https://torky.dev/img/hero/me_mini.png",
                ),
              ),
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.8), width: 2),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(
            width: AppDimens.marginDefault16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userModel ?? "Mohamed ELTorky",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                userModel ?? "mohamedeltorky@joovlly.com",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
