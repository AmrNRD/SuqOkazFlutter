import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductViewModificationComponent extends StatelessWidget {
  final Function onFilterViewClick;
  final Function onViewChangeClick;
  final Function onSortClick;
  final bool isListView;

  const ProductViewModificationComponent({
    Key key,
    this.onFilterViewClick,
    this.onViewChangeClick,
    this.onSortClick,
    this.isListView = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton.icon(
            onPressed: onFilterViewClick,
            icon: SvgPicture.asset("assets/icons/filter_icon.svg"),
            label: Text(
              AppLocalizations.of(context)
                  .translate("todo", defaultText: "Filter By"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                  left: BorderSide(color: Color(0xFFF2F2F2), width: 1)),
            ),
            child: FlatButton.icon(
              onPressed: onSortClick,
              icon: SvgPicture.asset("assets/icons/sort_icon.svg"),
              label: Text(
                AppLocalizations.of(context)
                    .translate("todo", defaultText: "Sort By"),
              ),
            ),
          ),
          FlatButton.icon(
            onPressed: onViewChangeClick,
            icon: isListView
                ? SvgPicture.asset("assets/icons/gridview_icon.svg")
                : SvgPicture.asset("assets/icons/listview_icon.svg"),
            label: Text(
              isListView
                  ? AppLocalizations.of(context)
                      .translate("todo", defaultText: "GridView")
                  : AppLocalizations.of(context)
                      .translate("todo", defaultText: "ListView"),
            ),
          ),
        ],
      ),
    );
  }
}
