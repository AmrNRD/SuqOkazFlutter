import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.long.component.dart';
import 'package:suqokaz/ui/modules/category/category.page.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class ProductListViewBuilder extends StatefulWidget {
  const ProductListViewBuilder({
    Key key,
    @required ScrollController scrollController,
    @required this.products,
    @required this.showLoading,
    @required this.lastPageReached,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final List<ProductModel> products;
  final bool showLoading;
  final bool lastPageReached;

  @override
  _ProductListViewBuilderState createState() => _ProductListViewBuilderState();
}

class _ProductListViewBuilderState extends State<ProductListViewBuilder> {
  Map<int, CartItem> productIdToCartItem = {};
  @override
  void initState() {
    super.initState();
    productIdToCartItem = BlocProvider.of<CartBloc>(context).productIdToCartItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: widget.products.isEmpty || widget.products == null
              ? Center(
                  child: GenericState(
                    size: 40,
                    margin: 8,
                    fontSize: 16,
                    removeButton: true,
                    imagePath: Constants.imagePath["empty_box"],
                    //TODO: Translate
                    titleKey: AppLocalizations.of(context).translate("todo", defaultText: "No products founcs"),
                    bodyKey: AppLocalizations.of(context).translate(
                      "todo",
                      defaultText: "Sorry no product were found in this category.",
                    ),
                  ),
                )
              : BlocListener<CartBloc, CartState>(
                  listener: (context, state) {
                    if (state is CartLoadedState) {
                      setState(() {
                        productIdToCartItem = state.productIdToCartItem;
                      });
                    } else if (state is CartErrorState) {
                      CategoryPage.scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.green,
                          content: Text(
                            AppLocalizations.of(context).translate(state.message),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.red),
                          ),
                        ),
                      );
                    }
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: widget._scrollController,
                    padding: EdgeInsets.only(top: 0),
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCardLongComponent(
                        allowMargin: false,
                        variationId: widget.products[index].defaultVariationId,
                        product: widget.products[index],
                        isInCart: productIdToCartItem.containsKey(widget.products[index].id) ?? false,
                        onItemTap: () {
                          Navigator.pushNamed(
                            context,
                            Constants.productDetailsPage,
                            arguments: widget.products[index],
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
        widget.showLoading
            ? widget.lastPageReached
                ? Container()
                : SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: LoadingWidget(
                        size: 40,
                      ),
                    ),
                  )
            : Container(),
      ],
    );
  }
}
