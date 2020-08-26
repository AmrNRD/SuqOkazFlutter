import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:suqokaz/data/models/order_model.dart';

import '../../style/app.dimens.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  // Data holder
  List<OrderModel> ordersList = List();

  @override
  void initState() {
    super.initState();

    // BlocProvider.of<OrdersBloc>(context).resetBloc();
    // BlocProvider.of<OrdersBloc>(context).add(
    //   GetOrdersEvent(
    //     isLoadMoreMode: false,
    //     userID: 3,
    //   ), //TODO change to real user id
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBarTitle: AppLocalizations.of(context).translate("my_orders"),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (BuildContext context, OrdersState state) {
            if (state is OrdersInitial) {
              /// Initial state
              return HelperWidgets.getLoadingWidget(context, false);
            } else if (state is OrdersLoadedState) {
              /// Set orders list
              if (!state.isLoadMoreMode)
                ordersList = state.orders;
              else
                ordersList.addAll(state.orders);

              if (ordersList.isEmpty || ordersList == null) {
                return Center(
                  child: GenericState(
                    imagePath: Constants.imagePath["empty_box"],
                    titleKey: "no_orders_title",
                    bodyKey: "no_orders_body",
                    onPress: () {
                      BlocProvider.of<OrdersBloc>(context).resetBloc();
                      BlocProvider.of<OrdersBloc>(context).add(
                        GetOrdersEvent(
                          isLoadMoreMode: false,
                          userID: 3,
                        ), //TODO change to real user id
                      );
                    },
                    buttonKey: "refresh",
                  ),
                );
              }

              return listViewBodyBuilder(
                  showLoadMoreMode: state.isLoadMoreMode,
                  lastPageReached: state.lastPageReached);
            } else if (state is OrdersErrorState) {
              /// Error state
              return Center(
                child:
                    Text("Error occurred : ${state.message}"), //TODO translate
              );
            } else if (state is OrdersLoadingState) {
              /// Loading state
              if (!state.isLoadMoreMode) {
                return LoadingWidget();
              } else {
                return listViewBodyBuilder(
                    showLoadMoreMode: true, lastPageReached: false);
              }
            } else if (state is OrdersErrorState) {
              return Center(
                child: GenericState(
                  imagePath: Constants.imagePath["error"],
                  titleKey: "error_title",
                  bodyKey: "error_body",
                  buttonKey: "refresh",
                  onPress: () {
                    BlocProvider.of<OrdersBloc>(context).resetBloc();
                    BlocProvider.of<OrdersBloc>(context).add(
                      GetOrdersEvent(
                        isLoadMoreMode: false,
                        userID: 3,
                      ), //TODO change to real user id
                    );
                  },
                ),
              );
            }
            return Center(
              child: Text(
                  "Error occurred in ${state.runtimeType}"), //TODO translate
            );
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget listViewBodyBuilder({bool showLoadMoreMode, bool lastPageReached}) {
    return ordersList.length > 0
        ? IncrementallyLoadingListView(
            loadMore: () async {
              // BlocProvider.of<OrdersBloc>(context).add(
              //   GetOrdersEvent(
              //       isLoadMoreMode: true,
              //       userID: 1),
              // );
            },
            padding: const EdgeInsetsDirectional.only(
                start: AppDimens.marginDefault16,
                end: AppDimens.marginDefault16,
                top: AppDimens.marginDefault16,
                bottom: AppDimens.marginDefault16),
            hasMore: () => !lastPageReached,
            itemCount: () =>
                lastPageReached ? ordersList.length : ordersList.length + 1,
            itemBuilder: (parentContext, index) {
              if (index < ordersList.length) {
                // Normal box product item
                return Column(
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      onTap: () {
                        Navigator.pushNamed(
                            context, Constants.orderDetailsScreen,
                            arguments: ordersList[index]);
                      },
                      child: OrderBoxComponent(
                        order: ordersList[index],
                      ),
                    ),
                    (index != (ordersList.length - 1)) ? Divider() : Container()
                  ],
                );
              } else {
                // Loading view
                return showLoadMoreMode
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container();
              }
            },
          )
        : HelperWidgets.getNoEntriesWidget(context, false);
  }
}
