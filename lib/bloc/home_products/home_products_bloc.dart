import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/remote/base/api_caller.dart';

part 'home_products_event.dart';
part 'home_products_state.dart';

class HomeProductsBloc extends Bloc<HomeProductsEvent, HomeProductsState> {
  HomeProductsBloc(this.productsRepository) : super(HomeProductsLoadingState());

  /// Variables

  // Core
  bool isLoading = false;

  // Pagination
  int currentPage = 1;
  bool lastPageReached = false;

  // Repos
  final ProductsRepository productsRepository;


  @override
  Stream<HomeProductsState> mapEventToState(
      HomeProductsEvent event,
  ) async* {
    try {
      /// Get products event
      if (event is GetHomeProductsEvent) {
        // Reset bloc in case reload data
        if (!event.isLoadMoreMode) resetBloc();

        // Load data
        if (!lastPageReached && !isLoading) {
          // Mark as loading
          isLoading = true;

          // Set loading state
          yield HomeProductsLoadingState(isLoadMoreMode: currentPage != 1);

          // Load data
          var productsList = await productsRepository.getApiProducts(
            lang: event.lang,
            pageIndex: currentPage,
            perPage: event.perPage,
          );

          // Process data

          if(productsList["data"] != null && productsList["data"] is List){

            productsList = productsList["data"];

            if (productsList is List) {
              // Init data holder
              List<ProductModel> dataList = [];

              // Loop on data
              for (var item in productsList) {
                if (item["status"] == "publish") {
                  var product = ProductModel.fromApiJson(item);
                  if(product.imageFeature != null){
                    dataList.add(product);
                  }
                }
              }

              // Go to next page
              currentPage++;

              // Check last page
              if (productsList.isEmpty) lastPageReached = true;

              // Yield result
              yield HomeProductsLoadedState(
                products: dataList,
                isLoadMoreMode: event.isLoadMoreMode,
                lastPageReached: lastPageReached,
              );
            } else {
              // Yield Error
              yield HomeProductsErrorState(message: "Error occurred",isLoadMoreMode: currentPage != 1); // TODO: translate
            }
          }else{
            yield HomeProductsErrorState(message: "Error occurred",isLoadMoreMode: currentPage != 1); // TODO: translate
          }
        }
      }
    } catch (exception) {
      // Yield error with message, exception can't be casted to string in some cases
      try {
        yield HomeProductsErrorState(message: exception.toString(), isLoadMoreMode: currentPage != 1);
      } catch (_) {
        yield HomeProductsErrorState(message: "Error occurred", isLoadMoreMode: currentPage != 1); // TODO: translate
      }
    } finally {
      // Mark is finished loading
      isLoading = false;
    }
  }

  void resetBloc() {
    currentPage = 1;
    lastPageReached = false;
  }
}
