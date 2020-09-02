import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/modules/navigation/home.navigation.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductHorizontalListView extends StatefulWidget {
  final List<ProductModel> products;

  ProductHorizontalListView({
    Key key,
    this.products,
  }) : super(key: key);

  @override
  _ProductHorizontalListViewState createState() =>
      _ProductHorizontalListViewState();
}

class _ProductHorizontalListViewState extends State<ProductHorizontalListView> {
  Map<int, CartItem> productIdToCartItem = {};

  @override
  void initState() {
    super.initState();
    productIdToCartItem =
        BlocProvider.of<CartBloc>(context).productIdToCartItem;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartLoadedState) {
          setState(() {
            productIdToCartItem = state.productIdToCartItem;
          });
        } else if (state is CartErrorState) {
          HomeNavigationPage.scaffoldKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
              content: Text(
                AppLocalizations.of(context).translate(state.message),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.red),
              ),
            ),
          );
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            height: screenAwareSize(250, context),
            child: ListView.builder(
              itemCount: widget.products.length,
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Constants.productDetailsPage,
                    arguments: widget.products[index],
                  ),
                  child: ProductCardComponent(
                    product: widget.products[index],
                    isInCart: productIdToCartItem
                            .containsKey(widget.products[index].id) ??
                        false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
