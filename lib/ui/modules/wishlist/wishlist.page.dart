import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/wishlist/wishlist_bloc.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.card.long.component.dart';
import 'package:suqokaz/ui/common/product.listview.builder.dart';
import 'package:suqokaz/ui/modules/cart/components/cart.product.component.dart';
import 'package:suqokaz/utils/constants.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoadedState) {
          if (state.products.isEmpty) {
            return Center(
              child: Container(
                margin: EdgeInsets.all(10),
                child: GenericState(
                  imagePath: Constants.imagePath["empty_box"],
                  titleKey: "You don't have any items in the wishlist",
                  bodyKey: "Feature will be added in next relese.",
                  removeButton: true,
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ProductCardLongComponent(
                      product: state.products[index],
                      isInFav: true,
                      showAttributes: true,
                    ),
                  );
                },
                itemCount: state.products.length,
              ),
            );
          }
        } else if (state is WishlistLoadingState) {
          return LoadingWidget();
        }
        return Container();
      },
    );
  }
}
