import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends PreferredSize {
  final String text;
  final double height;

  CustomAppBar({@required this.text, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      leading: IconButton(
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
