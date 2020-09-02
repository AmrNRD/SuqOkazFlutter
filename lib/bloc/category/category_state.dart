part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryProductInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadingState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryErrorState extends CategoryState {
  final String message;

  CategoryErrorState(this.message);
  @override
  List<Object> get props => [this.message];
}

class CategoryForceReloadState extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoadedState extends CategoryState {
  final List<dynamic> nestedCategories;
  final int selectedCategoryIndex;
  final int currentParentCatId;
  final int subSelectedCategoryIndex;
  final int currentRootSubCategoryId;

  CategoryLoadedState({
    @required this.nestedCategories,
    @required this.selectedCategoryIndex,
    @required this.currentParentCatId,
    @required this.subSelectedCategoryIndex,
    @required this.currentRootSubCategoryId,
  });
  @override
  List<Object> get props => [
        this.nestedCategories,
        this.selectedCategoryIndex,
        this.currentParentCatId,
        this.subSelectedCategoryIndex,
      ];
}
