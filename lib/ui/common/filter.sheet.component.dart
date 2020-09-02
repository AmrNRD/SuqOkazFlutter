import 'package:flutter/material.dart';
import 'package:suqokaz/ui/common/radio_button.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';

class FilterSheet extends StatefulWidget {
  final Function onFilterChange;
  final String orderBy;
  final String order;

  const FilterSheet({Key key, this.onFilterChange, this.orderBy, this.order})
      : super(key: key);

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int selectedFilter = 1;

  @override
  void initState() {
    super.initState();

    if (widget.orderBy != null && widget.order != null) {
      if (widget.orderBy == null) {
        selectedFilter = 1;
      } else if (widget.orderBy == "price") {
        if (widget.order == "desc") {
          selectedFilter = 2;
        } else if (widget.order == "asc") {
          selectedFilter = 3;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 16, end: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 100,
            height: 5,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: AppColors.customGreyLevels[50].withOpacity(0.1),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 12),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          AppLocalizations.of(context).translate("sort_by"),
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Color(0xFFE8E8E8).withOpacity(0.3),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              color: Colors.black.withOpacity(0.15),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 22),
            child: filterButtonBuilder(
              value: selectedFilter == 1,
              onPressed: (value) {
                setState(() {
                  selectedFilter = 1;
                });
                if (widget.onFilterChange != null)
                  widget.onFilterChange(null, null);
              },
              textBody:
                  AppLocalizations.of(context).translate("popularity_sort"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 22),
            child: filterButtonBuilder(
              value: selectedFilter == 2,
              onPressed: (value) {
                setState(() {
                  selectedFilter = 2;
                });
                if (widget.onFilterChange != null)
                  widget.onFilterChange("price", "desc");
              },
              textBody:
                  AppLocalizations.of(context).translate("price_sort_high"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 22),
            child: filterButtonBuilder(
              value: selectedFilter == 3,
              onPressed: (value) {
                setState(() {
                  selectedFilter = 3;
                });
                if (widget.onFilterChange != null)
                  widget.onFilterChange("price", "asc");
              },
              textBody:
                  AppLocalizations.of(context).translate("price_sort_low"),
            ),
          ),
        ],
      ),
    );
  }

  Row filterButtonBuilder(
      {Function(bool) onPressed, String textBody, @required bool value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          textBody,
          style: value
              ? Theme.of(context).textTheme.button.copyWith(
                    fontWeight: FontWeight.w700,
                  )
              : Theme.of(context).textTheme.button,
        ),
        CustomRadioButton(
          onPressed: onPressed,
          value: value,
        )
      ],
    );
  }
}
