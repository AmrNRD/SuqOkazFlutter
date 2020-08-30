import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/models/shipping_method_model.dart';
import 'package:suqokaz/data/repositories/cart.repository.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartDataRepository, this._productsDataRepository)
      : super(CartInitial());

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
    try {
      if (event is IncreaseItemInCartEvent) {
        await updateCartItem(true, event.productId);
        totalCartQuantity =
            await _cartDataRepository.getCartItemsCount(cartData.id);
        yield CartButtonUpdateState(totalCartQuantity, productIdToCartItem);
        yield CartLoadedState(productIdToProductItem.values.toList());
      } else if (event is RemovedItemInCartEvent) {
        totalPrice -=
            double.parse(productIdToProductItem[event.productId].price) *
                productIdToQuantity[event.productId];
        await _cartDataRepository.deleteCartItem(event.productId);
        if (productIdToCartItem.values.toList().isEmpty) {
          await _cartDataRepository
              .deleteCart(productIdToCartItem[event.productId].cartId);
        }
        productIdToQuantity.remove(event.productId);
        productIdToCartItem.remove(event.productId);
        productIdToProductItem.remove(event.productId);
        totalCartQuantity =
            await _cartDataRepository.getCartItemsCount(cartData.id);
        yield CartButtonUpdateState(totalCartQuantity, productIdToCartItem);
        yield CartLoadedState(productIdToProductItem.values.toList());
      } else if (event is DecreaseItemInCartEvent) {
        //Update all the trackers with the new value
        await updateCartItem(false, event.productId);
        totalCartQuantity =
            await _cartDataRepository.getCartItemsCount(cartData.id);
        yield CartButtonUpdateState(totalCartQuantity, productIdToCartItem);
        yield CartLoadedState(productIdToProductItem.values.toList());
      } else if (event is AddProductToCartEvent) {
        if (firstTimeCall) {
          await loadCart();
        }
        //If the user has not created a cart before, create one
        if (cartData == null) {
          await _cartDataRepository.createCart(
            // ignore: missing_required_param
            CartData(
              userEmail: "test@test.test", //Root.user.userEmail,
            ),
          );
          cartData = await _cartDataRepository.getCart(
            "test@test.test",
            //Root.user.userEmail,
          );
        }
        //Check if the product exisit in the cart before adding
        CartItem cartItem =
            await _cartDataRepository.getCartItemById(event._productModel.id);
        //If there is no cart items for this product, create one
        if (cartItem == null) {
          await _cartDataRepository.createCartItem(
            CartItem(
              id: event._productModel.id,
              quantity: event.quantity,
              cartId: cartData.id,
            ),
          );
          cartItem =
              await _cartDataRepository.getCartItemById(event._productModel.id);
        }
        //Else get the saved cart item and update it's quantity
        else {
          debugPrint("------------");
          debugPrint("Updating cart Item");
          debugPrint("------------");
          cartItem = CartItem(
            cartId: cartItem.cartId,
            id: cartItem.id,
            quantity: event.quantity,
          );
          await _cartDataRepository.updateCartItem(
            cartItem,
          );
        }

        productIdToCartItem[event._productModel.id] = cartItem;
        productIdToQuantity[cartItem.id] = cartItem.quantity;
        productIdToProductItem[event._productModel.id] = ProductItem(
          productId: event._productModel.id,
          quantity: productIdToQuantity[event._productModel.id],
          featuredImage: event._productModel.imageFeature,
          name: event._productModel.name,
          total: (double.parse(event._productModel.price) *
                  productIdToQuantity[event._productModel.id])
              .toStringAsFixed(2),
        );
        print(productIdToCartItem);
        print(productIdToCartItem.length);
        totalCartQuantity =
            await _cartDataRepository.getCartItemsCount(cartData.id);

        yield CartButtonUpdateState(totalCartQuantity, productIdToCartItem);
        yield CartItemAddedFromProductDetailsState();
      } else if (event is GetCartEvent) {
        yield CartLoadingState();
        if ("test@test.test" != null //Root.user.userEmail != null
            ) {
          totalPrice = 0;
          await loadCart();
          yield CartButtonUpdateState(totalCartQuantity, productIdToCartItem);
          yield CartLoadedState(productIdToProductItem.values.toList());
        } else {
          yield CartNeedLoginState();
        }
      } else if (event is CheckoutCartEvent) {}
    } catch (e) {
      yield CartErrorState(e.toString());
    }
  }

  loadCart() async {
    //Load cart items for the first time the app loads
    cartData = await _cartDataRepository.getCart(
      "test@test.test",
      //Root.user.userEmail,
    );
    //If cartData is not null, then get the cart Items count
    if (cartData != null) {
      List<CartItem> cartItems = await _cartDataRepository.getCartItems(
        cartData.id,
      );
      if (cartItems.isNotEmpty) {
        totalCartQuantity =
            await _cartDataRepository.getCartItemsCount(cartData.id);
        List<int> includeList = [];
        cartItems.forEach((element) {
          productIdToQuantity[element.id] = element.quantity;
          productIdToCartItem[element.id] = element;
          includeList.add(element.id);
        });
        var rawData =
            await _productsDataRepository.getProductsWithInclude(includeList);
        print(rawData.length);
        rawData.forEach((element) {
          ProductModel productModel;
          productModel = ProductModel.fromJson(element);
          productIdToProductItem[productModel.id] = ProductItem(
            productId: productModel.id,
            quantity: productIdToQuantity[productModel.id],
            name: productModel.name,
            price: productModel.price,
            total: (double.parse(productModel.price) *
                    productIdToQuantity[productModel.id])
                .toStringAsFixed(2),
          );
          totalPrice += (double.parse(productModel.price) *
              productIdToQuantity[productModel.id]);
        });
      } else {
        await _cartDataRepository.deleteCart(cartData.id);
      }
    }
    firstTimeCall = false;
  }

  updateCartItem(bool isIncrement, productId) async {
    //Update all the trackers with the new value
    isIncrement
        ? productIdToQuantity[productId]++
        : productIdToQuantity[productId]--;
    CartItem cartItem = CartItem(
      cartId: productIdToCartItem[productId].cartId,
      id: productIdToCartItem[productId].id,
      quantity: productIdToQuantity[productId],
    );
    await _cartDataRepository.updateCartItem(
      cartItem,
    );
    totalCartQuantity++;
    //Update the effected product in the list
    productIdToProductItem[productId].quantity = productIdToQuantity[productId];
    productIdToProductItem[productId].total =
        (double.parse(productIdToProductItem[productId].price) *
                productIdToQuantity[productId])
            .toStringAsFixed(2);
    totalPrice = isIncrement
        ? totalPrice + (double.parse(productIdToProductItem[productId].price))
        : totalPrice - (double.parse(productIdToProductItem[productId].price));
  }
}
