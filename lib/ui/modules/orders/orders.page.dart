import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            canPop: true,
            text: AppLocalizations.of(context)
                .translate("orders", defaultText: "Orders")),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              OrderCard(
                  order: OrderModel(
                      id: 1,
                      number: "4444444444",
                      total: 15000.22,
                      createdAt: DateTime.now(),
                      status: "completed"),
                  onTap: () {}),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.marginEdgeCase24),
                  child: Divider()),
              OrderCard(
                order: OrderModel(
                    id: 2,
                    number: "555555555555555555",
                    total: 133444.22,
                    createdAt: DateTime.now(),
                    status: "pending"),
                onTap: () {},
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.marginEdgeCase24),
                  child: Divider()),
              OrderCard(
                order: OrderModel(
                    id: 2,
                    number: "3333",
                    total: 133444.22,
                    createdAt: DateTime.now(),
                    status: "on-hold"),
                onTap: () {},
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.marginEdgeCase24),
                  child: Divider()),
              OrderCard(
                order: OrderModel(
                    id: 2,
                    number: "3333",
                    total: 133444.22,
                    createdAt: DateTime.now(),
                    status: "failed"),
                onTap: () {},
              ),
            ],
          ),
        ));
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
