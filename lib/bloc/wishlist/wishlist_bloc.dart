import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/repositories/wishlist_repsitory.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(this._wishlistDataRepository, this._productsRepository) : super(WishlistLoadingState());

  final WishlistDataRepository _wishlistDataRepository;

  final ProductsRepository _productsRepository;

  List<ProductModel> list = [];
  Map<String, Null> wishListMaper = {};

  @override
  Stream<WishlistState> mapEventToState(
    WishlistEvent event,
  ) async* {
    try {
      if (event is GetWishListEvent) {
        yield WishlistLoadingState();
        List<WishlistItem> wishListItem = await _wishlistDataRepository.getWishlist();

        wishListItem.forEach((element) async {
          wishListMaper[element.productId.toString() + element.variationId.toString()] = null;
          await parseProduct(element.productId, element.variationId);
        });
        yield WishlistLoadedState(list);
      } else if (event is RemoveWishListItemEvent) {
        yield WishlistLoadingState();
        print(list);
        print(event.productModel.variations.isEmpty);
        if (event.productModel.variations.isEmpty) {
          wishListMaper.remove(event.productModel.id.toString() + event.productModel.defaultVariationId.toString());
          list.removeWhere(
            (product) =>
                product.id == event.productModel.id &&
                product.variations[0].id == event.productModel.defaultVariationId,
          );
          await _wishlistDataRepository.removeWishlistItem(
            event.productModel.id,
            event.productModel.defaultVariationId,
          );
        } else {
          wishListMaper.remove(event.productModel.id.toString() + event.productModel.variations[0].id.toString());
          list.removeAt(
            list.indexOf(
              event.productModel,
            ),
          );
          await _wishlistDataRepository.removeWishlistItem(
            event.productModel.id,
            event.productModel.variations[0].id,
          );
        }

        yield WishlistLoadedState(list);
      } else if (event is AddProductToWishListEvent) {
        yield WishlistLoadingState();
        wishListMaper[event.productModel.id.toString() + event.varId.toString()] = null;
        await _wishlistDataRepository.addWishlistItem(
          event.productModel.id,
          event.varId,
        );
        if (event.productModel.variations.isEmpty) {
          event.productModel.variations = [
            ProductVariation(
              id: event.productModel.defaultVariationId,
              attributes: event.productModel.defaultAttributes,
            )
          ];
        }
        list.add(event.productModel);
        yield WishlistLoadedState(list);
      }
    } catch (e) {
      print(e.toString());
      yield WishlistErrorState(e.toString());
    }
  }

  Future<void> parseProduct(int productId, int variationId) async {
    var productRawData = await _productsRepository.getProductDetails(productId: productId.toString());
    ProductModel productModel = ProductModel.fromJson(productRawData);
    var varRawData = await _productsRepository.getProductVariationsById(productId, variationId);
    ProductVariation variation = ProductVariation.fromJson(varRawData);
    productModel.variations = [variation];
    list.add(productModel);
  }
}
