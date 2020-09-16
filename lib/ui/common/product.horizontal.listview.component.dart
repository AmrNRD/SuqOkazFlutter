import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class ProductHorizontalListView extends StatefulWidget {
  final List<ProductModel> products;

  ProductHorizontalListView({
    Key key,
    this.products,
  }) : super(key: key);

  @override
  _ProductHorizontalListViewState createState() => _ProductHorizontalListViewState();
}

class _ProductHorizontalListViewState extends State<ProductHorizontalListView> {
  Map<String, Null> wishListMaper = {};
  //[133152, 133153]
  @override
  void initState() {
    super.initState();
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;

    print(
        wishListMaper.containsKey(widget.products[0].id.toString() + widget.products[0].defaultVariationId.toString()));

    print(widget.products[0].id.toString() + widget.products[0].defaultVariationId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WishlistBloc, WishlistState>(
      listener: (context, state) {
        if (state is WishlistLoadedState) {
          setState(() {
            wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    variationId: widget.products[index].defaultVariationId,
                    attribute: widget.products[index].defaultAttributes,
                    inInFav: wishListMaper.containsKey(widget.products[index].id.toString() +
                            widget.products[index].defaultVariationId.toString()) ??
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
