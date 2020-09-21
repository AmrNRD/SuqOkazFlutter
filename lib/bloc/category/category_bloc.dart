import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/data/repositories/categories.repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/utils/categories.util.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this._categoriesDataRepository) : super(CategoryProductInitial());

  final CategoriesRepository _categoriesDataRepository;

  List<dynamic> nestedCategories = [];
  List<CategoryModel> categories = [];

  int selectedParentCategoryIndex = 0;
  int currentParentCategoryId = 0;
  int selectSubCategoryIndex = 0;
  int currentRootSubCategoryId = 0;
  bool loadAllCategories = true;
  bool reorderByMenuOrder = true;

  int dataCurrentPage = 1; // Latest loaded page
  bool dataHasNextPage = true;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    try {
      if (event is GetCategoriesEvent) {
        yield CategoryLoadingState();
        if (nestedCategories.isEmpty) {
          List<CategoryData> localCategories = await _categoriesDataRepository.getAllCategories();
          nestedCategories = CategoriesUtil.nestCategories(localCategories);
          if (nestedCategories.isEmpty) {
            categories = [];
            await loadCategories();
            _categoriesDataRepository.saveLocalCategories(categories);
            nestedCategories = CategoriesUtil.nestCategories(categories);
          }
        }
        yield CategoryLoadedState(
          nestedCategories: nestedCategories,
          currentParentCatId: currentParentCategoryId,
          subSelectedCategoryIndex: selectSubCategoryIndex,
          selectedCategoryIndex: selectedParentCategoryIndex,
          currentRootSubCategoryId: currentRootSubCategoryId,
        );
      } else if (event is ChangeParentCategoryEvent) {
        selectedParentCategoryIndex = event.index;
        selectSubCategoryIndex = 0;
        yield CategoryLoadedState(
          nestedCategories: nestedCategories,
          currentParentCatId: currentParentCategoryId,
          subSelectedCategoryIndex: selectSubCategoryIndex,
          selectedCategoryIndex: selectedParentCategoryIndex,
          currentRootSubCategoryId: currentRootSubCategoryId,
        );
        yield CategoryForceReloadState();
      } else if (event is ChangeSubCategoryEvent) {
        selectSubCategoryIndex = event.index;
        yield CategoryLoadedState(
          nestedCategories: nestedCategories,
          currentParentCatId: currentParentCategoryId,
          subSelectedCategoryIndex: selectSubCategoryIndex,
          selectedCategoryIndex: selectedParentCategoryIndex,
          currentRootSubCategoryId: currentRootSubCategoryId,
        );
      } else if (event is ResetCategoryEvent) {
        yield CategoryLoadedState(
          nestedCategories: nestedCategories,
          currentParentCatId: currentParentCategoryId,
          subSelectedCategoryIndex: selectSubCategoryIndex,
          selectedCategoryIndex: selectedParentCategoryIndex,
          currentRootSubCategoryId: currentRootSubCategoryId,
        );
      }
    } catch (e) {
      yield CategoryErrorState(e.toString());
    }
  }

  Future<List<CategoryModel>> loadCategories() async {
    if ((dataCurrentPage > 1 && !dataHasNextPage)) {
      return [];
    }
    // Make request
    var response = await _categoriesDataRepository.loadCategories(dataCurrentPage, false);

    // If the call to the server was successful
    if (response != null && (response is Map || response is List)) {
      // Check if no more data
      if (response.length == 0) {
        dataHasNextPage = false;
      } else {
        // Parse data
        for (var item in response) {
          // Map category
          var category = CategoryModel.fromJson(item);

          // Set data
          if (item['slug'] != "uncategorized") {
            categories.add(category);
          }
        }

        // Increment current page
        dataCurrentPage++;

        // Load categories next page
        if (loadAllCategories) {
          if (response.length == 100) {
            await loadCategories();
          } else {
            return orderByMenuOrder(categories);
          }
        }
      }
    }
    return categories;
  }
}

List<CategoryModel> orderByMenuOrder(List<CategoryModel> list) {
  list.sort((CategoryModel e1, CategoryModel e2) {
    return e1.menuOrder > e2.menuOrder ? 1 : 0;
  });
  return list;
}
