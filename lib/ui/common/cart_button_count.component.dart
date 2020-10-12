import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

import '../../main.dart';

class CartButtonWithCountComponent extends StatefulWidget {
  final bool disableCart;
  final bool removeMargin;

  const CartButtonWithCountComponent({
    Key key,
    this.disableCart = false,
    this.removeMargin = false,
  }) : super(key: key);

  @override
  _CartButtonWithCountComponentState createState() => _CartButtonWithCountComponentState();
}

class _CartButtonWithCountComponentState extends State<CartButtonWithCountComponent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cartCounter = BlocProvider.of<CartBloc>(context).totalCartQuantity;
  }

  int cartCounter = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (BuildContext context, CartState state) {
        if (state is CartLoadedState) {
          setState(() {
            cartCounter = state.counter;
          });
        }
      },
      child: GestureDetector(
        onTap: widget.disableCart
            ? null
            : () {
                if (Root.user == null) {
                  Navigator.pushNamed(context, Constants.authPage);
                } else {
                  Navigator.pushNamed(context, Constants.cartPage);
                }
              },
        child: Container(
          color: Colors.transparent,
          margin: widget.removeMargin ? EdgeInsets.zero : EdgeInsetsDirectional.only(start: 10),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/ic_cart_unselected.svg",
                height: 16,
                width: 16,
              ),
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 18, start: 14),
                child: buildCounter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCounter() {
    return cartCounter == 0
        ? Container()
        : Container(
            decoration: BoxDecoration(
              color: Color(0xFFEB5757),
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 15,
              minHeight: 15,
            ),
            child: Container(
              margin: EdgeInsets.all(4),
              child: Text(
                '$cartCounter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
