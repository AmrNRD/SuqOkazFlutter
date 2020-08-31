import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/modules/cart/screens/cart.details.screen.dart';
import 'package:suqokaz/utils/constants.dart';

class CartPage extends StatelessWidget {
  CartPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, CartState state) {
        if (state is CartLoadedState) {
          if (state.products.isEmpty || state.products == null) {
            return Center(
              child: GenericState(
                imagePath: Constants.imagePath["empty_box"],
                titleKey: "empty cart title",
                bodyKey: "empty cart body",
                removeButton: true,
              ),
            );
          } else {
            state.products.forEach((element) {
              print(element.toJson());
              print('-----------------------------------------------------');
            });
            return CartDetailsScreen(
              productItems: state.products,
            );
          }
        } else if (state is CartLoadingState) {
          return LoadingWidget();
        } else if (state is CartErrorState) {
          return Center(
            child: GenericState(
              imagePath: Constants.imagePath["error"],
              titleKey: "error_title",
              bodyKey: state.message,
              removeButton: true,
            ),
          );
        }
        return Container();
      },
    );
  }
}
