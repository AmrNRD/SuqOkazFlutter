import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/skeleton.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';

import 'constants.dart';

const double baseHeight = 812.0;
const double baseWidth = 375.0;

double screenAwareSize(double size, BuildContext context) {
  double drawingHeight =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  return size * drawingHeight / baseHeight;
}

double screenAwareWidth(double size, BuildContext context) {
  double drawingWidth =
      MediaQuery.of(context).size.width - AppDimens.marginDefault16;
  return size * drawingWidth / baseWidth;
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class QueryString {
  static Map parse(String query) {
    var search = RegExp('([^&=]+)=?([^&]*)');
    var result = Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);
    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1))] = decode(match.group(2));
    }
    return result;
  }
}

class ImageProcessor {
  static image(
      {String url,
      double width,
      double height,
      BoxFit fit,
      String tag,
      double offset = 0.0,
      isVideo = false,
      hidePlaceHolder = false}) {
    if (height == null && width == null) {
      width = 200;
    }

    if (url == null || url == '') {
      return Container(
          width: width,
          height: height ?? width * 1.2,
          color: AppColors.kEmptyColor);
    }

    if (isVideo) {
      return Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Colors.black12.withOpacity(1)),
            child: ExtendedImage.network(
              url,
              width: width,
              height: height ?? width * 1.2,
              fit: fit,
              cache: true,
              enableLoadState: false,
              alignment: Alignment(
                  (offset >= -1 && offset <= 1)
                      ? offset
                      : (offset > 0) ? 1.0 : -1.0,
                  0.0),
            ),
          ),
          Positioned.fill(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white70.withOpacity(0.5),
              size: width == null ? 30 : width / 1.7,
            ),
          ),
        ],
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      //alignment: Alignment((offset >= -1 && offset <= 1) ? offset : (offset > 0) ? 1.0 : -1.0, 0.0)
      alignment: Alignment.topCenter,
      placeholder: (context, url) => Skeleton(
        width: width ?? 100,
        height: height ?? 140,
      ),
      errorWidget: (context, url, error) => Container(
          width: width,
          height: height ?? width * 1.2,
          color: AppColors.kEmptyColor),
    );

//    return ImageCustom(url: imageUrl, mainUrl: url, width: width, fit: fit, height: height, offset: offset,);
  }

  Widget customImage(
    BuildContext context,
    String path, {
    double height = 50,
    bool isBorder = false,
  }) {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: CachedNetworkImage(
            imageUrl: path ?? Constants.dummyProfilePic,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
                margin: EdgeInsets.all(12),
                width: 20,
                height: 20,
                child: new CircularProgressIndicator(
                  strokeWidth: 1.5,
                )),
            errorWidget: (context, url, error) =>
                CachedNetworkImage(imageUrl: Constants.dummyProfilePic),
          )),
    );
  }

  double screenAwareSize(double size, BuildContext context) {
    double drawingHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return size * drawingHeight / baseHeight;
  }

  double screenAwareWidth(double size, BuildContext context) {
    double drawingWidth =
        MediaQuery.of(context).size.width - AppDimens.marginDefault16;
    return size * drawingWidth / baseWidth;
  }
}
