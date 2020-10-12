import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/data/models/banner_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/product.card.component.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class HomeProductsGridComponent extends StatefulWidget {
  final List<ProductModel> products;
  const HomeProductsGridComponent({Key key, this.products}) : super(key: key);
  @override
  _HomeProductsGridComponentState createState() => _HomeProductsGridComponentState();
}

class _HomeProductsGridComponentState extends State<HomeProductsGridComponent> {
  ScrollController _scrollController = ScrollController();
  Map<String, Null> wishListMaper = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    wishListMaper = BlocProvider.of<WishlistBloc>(context).wishListMaper;
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
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: AppDimens.marginDefault8,
            horizontal: AppDimens.marginDefault8,
          ),
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            crossAxisCount: 2,
            itemCount: widget.products.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppDimens.marginDefault8,
            mainAxisSpacing: AppDimens.marginDefault8,
            staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.35),
            scrollDirection: Axis.vertical,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductCardComponent(
                product: widget.products[index],
                onItemTap: () => Navigator.pushNamed(
                  context,
                  Constants.productDetailsPage,
                  arguments: widget.products[index],
                ),
                variationId: widget.products[index].defaultVariationId,
                attribute: widget.products[index].defaultAttributes,
                inInFav: wishListMaper.containsKey(widget.products[index].id.toString() +
                    widget.products[index].defaultVariationId.toString()) ??
                    false,
                imageHeight: 170,
                allowMargin: false,
              );
            },
          ),
        ));
  }
}
