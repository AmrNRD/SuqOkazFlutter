part of 'home_products_bloc.dart';

abstract class HomeProductsEvent extends Equatable {
  const HomeProductsEvent();

  @override
  List<Object> get props => [];
}

class GetHomeProductsEvent extends HomeProductsEvent {
  final int perPage;
  final bool isLoadMoreMode;
  final String lang;

  GetHomeProductsEvent({
    this.isLoadMoreMode = false,
    this.perPage = 60,
    this.lang = "en",
  });

  @override
  List<Object> get props => [];
}
