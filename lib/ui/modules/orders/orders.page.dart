import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:intl/intl.dart';
import 'package:suqokaz/bloc/orders/orders_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/helper_widgets.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

import '../../../main.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {

  List<OrderModel>ordersList=[];
  OrdersBloc ordersBloc;
@override
  void initState() {
    ordersBloc=BlocProvider.of<OrdersBloc>(context);
    ordersBloc.add(GetOrdersEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          canPop: true,
          text: AppLocalizations.of(context)
              .translate("orders", defaultText: "Orders")),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          cubit: ordersBloc,
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
                        userID: Root.user.id,
                      ),
                    );
                  },
                ),
              );
            }
            return Center(
              child: Text("Error occurred in ${state.runtimeType}"), //TODO translate
            );
          },
        )
    );
    //       body: SafeArea(
    //         child: Column(
    //           children: <Widget>[
    //             OrderCard(
    //                 order: OrderModel(
    //                     id: 1,
    //                     number: "4444444444",
    //                     total: 15000.22,
    //                     createdAt: DateTime.now(),
    //                     status: "completed"),
    //                 onTap: () {}),
    //             Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: AppDimens.marginEdgeCase24),
    //                 child: Divider()),
    //             OrderCard(
    //               order: OrderModel(
    //                   id: 2,
    //                   number: "555555555555555555",
    //                   total: 133444.22,
    //                   createdAt: DateTime.now(),
    //                   status: "pending"),
    //               onTap: () {},
    //             ),
    //             Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: AppDimens.marginEdgeCase24),
    //                 child: Divider()),
    //             OrderCard(
    //               order: OrderModel(
    //                   id: 2,
    //                   number: "3333",
    //                   total: 133444.22,
    //                   createdAt: DateTime.now(),
    //                   status: "on-hold"),
    //               onTap: () {},
    //             ),
    //             Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: AppDimens.marginEdgeCase24),
    //                 child: Divider()),
    //             OrderCard(
    //               order: OrderModel(
    //                   id: 2,
    //                   number: "3333",
    //                   total: 133444.22,
    //                   createdAt: DateTime.now(),
    //                   status: "failed"),
    //               onTap: () {},
    //             ),
    //           ],
    //         ),
    //       ));
    // }
  }

  Widget listViewBodyBuilder({bool showLoadMoreMode, bool lastPageReached}) {
    return ordersList.length > 0
        ? IncrementallyLoadingListView(
      loadMore: () async {
        BlocProvider.of<OrdersBloc>(context).add(
          GetOrdersEvent(
              isLoadMoreMode: true,
              userID: 1), //TODO change to real user id
        );
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
                  // Navigator.pushNamed(
                  //     context, Constants.orderDetailsScreen,
                  //     arguments: ordersList[index]);
                },
                child: OrderCard(
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

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final Function onTap;

  const OrderCard({Key key, @required this.order, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(AppDimens.marginEdgeCase24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("#" + order.number,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 2),
                  Text(
                      AppLocalizations.of(context)
                          .translate("currency", replacement: "${order.total}"),
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(height: AppDimens.marginDefault6),
                  Text(
                      AppLocalizations.of(context).translate("total_items",
                              replacement: "${order.lineItems.length}") +
                          "  " +
                          AppLocalizations.of(context).translate("date",
                              replacement: "${DateFormat(
                                "d/M/y  kk:mm a",
                                AppLocalizations.of(context).currentLanguage,
                              ).format(order.createdAt)}"),
                      style: Theme.of(context).textTheme.subtitle2),
                  SizedBox(height: AppDimens.marginDefault4),
                  Text(
                      AppLocalizations.of(context)
                          .translate("seller", replacement: "Example"),
                      style: Theme.of(context).textTheme.subtitle2),
                  SizedBox(height: AppDimens.marginDefault16),
                  OrderStatusCard(status: order.status),
                ]),
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEFEFEF).withOpacity(0.05),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                    border: Border.all(
                        color: AppColors.customGreyLevels[200], width: 2),
                  ),
                  child: Image.asset(
                    "assets/images/dummy_phone.png",
                    fit: BoxFit.contain,
                    height: screenAwareSize(78, context),
                    width: screenAwareSize(78, context),
                  ),
                ),
                SizedBox(height: AppDimens.marginDefault20),
                InkWell(
                  onTap: () {},
                  child: Text(
                    AppLocalizations.of(context).translate("rate_this_product"),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final String status;

  const OrderStatusCard({Key key, @required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case "pending":
        statusColor = AppColors.primaryColors[50];
        break;
      case "processing":
        statusColor = AppColors.primaryColors[50];
        break;
      case "on-hold":
        statusColor = AppColors.primaryColors[50];
        break;
      case "completed":
        statusColor = Colors.green;
        break;
      case "cancelled":
        statusColor = Colors.red;
        break;
      case "refunded":
        statusColor = Colors.green;
        break;
      case "failed":
        statusColor = Colors.red;
        break;
      case "trash":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.red;
    }
    return Container(
      width: screenAwareWidth(103, context),
      height: screenAwareSize(26, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.customGreyLevels[300],
        boxShadow: [BoxShadow(color: Color(0xFFF5F5F5), blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text(status,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: statusColor)),
        ],
      ),
    );
  }
}
