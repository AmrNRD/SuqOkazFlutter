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
  Map<String, int> productIdToQuantity = {};
  Map<String, CartItem> productIdToCartItem = {};
  Map<String, ProductItem> productIdToProductItem = {};

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
      totalPrice -=
          double.parse(productIdToProductItem[event.productId.toString() + event.variationId.toString()].price) *
              productIdToQuantity[event.productId.toString() + event.variationId.toString()];
      await _cartDataRepository.deleteCartItem(event.productId, event.variationId);
      if (productIdToCartItem.values.toList().isEmpty) {
        await _cartDataRepository
            .deleteCart(productIdToCartItem[event.productId.toString() + event.variationId.toString()].cartId);
      }
      productIdToQuantity.remove(event.productId.toString() + event.variationId.toString());
      productIdToCartItem.remove(event.productId.toString() + event.variationId.toString());
      productIdToProductItem.remove(event.productId.toString() + event.variationId.toString());
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

      productIdToCartItem[event._productModel.id.toString() + event.variationId.toString() ??
          event._productModel.defaultVariationId.toString()] = cartItem;
      productIdToQuantity[event._productModel.id.toString() + event.variationId.toString() ??
          event._productModel.defaultVariationId.toString()] = cartItem.quantity;

      ProductItem productItem = ProductItem(
        productId: event._productModel.id,
        quantity: productIdToQuantity[event._productModel.id.toString() + event.variationId.toString()],
        featuredImage: event._productModel.imageFeature,
        name: event._productModel.name,
        price: event._productModel.price,
        variationId: event.variationId,
        attribute: event.attributes,
        total: (double.parse(event._productModel.price) *
                productIdToQuantity[event._productModel.id.toString() + event.variationId.toString()])
            .toStringAsFixed(2),
      );

      productIdToProductItem[event._productModel.id.toString() + event.variationId.toString()] = productItem;
      productIdToProductItem[event._productModel.id.toString() + event.variationId.toString()].total = (double.parse(
                  productIdToProductItem[event._productModel.id.toString() + event.variationId.toString()].price) *
              productIdToQuantity[event._productModel.id.toString() + event.variationId.toString()])
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
      totalPrice = 0;
      await loadCart();
      yield CartLoadedState(productIdToProductItem.values.toList(), totalCartQuantity, productIdToCartItem);
    } else if (event is CheckoutCartEvent) {
      yield CartLoadingState();
      /*await _cartDataRepository.deleteCart(cartData.id);
      await _cartDataRepository.createCart(
        // ignore: missing_required_param
        CartData(),
      );*/
      cartData = await _cartDataRepository.getCart();
      /*totalCartQuantity = 0;
      productIdToQuantity = {};
      productIdToCartItem = {};
      productIdToProductItem = {};
      totalPrice = 0;*/
      yield CartLoadedState(productIdToProductItem.values.toList(), totalCartQuantity, productIdToCartItem);
    }
  }

  loadCart() async {
    //Load cart items for the first time the app loads
    cartData = await _cartDataRepository.getCart();
    print("=========================================================================================================");
    //If cartData is not null, then get the cart Items count
    if (cartData != null) {
      List<CartItem> cartItems = await _cartDataRepository.getCartItems(cartData.id);

        totalCartQuantity = await _cartDataRepository.getCartItemsCount(cartData.id);
        await Future.forEach(cartItems, (element) async {
          productIdToQuantity[element.id.toString() + element.variationId.toString()] = element.quantity;
          productIdToCartItem[element.id.toString() + element.variationId.toString()] = element;

          var productRawData = await _productsDataRepository.getProductDetails(productId: element.id.toString());
          ProductModel productModel = ProductModel.fromJson(productRawData);
          var varRawData = await _productsDataRepository.getProductVariationsById(element.id, element.variationId);

          ProductVariation variation = ProductVariation.fromJson(varRawData);

          productIdToProductItem[productModel.id.toString() + element.variationId.toString()] = ProductItem(
            productId: productModel.id,
            quantity: productIdToQuantity[productModel.id.toString() + element.variationId.toString()],
            name: productModel.name,
            featuredImage: productModel.imageFeature,
            variationId: variation.id,
            price: variation.price,
            attribute: variation.attributes,
            total: (double.parse(productModel.price) *
                    productIdToQuantity[productModel.id.toString() + element.variationId.toString()])
                .toStringAsFixed(2),
          );
          totalPrice += (double.parse(productModel.price) *
              productIdToQuantity[productModel.id.toString() + element.variationId.toString()]);
        });
    }
    firstTimeCall = false;
  }

  updateCartItem(bool isIncrement, int productId, int variationId) async {
    //Update all the trackers with the new value
    isIncrement
        ? productIdToQuantity[productId.toString() + variationId.toString()]++
        : productIdToQuantity[productId.toString() + variationId.toString()]--;
    CartItem cartItem = CartItem(
      id: productId,
      variationId: variationId ?? 0,
      cartId: productIdToCartItem[productId.toString() + variationId.toString()].cartId,
      quantity: productIdToQuantity[productId.toString() + variationId.toString()],
    );
    await _cartDataRepository.updateCartItem(
      cartItem,
    );
    totalCartQuantity++;
    //Update the effected product in the list
    productIdToProductItem[productId.toString() + variationId.toString()].quantity =
        productIdToQuantity[productId.toString() + variationId.toString()];
    productIdToProductItem[productId.toString() + variationId.toString()].total =
        (double.parse(productIdToProductItem[productId.toString() + variationId.toString()].price) *
                productIdToQuantity[productId.toString() + variationId.toString()])
            .toStringAsFixed(2);
    totalPrice = isIncrement
        ? totalPrice + (double.parse(productIdToProductItem[productId.toString() + variationId.toString()].price))
        : totalPrice - (double.parse(productIdToProductItem[productId.toString() + variationId.toString()].price));
  }
}
