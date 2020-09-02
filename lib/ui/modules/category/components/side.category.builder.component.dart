import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class SideCategoryBuilderComponent extends StatefulWidget {
  final List<dynamic> parentCategories;
  final Function(int) changeParentCategory;

  const SideCategoryBuilderComponent({
    Key key,
    this.parentCategories,
    @required this.changeParentCategory,
  }) : super(key: key);

  @override
  _SideCategoryBuilderComponentState createState() =>
      _SideCategoryBuilderComponentState();
}

class _SideCategoryBuilderComponentState
    extends State<SideCategoryBuilderComponent> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.customGreyLevels[400],
      child: ListView.builder(
        primary: false,
        itemCount: widget.parentCategories.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.changeParentCategory(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? Colors.white
                    : AppColors.customGreyLevels[400],
                border: BorderDirectional(
                  start: _selectedIndex == index
                      ? BorderSide(
                          color: AppColors.primaryColors[50],
                          width: 2,
                        )
                      : BorderSide.none,
                  bottom: BorderSide(
                    color: AppColors.customGreyLevels[200],
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Text(
                widget.parentCategories[index].name,
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: _selectedIndex == index
                          ? AppColors.primaryColors[200]
                          : AppColors.customGreyLevels[700],
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
