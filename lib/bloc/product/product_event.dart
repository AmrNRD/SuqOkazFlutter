part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductsEvent extends ProductEvent {
  final bool isLoadMoreMode;
  final int perPage = 10;

  final int categoryID;
  final String tagID;
  final double minPrice;
  final double maxPrice;
  final bool featured;
  final bool onSale;
  final String attribute;
  final String attributeTerm;
  final String order; // asc and desc. Default is desc
  final String orderBy; // date, id, include, title and slug. Default is date
  final String search;
  final String lang;

  GetProductsEvent({
    this.minPrice,
    this.maxPrice,
    this.onSale = false,
    this.featured = false,
    this.attribute,
    this.attributeTerm,
    this.tagID,
    this.order,
    this.orderBy,
    this.search,
    this.categoryID,
    this.isLoadMoreMode = false,
    this.lang = "en",
  });

  @override
  List<Object> get props => [];
}

class GetProductVariationsEvent extends ProductEvent {
  final ProductModel productModel;

  GetProductVariationsEvent(this.productModel);
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
