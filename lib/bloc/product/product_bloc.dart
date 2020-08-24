import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/utils/constants.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this.productsRepository) : super(ProductsInitial());

  /// Variables

  // Core
  bool isLoading = false;

  // Pagination
  int currentPage = 1;
  bool lastPageReached = false;

  // Repos
  final ProductsRepository productsRepository;

  /// Mappers
  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    try {
      /// Get products event
      if (event is GetProductsEvent) {
        // Reset bloc in case reload data
        if (!event.isLoadMoreMode) resetBloc();

        // Load data
        if (!lastPageReached && !isLoading) {
          // Mark as loading
          isLoading = true;

          // Set loading state
          yield ProductsLoadingState(isLoadMoreMode: event.isLoadMoreMode);

          // Load data
          var productsList = await productsRepository.getCustomizableProducts(
            lang: event.lang,
            pageIndex: currentPage,
            perPage: event.perPage,
            categoryID: event.categoryID,
            tagID: event.tagID,
            minPrice: event.minPrice,
            maxPrice: event.maxPrice,
            order: event.order,
            orderBy: event.orderBy,
            attribute: event.attribute,
            attributeTerm: event.attributeTerm,
            featured: event.featured,
            onSale: event.onSale,
          );

          // Process data
          if (productsList is List) {
            // Init data holder
            List<ProductModel> dataList = [];

            // Loop on data
            for (var item in productsList) {
              if (!Constants.hideOutOfStock || item["in_stock"]) {
                var product = ProductModel.fromJson(item);
                dataList.add(product);
              }
            }

            // Go to next page
            currentPage++;

            // Check last page
            if (productsList.isEmpty) lastPageReached = true;

            // Yield result
            yield ProductsLoadedState(
                products: dataList,
                isLoadMoreMode: event.isLoadMoreMode,
                lastPageReached: lastPageReached);
          } else {
            // Yield Error
            yield ProductsErrorState(
                message: "Error occurred"); // TODO: translate
          }
        }
      }
    } catch (exception) {
      // Yield error with message, exception can't be casted to string in some cases
      try {
        yield ProductsErrorState(message: exception.toString());
      } catch (_) {
        yield ProductsErrorState(message: "Error occurred"); // TODO: translate
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
