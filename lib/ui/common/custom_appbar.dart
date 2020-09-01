import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/utils/constants.dart';

class CustomAppBar extends PreferredSize {
  final text;
  final double height;
  final double elevation;
  final bool canPop;
  final bool removeSearch;

  CustomAppBar({
    @required this.text,
    this.height = kToolbarHeight,
    this.canPop = false,
    this.elevation,
    this.removeSearch = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? null,
      title: Center(
        child: text is String
            ? Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontWeight: FontWeight.w500),
              )
            : text,
      ),
      leading: canPop
          ? BackButton()
          : IconButton(
              icon: SvgPicture.asset(
                "assets/icons/category_icon.svg",
                height: 16,
                width: 16,
                fit: BoxFit.contain,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Constants.categoryPage,
                );
              },
            ),
      actions: <Widget>[
        IconButton(
          icon: removeSearch
              ? Container()
              : SvgPicture.asset(
                  "assets/icons/search_icon.svg",
                  height: 16,
                  width: 16,
                  fit: BoxFit.contain,
                ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              Constants.searchScreen,
            );
          },
        ),
      ],
    );
  }
}
