//import 'package:suqokaz/data/sources/local/cart.service.local.dart';
//import 'package:suqokaz/data/sources/local/local.database.dart';
//import 'package:suqokaz/data/sources/remote/cart.service.dart';
//
//abstract class CartRepository {
//  Future<CartData> getCart(String userToken);
//  Future deleteCart(int id);
//  Future createCart(CartData cartData);
//  Future updateCart(CartData cartData);
//
//  Future<int> getCartItemsCount(int cartId);
//
//  Future<List<CartItem>> getCartItems(int cartId);
//  Future<CartItem> getCartItemById(int cartId);
//  Future createCartItem(CartItem cartItem);
//  Future deleteCartItem(int itemId);
//  Future updateCartItem(CartItem cartItem);
//
//  Future<List<AddressModel>> getAddresses();
//
//  Future<int> getShippingMethods();
//}
//
//class CartDataRepository extends CartRepository {
//  CartService _cartService;
//  CartRemoteService _cartRemoteService;
//
//  CartDataRepository(AppDataBase _appDataBase) {
//    _cartService = CartService(_appDataBase);
//  }
//
//  @override
//  Future createCart(CartData cartData) async {
//    return _cartService.createCart(cartData);
//  }
//
//  @override
//  Future createCartItem(CartItem cartData) async {
//    return _cartService.createCartItem(cartData);
//  }
//
//  @override
//  Future deleteCart(int id) async {
//    return _cartService.deleteCart(id);
//  }
//
//  @override
//  Future deleteCartItem(int itemId) async {
//    return _cartService.deleteCartItem(itemId);
//  }
//
//  @override
//  Future<List<AddressModel>> getAddresses() async {
//    return _cartService.getAddresses();
//  }
//
//  @override
//  Future<CartData> getCart(String userEmail) async {
//    return _cartService.getCart(userEmail);
//  }
//
//  @override
//  Future<CartItem> getCartItemById(int productId) {
//    return _cartService.getCartItemById(productId);
//  }
//
//  @override
//  Future<List<CartItem>> getCartItems(int cartId) {
//    return _cartService.getCartItems(cartId);
//  }
//
//  @override
//  Future updateCart(CartData cartData) {
//    return _cartService.updateCart(cartData);
//  }
//
//  @override
//  Future updateCartItem(CartItem cartData) {
//    return _cartService.updateCartItem(cartData);
//  }
//
//  @override
//  Future<int> getCartItemsCount(int cartId) {
//    return _cartService.getCartItemsCount(cartId);
//  }
//
//  @override
//  Future<int> getShippingMethods() {
//    return _cartRemoteService.getShippingMethods();
//  }
//}
