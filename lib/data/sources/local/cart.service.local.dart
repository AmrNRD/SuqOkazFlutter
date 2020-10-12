import 'package:flutter/material.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

class CartService {
  // Create ApiCaller instance
  final AppDataBase appDataBase;

  CartService(this.appDataBase);

  Future<CartData> getCart() {
    return appDataBase.getCart();
  }

  Future deleteCart(int id) {
    return appDataBase.deleteCart(id);
  }

  Future createCart(CartData cartData) {
    return appDataBase.insertCart(cartData);
  }

  Future updateCart(CartData cartData) {
    return appDataBase.updateCart(cartData);
  }

  Future<int> getCartItemsCount(int cartId) {
    return appDataBase.countAllCartItems(cartId);
  }

  Future<List<CartItem>> getCartItems(int cartId) {
    return appDataBase.getAllCartItems(cartId);
  }

  Future<CartItem> getCartItemById(int productId, {int variationId}) {
    return appDataBase.getCartItemById(productId, varId: variationId);
  }

  Future createCartItem(CartItem cartItem) {
    return appDataBase.insertCartItem(cartItem);
  }

  Future deleteCartItem(int itemId, {@required int varId}) async {
    return await appDataBase.deleteCartItem(itemId, varId: varId);
  }
  Future deleteCartItems(int itemId) async {
    return await appDataBase.deleteCartItems(itemId);
  }

  Future updateCartItem(CartItem cartItem) {
    return appDataBase.updateCartItem(cartItem);
  }

  Future<List<AddressModel>> getAddresses() {
    return appDataBase.getAllAddress();
  }
}
