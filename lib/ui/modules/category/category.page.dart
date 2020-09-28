import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/genearic.state.component.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/modules/category/components/child.category.builder.component.dart';
import 'package:suqokaz/ui/modules/category/components/side.category.builder.component.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';

class CategoryPage extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryBloc>(context).add(
      GetCategoriesEvent(),
    );
  }

  changeParentCategory(int index) {
    setState(() {
      _selectedParentCategory = index;
    });
  }

  int _selectedParentCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: CategoryPage.scaffoldKey,
      appBar: CustomAppBar(
        elevation: 0,
        text: AppLocalizations.of(context).translate("all_categories"),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return LoadingWidget();
          } else if (state is CategoryLoadedState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SideCategoryBuilderComponent(
                    parentCategories: state.nestedCategories,
                    changeParentCategory: changeParentCategory,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ChildCategoryBuilderComponent(
                    parentName:
                        state.nestedCategories[_selectedParentCategory].name,
                    childrenCategories: state
                        .nestedCategories[_selectedParentCategory].children
                        .where(
                            (dynamic element) => element.children.length != 0)
                        .toList() as List<dynamic>,
                  ),
                )
              ],
            );
          } else if (state is CategoryErrorState) {
            return GenericState(
              size: 40,
              margin: 8,
              fontSize: 16,
              removeButton: true,
              imagePath: Constants.imagePath["error"],
              titleKey: AppLocalizations.of(context).translate("sad", defaultText: ":("),
              bodyKey: state.message,
            );
          }
          return Container();
        },
      ),
    );
  }
}
