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
      print(event.runtimeType);
      if (event is GetWishListEvent) {
        yield WishlistLoadingState();
        List<WishlistItem> wishListItem = await _wishlistDataRepository.getWishlist();

        wishListItem.forEach((element) async {
          print(element.toJson());
          wishListMaper[element.productId.toString() + element.variationId.toString()] = null;
          await parseProduct(element.productId, element.variationId);
        });
        yield WishlistLoadedState(list);
      } else if (event is RemoveWishListItemEvent) {
        yield WishlistLoadingState();
        wishListMaper.remove(event.productId.toString() + event.varId.toString());
        list.removeWhere(
          (product) => product.id == event.productId && product.selectedVaraition.id == event.varId,
        );
        await _wishlistDataRepository.removeWishlistItem(
          event.productId,
          event.varId,
        );
        yield WishlistLoadedState(list);
      } else if (event is AddProductToWishListEvent) {
        yield WishlistLoadingState(
          productId: event.productId,
          variationId: event.varId,
        );

        ProductModel productModel = event.productModel;

        if (productModel == null) {
          wishListMaper[event.productId.toString() + event.varId.toString()] = null;
          await _wishlistDataRepository.addWishlistItem(
            event.productId,
            event.varId,
          );
          await parseProduct(event.productId, event.varId);
        } else {
          wishListMaper[productModel.id.toString() + event.varId.toString()] = null;
          await _wishlistDataRepository.addWishlistItem(
            productModel.id,
            event.varId,
          );

          if (event.productModel.variations.isEmpty) {
            productModel.selectedVaraition = ProductVariation(
              id: event.productModel.defaultVariationId,
              attributes: event.productModel.defaultAttributes,
            );
          } else {
            productModel.selectedVaraition = productModel.variations
                .firstWhere((element) => element.id == productModel.defaultVariationId, orElse: null);
          }
          productModel.defaultVariationId = event.varId;
          list.add(productModel);
        }
        // list.forEach((element) {
        //   element.attributes.forEach((element) {
        //     print(element.toJson());
        //   });
        //});
        yield WishlistLoadedState(list);
      }
    } catch (e) {
      yield WishlistErrorState(e.toString());
    }
  }

  Future<void> parseProduct(int productId, int variationId) async {
    var productRawData = await _productsRepository.getProductDetails(productId: productId.toString());
    ProductModel parsedProduct = ProductModel.fromJson(productRawData);
    var varRawData = await _productsRepository.getProductVariationsById(productId, variationId);
    ProductVariation variation = ProductVariation.fromJson(varRawData);
    parsedProduct.selectedVaraition = variation;
    list.add(parsedProduct);
  }
}
