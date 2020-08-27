import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/order_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/core.util.dart';

class MyOrderCard extends StatelessWidget {
  final Function onTap;
  final OrderModel order;
  final bool isCartItem;

  const MyOrderCard({Key key, @required this.order,@required this.onTap, this.isCartItem=false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (order != null) {
      if (order.status != null) {
        switch (order.status) {
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
      }
    }
   return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsetsDirectional.only(
            top: AppDimens.marginDefault8, bottom: AppDimens.marginDefault8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.customGreyLevels[200].withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              height: screenAwareSize(80, context),
              width: screenAwareSize(80, context),
              child: ImageProcessor.image(
                url: "https://pngimg.com/uploads/croissant/croissant_PNG46722.png", // TODO images required
                fit: BoxFit.contain),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: AppDimens.marginDefault16, end: AppDimens.marginDefault16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "#${order.number}",
                              style: Theme.of(context).textTheme.headline2,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate("currency", replacement: "${order.total}"),
                                style: AppTheme.bodySmall.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppDimens.marginDefault8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate("quantity", replacement: (order.lineItems != null) ? "${order.lineItems.length}" : "0"),
                          style: AppTheme.bodySmall.copyWith(
                              color: AppColors.primaryColors[200],
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        isCartItem
                            ? Container()
                            : Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate("status")+": ",
                              style: AppTheme.bodySmall.copyWith(
                                  color: AppColors.primaryColors[200],
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              (order.status != null)
                                  ? "${order.status.toUpperCase()}"
                                  : "NA",
                              style: AppTheme.bodySmall.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        isCartItem
                            ? Container()
                            : Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate("payment")+": ",
                              style: AppTheme.bodySmall.copyWith(
                                  color: AppColors.primaryColors[200],
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${order.paymentMethodTitle}",
                              style: AppTheme.bodySmall.copyWith(
                                  color: AppColors.primaryColors[200],
                                  fontWeight: FontWeight.w400),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        isCartItem
                            ? Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColors[50],
                                    borderRadius:
                                    BorderRadiusDirectional.only(
                                      topStart: Radius.circular(5),
                                      bottomStart: Radius.circular(5),
                                    ),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          "-",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
//                                              setState(() {
//                                                if (productQuantity > 1) {
//                                                  productQuantity--;
//                                                }
//                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.primaryColors[50],
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                     "1",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          color:
                                          AppColors.primaryColors[50],
                                          borderRadius:
                                          BorderRadiusDirectional
                                              .only(
                                            topEnd: Radius.circular(5),
                                            bottomEnd: Radius.circular(5),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(
                                              fontWeight:
                                              FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
//                                              setState(() {
//                                                productQuantity++;
//                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(1),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("remove"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: Color(0xFFF55F44),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
