
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/app.localization.dart';

class FilterPage extends StatefulWidget {
  final Map filterData;

  const FilterPage({Key key,@required this.filterData}) : super(key: key);
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Map filterData={};
  RangeValues _currentRangeValues= RangeValues(10, 50000);
  CategoryBloc categoryBloc;
  List<dynamic>categories=[];
  List<dynamic>subCategories=[];

  double _lowerValue = 20.0;
  double _upperValue = 80.0;
  double _lowerValueFormatter = 20.0;
  double _upperValueFormatter = 20.0;

  @override
  void initState() {
    filterData=widget.filterData;
    categoryBloc=BlocProvider.of<CategoryBloc>(context);
    categoryBloc.add(GetCategoriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          text: AppLocalizations.of(context).translate("filter"),
          canPop: true,
      actionButtons: [
        FlatButton(onPressed: applyFilter, child: Text(AppLocalizations.of(context).translate("apply"),style: Theme.of(context).textTheme.headline2.copyWith(color: AppColors.primaryColor1),))
      ],
      leadingButton:FlatButton(onPressed: null, child: Text(AppLocalizations.of(context).translate("cancel"),style: Theme.of(context).textTheme.headline2,)),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: BlocProvider<CategoryBloc>(
          create: (context) => categoryBloc,
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if(state is CategoryLoadingState){
                return  Center(child: LoadingWidget());
              }
              if (state is CategoryLoadedState) {
                categories=state.nestedCategories;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(child: Text("Price", style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),

                    Container(child: Text(AppLocalizations.of(context).translate("category"), style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(color:  AppColors.customGreyLevels[200].withOpacity(0.6)), color: Colors.white),
                      child: DropdownButton(
                          isExpanded: true,
                          underline: Container(),
                          value:filterData['selectCategory'],
                          items: categories.map((value) => DropdownMenuItem(child: Container(child: Text(value.name),margin: EdgeInsets.symmetric(horizontal: 20),), value: value)).toList(),
                          onChanged: onSelectedCategoryChange
                      ),
                    ),
                  subCategories.length>1? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text(AppLocalizations.of(context).translate("subcategory"), style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.zero), border: Border.all(color:  AppColors.customGreyLevels[200].withOpacity(0.6)), color: Colors.white),
                        child: DropdownButton(
                            isExpanded: true,
                            underline: Container(),
                            value: filterData['subcategory'],
                            items: subCategories.map((value) => DropdownMenuItem(child: Container(child: Text(value.name),margin: EdgeInsets.symmetric(horizontal: 20),), value: value.id)).toList(),
                            onChanged: (value) {setState(() {filterData['subcategory'] = value;});}),
                      ),
                    ],
                  ):Container()
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  onSelectedCategoryChange(value) {
  setState(() {
    filterData['category']=value.id;
    subCategories=value.children;
    filterData['selectCategory']=value;
  });
  }

  void applyFilter() {
    Navigator.pop(context,filterData);
  }
}

