import 'package:flutter/material.dart';
import 'package:suqokaz/utils/app.localization.dart';

class HelperWidgets {
  // TODO set as global state view
  static Widget getNoEntriesWidget(BuildContext context, bool silverContainer) {
    Widget widget = Padding(
        padding: EdgeInsets.all(15),
        child: Center(
            child: Text(
          AppLocalizations.of(context).translate("No data entry", defaultText: "No data entry"),
          style: TextStyle(
            color: Color(0xff4B4B4B),
            fontSize: 17,
            fontFamily: "Roboto Condensed",
            fontWeight: FontWeight.w700,
          ),
        )));
    if (silverContainer) {
      return SliverToBoxAdapter(child: widget);
    } else {
      return widget;
    }
  }

  // TODO set as global state view

  static Widget getLoadingWidget(BuildContext context, bool silverContainer) {
    Widget widget = Center(
      child: Container(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Color(0xffD0D0D0),
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffE6A537)),
        ),
      ),
    );
    if (silverContainer) {
      return SliverToBoxAdapter(child: widget);
    } else {
      return widget;
    }
  }

  // TODO set as global state view

  static Widget getLoadingCardWidget(
      BuildContext context, bool silverContainer) {
    Widget widget = Container(
      margin: EdgeInsetsDirectional.only(start: 6, end: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Color(0xFFF2F2F2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Color(0xffD0D0D0),
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffE6A537)),
          ),
        ),
      ),
    );
    if (silverContainer) {
      return SliverToBoxAdapter(child: widget);
    } else {
      return widget;
    }
  }

  // TODO set as global state view

  static Widget getErrorWidget(BuildContext context, Function retryFunction,
      String errorMessage, bool silverContainer) {
    Widget widget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                  child: Text(
                errorMessage,
                style: TextStyle(
                  color: Color(0xff4B4B4B),
                  fontSize: 17,
                  fontFamily: "Roboto Condensed",
                  fontWeight: FontWeight.w700,
                ),
              ))),
          RaisedButton(
            color: Color(0xffE6A537),
            child: Text(
              AppLocalizations.of(context)
                  .translate("Retry", defaultText: "Retry"),
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 14,
                fontFamily: "Roboto Condensed",
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: retryFunction != null ? retryFunction : null,
          ),
        ],
      ),
    );
    if (silverContainer) {
      return SliverToBoxAdapter(child: widget);
    } else {
      return widget;
    }
  }
}
