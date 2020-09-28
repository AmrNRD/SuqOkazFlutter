import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/utils/constants.dart';

import 'cart_button_count.component.dart';

class CustomAppBar extends PreferredSize {
  final text;
  final double height;
  final double elevation;
  final bool canPop;
  final bool disableCart;
  final bool removeSearch;
  final Widget leadingButton;
  final List<Widget> actionButtons;

  CustomAppBar({
    @required this.text,
    this.height = kToolbarHeight,
    this.canPop = false,
    this.elevation,
    this.removeSearch = false,
    this.leadingButton,
    this.disableCart=false,
    this.actionButtons
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? null,
      centerTitle: true,
      title: text is String
          ? Text(
        text,
        style: Theme
            .of(context)
            .textTheme
            .headline1
            .copyWith(fontWeight: FontWeight.w500),
      )
          : text,
      leading: canPop ? null : leadingButton ?? CartButtonWithCountComponent(
        removeMargin: false,
        disableCart: disableCart,
      ),
      actions:actionButtons==null?  <Widget>[
        removeSearch
            ? Container()
            : IconButton(
          icon: SvgPicture.asset(
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
      ]:actionButtons,
    );
  }
}
