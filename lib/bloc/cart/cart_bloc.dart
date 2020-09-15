import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/repositories/cart.repository.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartDataRepository, this._productsDataRepository) : super(CartInitial());

  final CartDataRepository _cartDataRepository;
  final ProductsDataRepository _productsDataRepository;

  int totalCartQuantity = 0;
  bool firstTimeCall = true;

  CartData cartData;
  Map<int, int> productIdToQuantity = {};
  Map<int, CartItem> productIdToCartItem = {};
  Map<int, ProductItem> productIdToProductItem = {};

  double totalPrice = 0;

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is IncreaseItemInCartEvent) {
      await updateCartItem(true, event.productId, event.variationId);
      totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);
      yield CartLoadedState(
        productIdToProductItem.values.toList(),
        totalCartQuantity,
        productIdToCartItem,
      );
    } else if (event is RemovedItemInCartEvent) {
      totalPrice -= double.parse(productIdToProductItem[event.productId].price) * productIdToQuantity[event.productId];
      await _cartDataRepository.deleteCartItem(event.productId);
      if (productIdToCartItem.values.toList().isEmpty) {
        await _cartDataRepository.deleteCart(productIdToCartItem[event.productId].cartId);
      }
      productIdToQuantity.remove(event.productId);
      productIdToCartItem.remove(event.productId);
      productIdToProductItem.remove(event.productId);
      totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);
      yield CartLoadedState(productIdToProductItem.values.toList(), totalCartQuantity, productIdToCartItem);
    } else if (event is DecreaseItemInCartEvent) {
      //Update all the trackers with the new value
      await updateCartItem(false, event.productId, event.variationId);
      totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);
      yield CartLoadedState(productIdToProductItem.values.toList(), totalCartQuantity, productIdToCartItem);
    } else if (event is AddProductToCartEvent) {
      if (firstTimeCall) {
        await loadCart();
      }
      //If the user has not created a cart before, create one

      cartData = await _cartDataRepository.getCart();
      if (cartData == null) {
        await _cartDataRepository.createCart(
          // ignore: missing_required_param
          CartData(),
        );
        cartData = await _cartDataRepository.getCart();
      }
      //Check if the product exisit in the cart before adding
      CartItem cartItem = await _cartDataRepository.getCartItemById(
        event._productModel.id,
        variationId: event.variationId ?? event._productModel.defaultVariationId,
      );
      //If there is no cart items for this product, create one
      if (cartItem == null) {
        await _cartDataRepository.createCartItem(
          CartItem(
            id: event._productModel.id,
            quantity: event.quantity,
            cartId: cartData.id,
            variationId: event.variationId ?? event._productModel.defaultVariationId,
          ),
        );
        cartItem = await _cartDataRepository.getCartItemById(event._productModel.id, variationId: event.variationId);
      }
      //Else get the saved cart item and update it's quantity
      else {
        cartItem = CartItem(
          cartId: cartItem.cartId,
          id: cartItem.id,
          quantity: event.quantity,
          variationId: event.variationId ?? event._productModel.defaultVariationId,
        );
        await _cartDataRepository.updateCartItem(
          cartItem,
        );
      }

      productIdToCartItem[event._productModel.id] = cartItem;
      productIdToQuantity[event._productModel.id] = cartItem.quantity;

      ProductItem productItem = ProductItem(
        productId: event._productModel.id,
        quantity: productIdToQuantity[event._productModel.id],
        featuredImage: event._productModel.imageFeature,
        name: event._productModel.name,
        price: event._productModel.price,
        total:
            (double.parse(event._productModel.price) * productIdToQuantity[event._productModel.id]).toStringAsFixed(2),
      );

      productIdToProductItem[event._productModel.id] = productItem;
      productIdToProductItem[event._productModel.id].total =
          (double.parse(productIdToProductItem[event._productModel.id].price) *
                  productIdToQuantity[event._productModel.id])
              .toStringAsFixed(2);
      totalPrice += double.parse(productItem.total);
      totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);

      yield CartLoadedState(
        productIdToProductItem.values.toList(),
        totalCartQuantity,
        productIdToCartItem,
      );
    } else if (event is GetCartEvent) {
      yield CartLoadingState();
      cartData = await _cartDataRepository.getCart();
      totalPrice = 0;
      await loadCart();
      yield CartLoadedState(productIdToProductItem.values.toList(), totalCartQuantity, productIdToCartItem);
    } else if (event is CheckoutCartEvent) {}
  }

  loadCart() async {
    //Load cart items for the first time the app loads
    cartData = await _cartDataRepository.getCart();
    //If cartData is not null, then get the cart Items count
    if (cartData != null) {
      List<CartItem> cartItems = await _cartDataRepository.getCartItems(
        cartData.id,
      );
      print(cartItems);
      print(cartItems.length);
      if (cartItems.isNotEmpty) {
        totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);
        List<int> includeList = [];
        cartItems.forEach((element) {
          productIdToQuantity[element.id] = element.quantity;
          productIdToCartItem[element.id] = element;
          includeList.add(element.id);
        });
        var rawData = await _productsDataRepository.getProductsWithInclude(includeList);
        rawData.forEach((element) {
          ProductModel productModel;
          productModel = ProductModel.fromJson(element);
          productIdToProductItem[productModel.id] = ProductItem(
            productId: productModel.id,
            quantity: productIdToQuantity[productModel.id],
            name: productModel.name,
            price: productModel.price,
            total: (double.parse(productModel.price) * productIdToQuantity[productModel.id]).toStringAsFixed(2),
          );
          totalPrice += (double.parse(productModel.price) * productIdToQuantity[productModel.id]);
        });
      } else {
        await _cartDataRepository.deleteCart(cartData.id);
      }
    }
    firstTimeCall = false;
  }

  updateCartItem(bool isIncrement, int productId, int variationId) async {
    //Update all the trackers with the new value
    isIncrement ? productIdToQuantity[productId]++ : productIdToQuantity[productId]--;
    CartItem cartItem = CartItem(
      cartId: productIdToCartItem[productId].cartId,
      id: productIdToCartItem[productId].id,
      quantity: productIdToQuantity[productId],
      variationId: variationId ?? 0,
    );
    await _cartDataRepository.updateCartItem(
      cartItem,
    );
    totalCartQuantity++;
    //Update the effected product in the list

    productIdToProductItem[productId].quantity = productIdToQuantity[productId];
    productIdToProductItem[productId].total =
        (double.parse(productIdToProductItem[productId].price) * productIdToQuantity[productId]).toStringAsFixed(2);
    totalPrice = isIncrement
        ? totalPrice + (double.parse(productIdToProductItem[productId].price))
        : totalPrice - (double.parse(productIdToProductItem[productId].price));
  }
}
