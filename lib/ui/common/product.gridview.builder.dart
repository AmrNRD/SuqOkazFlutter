import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class ProductGridViewBuilder extends StatelessWidget {
  const ProductGridViewBuilder({
    Key key,
    @required ScrollController scrollController,
    @required this.products,
    @required this.productIdToCartItem,
    @required this.showLoading,
    @required this.lastPageReached,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final List<ProductModel> products;
  final Map<int, CartItem> productIdToCartItem;
  final bool showLoading;
  final bool lastPageReached;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: products.isEmpty || products == null
              ? Center(
                  child: GenericState(
                    size: 40,
                    margin: 8,
                    fontSize: 16,
                    removeButton: true,
                    imagePath: Constants.imagePath["empty_box"],
                    //TODO: Translate
                    titleKey: AppLocalizations.of(context)
                        .translate("todo", defaultText: "No products founcs"),
                    bodyKey: AppLocalizations.of(context).translate(
                      "todo",
                      defaultText:
                          "Sorry no product were found in this category.",
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 0),
                  physics: BouncingScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCardComponent(
                      allowMargin: false,
                      product: products[index],
                      isInCart:
                          productIdToCartItem.containsKey(products[index].id) ??
                              false,
                      onItemTap: () {
                        Navigator.pushNamed(
                          context,
                          Constants.productDetailsPage,
                          arguments: products[index],
                        );
                      },
                    );
                  },
                ),
        ),
        showLoading
            ? lastPageReached
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
