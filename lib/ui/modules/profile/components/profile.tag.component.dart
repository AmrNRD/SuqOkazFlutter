import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/user_model.dart';

import '../../../../utils/core.util.dart';
import '../../../style/app.colors.dart';
import '../../../style/app.dimens.dart';

class ProfileTagComponent extends StatelessWidget {
  final UserModel user;

  const ProfileTagComponent({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.customGreyLevels[300],
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Row(
        children: <Widget>[
          user?.image != null
              ? Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ImageProcessor().customImage(
                        context,
                        user?.image,
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                )
              : Container(),
          SizedBox(
            width: AppDimens.marginDefault16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user?.name ?? "",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                user?.email ?? "",
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
