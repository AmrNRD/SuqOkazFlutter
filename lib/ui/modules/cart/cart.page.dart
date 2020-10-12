import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/modules/cart/screens/cart.details.screen.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class CartPage extends StatelessWidget {
  CartPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        canPop: true,
        text: AppLocalizations.of(context).translate("cart", defaultText: "Cart"),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          print(state.runtimeType);
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
              return CartDetailsScreen(
                productItems: state.products,
              );
            }
          } else if (state is CartLoadingState) {
            return LoadingWidget();
          } else if (state is CartErrorState) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: GenericState(
                  imagePath: Constants.imagePath["error"],
                  titleKey: "error_title",
                  buttonKey: "refresh",
                  bodyKey: state.message,
                  removeButton: false,
                  onPress: () {
                    BlocProvider.of<CartBloc>(context).add(GetCartEvent());
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
