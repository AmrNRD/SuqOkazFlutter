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
  @override
  Stream<WishlistState> mapEventToState(
    WishlistEvent event,
  ) async* {
    if (event is GetWishListEvent) {
      yield WishlistLoadingState();
      List<WishlistItem> wishListItem = await _wishlistDataRepository.getWishlist();
      wishListItem.forEach((element) async {
        await parseProduct(element.productId, element.variationId);
      });
      yield WishlistLoadedState(list);
    } else if (event is RemoveWishListItemEvent) {
      list.removeAt(
        list.indexOf(
          event.productModel,
        ),
      );
      await _wishlistDataRepository.removeWishlistItem(
        event.productModel.id,
        event.productModel.variations[0].id,
      );
      yield WishlistLoadedState(list);
    } else if (event is AddProductToWishListEvent) {
      await _wishlistDataRepository.addWishlistItem(
        event.productId,
        event.varId,
      );
      await parseProduct(event.productId, event.varId);
      yield WishlistLoadedState(list);
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
