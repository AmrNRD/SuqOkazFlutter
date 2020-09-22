import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:intl/intl.dart';
import 'package:suqokaz/bloc/orders/orders_bloc.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/data/repositories/orders_repository.dart';
import 'package:suqokaz/ui/common/helper_widgets.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/common/product.box.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  OrderDetailsPage({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage>
    with TickerProviderStateMixin {
  String appBarTitle = "My Orders";
  DateTime now = DateTime.now();
  int totalProducts = 0;
  OrdersBloc ordersBloc;

  @override
  void initState() {
    widget.order.lineItems.forEach((element) {
      totalProducts += element.quantity;
    });
    ordersBloc=OrdersBloc(new OrdersDataRepository());
    ordersBloc.add(GetOrderDetails(widget.order));
    widget.order.lineItems[0].quantity.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("my_orders")), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsetsDirectional.only(start: AppDimens.marginDefault16, end: AppDimens.marginDefault16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: AppDimens.marginDefault20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(width: 13, height: 13, child: Icon(Icons.access_time, color: AppColors.primaryColors[50], size: 13)),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: AppDimens.marginDefault8),
                      child: Text(widget.order.status, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryColors[50])),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: AppDimens.marginDefault8),
                      child: Text(
                        DateFormat("MMM, d, y  kk:mm a", AppLocalizations.of(context).currentLanguage,).format(widget.order.createdAt),
                        style: AppTheme.caption.copyWith(fontWeight: FontWeight.w400, color: AppColors.customGreyLevels[100].withAlpha(190)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimens.marginDefault12,
                ),
                Divider(),
                SizedBox(
                  height: AppDimens.marginDefault12,
                ),
                Text(
                  AppLocalizations.of(context).translate(
                    "order_number",
                    replacement: widget.order.id.toString(),
                  ),
                  style: AppTheme.headline2.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColors[200]),
                ),
                SizedBox(
                  height: AppDimens.marginDefault12,
                ),
                Divider(),
                SizedBox(
                  height: AppDimens.marginDefault12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context).translate(
                              "product_value",
                            ),
                            style: AppTheme.smallText.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.customGreyLevels[100]
                                    .withAlpha(190)),
                          ),
                          Text(
                            AppLocalizations.of(context).translate(
                              "currency",
                              replacement: widget.order.total.toString(),
                            ),
                            style: AppTheme.headline2.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColors[200],
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate(
                                "quantity_alone",
                              ),
                              style: AppTheme.smallText.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.customGreyLevels[100]
                                    .withAlpha(190),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context).translate(
                                "product_quantity",
                                replacement: totalProducts.toString(),
                              ),
                              style: AppTheme.headline2.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColors[200],
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: AppDimens.marginDefault12,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: AppDimens.marginDefault16),
                  child: Text(
                    AppLocalizations.of(context).translate("order_product"),
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
               BlocProvider<OrdersBloc>(
                 create: (context)=>ordersBloc,
                 child:BlocBuilder(
                   cubit: ordersBloc,
                   builder: (context,state){
                     if(state is OrdersLoadingState){
                       return Center(child: LoadingWidget());
                     }else if(state is OrderLoadedState){
                     return  (state.products != null && state.products.length > 0)
                           ? IncrementallyLoadingListView(
                         loadMore: () async {},
                         padding: const EdgeInsetsDirectional.only(top: AppDimens.marginDefault16, bottom: AppDimens.marginDefault16),
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         hasMore: () => false,
                         itemCount: () => state.products.length,
                         itemBuilder: (parentContext, index) {
                           return Column(
                             children: <Widget>[
                               ProductBoxComponent(product: state.products[index]),
                               (index != (state.products.length - 1))
                                   ? Divider()
                                   : Container()
                             ],
                           );
                         },
                       ) : HelperWidgets.getNoEntriesWidget(context, false);
                     }
                     return Container();
                   },
                 ),
               ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ReviewModel {
  String title;
  ReviewModel(this.title);
}
