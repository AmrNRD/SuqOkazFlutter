import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends PreferredSize {
  final text;
  final double height;
  final bool canPop;

  CustomAppBar({
    @required this.text,
    this.height = kToolbarHeight,
    this.canPop = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              onPressed: () {},
            ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search_icon.svg",
            height: 16,
            width: 16,
            fit: BoxFit.contain,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
