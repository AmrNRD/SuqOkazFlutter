import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({Key key, this.size}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size ?? 150,
        width: size ?? 150,
        child: Loading(
          indicator: BallScaleIndicator(),
          color: AppColors.primaryColors[50],
        ),
      ),
    );
  }
}
