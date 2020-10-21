part of 'category_bloc.dart';

abstract class CategoryEvent {
  const CategoryEvent();
}

class GetCategoriesEvent extends CategoryEvent {
  GetCategoriesEvent();
  @override
  List<Object> get props => [];
}

class ResetCategoryEvent extends CategoryEvent {
  ResetCategoryEvent();
  @override
  List<Object> get props => [];
}

class ReloadCategoryEvent extends CategoryEvent {
  ReloadCategoryEvent();
  @override
  List<Object> get props => [];
}


class ChangeParentCategoryEvent extends CategoryEvent {
  final bool compact;
  final int index;

  ChangeParentCategoryEvent(this.index, {this.compact = false});

  @override
  List<Object> get props => [this.index, this.compact];
}

class ChangeSubCategoryEvent extends CategoryEvent {
  final bool compact;
  final int index;

  ChangeSubCategoryEvent(this.index, {this.compact = false});

  @override
  List<Object> get props => [this.index, this.compact];
}
