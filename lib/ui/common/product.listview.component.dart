import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/cart/cart_bloc.dart';
import 'package:suqokaz/bloc/product/product_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/data/repositories/products_repository.dart';
import 'package:suqokaz/data/sources/local/local.database.dart';
import 'package:suqokaz/ui/common/delayed_animation.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.listview.builder.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class ProductListViewComponent extends StatefulWidget {
  final ScrollController scrollController;
  final String orderBy;
  final String order;
  final int categoryId;

  const ProductListViewComponent({
    Key key,
    this.scrollController,
    this.categoryId,
    this.orderBy,
    this.order,
  }) : super(key: key);

  @override
  _ProductListViewComponentState createState() => _ProductListViewComponentState();
}

class _ProductListViewComponentState extends State<ProductListViewComponent>
    with AutomaticKeepAliveClientMixin<ProductListViewComponent>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive {
    return true;
  }

  ScrollController _scrollController = ScrollController();
  AnimationController animationController;

  ProductBloc productBloc;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    productBloc = ProductBloc(
      ProductsRepository(),
    );

    productBloc.add(
      GetProductsEvent(
        categoryID: widget.categoryId,
        isLoadMoreMode: false,
        order: widget.order,
        orderBy: widget.orderBy,
      ),
    );

    if (widget.categoryId != null) {
      _scrollController.addListener(
        () {
          if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
            productBloc.add(
              GetProductsEvent(
                  categoryID: widget.categoryId,
                  isLoadMoreMode: true,
                  orderBy: (widget.orderBy != null) ? widget.orderBy : null,
                  order: (widget.order != null) ? widget.order : null),
            );
            setState(() {
              showLoading = true;
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }
        },
      );
    }
  }

  bool lastPageReached = false;
  bool showLoading = false;
  List<ProductModel> products = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.all(16),
      child: DelayedAnimation(
        animationController: animationController,
        child: BlocBuilder<ProductBloc, ProductState>(
          buildWhen: (prev, current) {
            print(current.runtimeType);
            if (current is ProductsLoadingState && prev is ProductsLoadedState) {
              return false;
            } else if (current is ProductsLoadedState) {
              if (current.isLoadMoreMode) {
                if (current.lastPageReached) {
                  setState(() {
                    lastPageReached = true;
                  });
                }
                setState(() {
                  products.addAll(current.products);
                  showLoading = false;
                });
                return false;
              }
              return true;
            }
            return true;
          },
          cubit: productBloc,
          builder: (context, state) {
            if (state is ProductsLoadedState) {
              products = [];
              products = state.products;
              return ProductListViewBuilder(
                scrollController: _scrollController,
                products: products,
                showLoading: showLoading,
                lastPageReached: lastPageReached,
              );
            } else if (state is ProductsLoadingState) {
              return LoadingWidget();
            } else if (state is ProductsErrorState) {
              return Center(
                child: GenericState(
                  imagePath: Constants.imagePath["error"],
                  titleKey: AppLocalizations.of(context).translate("error_title"),
                  bodyKey: state.message,
                  buttonKey: AppLocalizations.of(context).translate("refresh"),
                  onPress: () {
                    productBloc.add(
                      GetProductsEvent(
                        categoryID: widget.categoryId,
                        isLoadMoreMode: false,
                      ),
                    );
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
