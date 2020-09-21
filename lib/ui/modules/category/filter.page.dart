
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_select/smart_select.dart';
import 'package:suqokaz/bloc/category/category_bloc.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/custom_appbar.dart';
import 'package:suqokaz/ui/common/loading.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/theme.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

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
  double _lowerValue=0;
  double _upperValue=50000;
  List<SmartSelectOption<dynamic>> list = [];
  List<SmartSelectOption<dynamic>> subList = [];
  bool loadingCategory=false;
  Function onCategory;


  @override
  void initState() {
    filterData=widget.filterData;
    categoryBloc=BlocProvider.of<CategoryBloc>(context);
    categoryBloc.add(GetCategoriesEvent());
    if(widget.filterData!=null && widget.filterData.containsKey("minPrice")) {
      _lowerValue=widget.filterData['minPrice'];
      _upperValue=widget.filterData['maxPrice'];
      }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: Text(AppLocalizations.of(context).translate("price"), style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),
              frs.RangeSlider(
                min: 0.0,
                max:50000,
                lowerValue: _lowerValue,
                upperValue: _upperValue,
                divisions: 500,
                showValueIndicator: true,
                valueIndicatorMaxDecimals: 1,
                onChanged: (double newLowerValue, double newUpperValue) {
                  setState(() {
                    _lowerValue = newLowerValue;
                    _upperValue = newUpperValue;
                    filterData['minPrice']=newLowerValue;
                    filterData['maxPrice']=newUpperValue;
                  });
                },
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text(AppLocalizations.of(context).translate("category"), style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),
                      BlocListener<CategoryBloc, CategoryState>(
                        listener: (context, state) {
                          if (state is CategoryLoadingState) {
                            setState(() {
                              loadingCategory = true;
                            });
                          } else if (state is CategoryLoadedState) {
                            setState(() {
                              loadingCategory = false;
                              categories=state.nestedCategories;
                              list = categories.map((type) => SmartSelectOption<dynamic>(value: type, group: null, title: type.name)).toList();
                            });
                          } else if (state is CategoryLoadedState) {
                            setState(() {
                              loadingCategory = false;
                            });
                          }
                        },
                        child: InkWell(
                          onTap: onCategory,
                          child: SmartSelect<dynamic>.single(
                            title: AppLocalizations.of(context).translate("category"),
                            value: filterData['selectCategory'],
                            options: list,
                            dense: true,
                            isLoading: loadingCategory,
                            choiceConfig: SmartSelectChoiceConfig(
                              useDivider: true,
                              isGrouped: false,
                              glowingOverscrollIndicatorColor: AppColors.primaryColor1,
                              style: SmartSelectChoiceStyle(
                                titleStyle: Theme.of(context).textTheme.headline3,
                                activeTitleStyle: Theme.of(context).textTheme.headline3,
                                subtitleStyle: Theme.of(context).textTheme.headline3,
                                activeSubtitleStyle: Theme.of(context).textTheme.headline3,
                                inactiveColor: Theme.of(context).textTheme.headline3.color,
                                activeColor: AppColors.primaryColor1,
                              ),
                            ),
                            modalConfig: SmartSelectModalConfig(headerStyle: SmartSelectModalHeaderStyle(textStyle:  Theme.of(context).textTheme.headline2, backgroundColor: Theme.of(context).cardColor, iconTheme:IconThemeData(color: Theme.of(context).textTheme.headline3.color)),),

                            builder: (BuildContext context, SmartSelectState<dynamic> state, SmartSelectShowModal showChoices){
                              onCategory=()=>showChoices(context);

                              return GestureDetector(
                                onTap: ()=>showChoices(context),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(state.valueTitle??AppLocalizations.of(context).translate("Choose your categories"), style: state.valueTitle==null?Theme.of(context).textTheme.headline3.copyWith(color: AppColors.customGreyLevels[100]):Theme.of(context).textTheme.headline3.copyWith(color: AppColors.customGreyLevels[100]),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ],
                                ),
                              );
                            },
                            onChange: onSelectedCategoryChange,
                            choiceType: SmartSelectChoiceType.radios,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child:Icon(Icons.arrow_forward_ios,color: Theme.of(context).dividerColor,),
                  )
                ],
              ),
              SizedBox(height: 20),
              Divider(color:  AppColors.customGreyLevels[100]),
              subCategories.length>1? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(child: Text(AppLocalizations.of(context).translate("subcategory"), style: Theme.of(context).textTheme.headline2),margin: EdgeInsets.symmetric(vertical: 20)),
                      Container(
                        child: SmartSelect<dynamic>.single(
                          title: AppLocalizations.of(context).translate("subcategory"),
                          value: filterData['subcategory'],
                          options: subList,
                          dense: true,
                          isLoading: loadingCategory,
                          choiceConfig: SmartSelectChoiceConfig(
                            useDivider: true,
                            isGrouped: false,
                            glowingOverscrollIndicatorColor: AppColors.primaryColor1,
                            style: SmartSelectChoiceStyle(
                              titleStyle: Theme.of(context).textTheme.headline3,
                              activeTitleStyle: Theme.of(context).textTheme.headline3,
                              subtitleStyle: Theme.of(context).textTheme.headline3,
                              activeSubtitleStyle: Theme.of(context).textTheme.headline3,
                              inactiveColor: Theme.of(context).textTheme.headline3.color,
                              activeColor: AppColors.primaryColor1,
                            ),
                          ),
                          modalConfig: SmartSelectModalConfig(headerStyle: SmartSelectModalHeaderStyle(textStyle:  Theme.of(context).textTheme.headline2, backgroundColor: Theme.of(context).cardColor, iconTheme:IconThemeData(color: Theme.of(context).textTheme.headline3.color)),),

                          builder: (BuildContext context, SmartSelectState<dynamic> state, SmartSelectShowModal showChoices){
                            return GestureDetector(
                              onTap: ()=>showChoices(context),
                              child: Container(
                                child: Row(
                                mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(state.valueTitle??AppLocalizations.of(context).translate("Choose your categories"), style: state.valueTitle==null?Theme.of(context).textTheme.headline3.copyWith(color: AppColors.customGreyLevels[100]):Theme.of(context).textTheme.headline3.copyWith(color: AppColors.customGreyLevels[100]),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          onChange: (value) {setState(() {filterData['subcategory'] = value;});},
                          choiceType: SmartSelectChoiceType.radios,
                        ),
                      ),


                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child:Icon(Icons.arrow_forward_ios,color: Theme.of(context).dividerColor,),
                  )
                ],
              ):Container()
            ],
          ),
        ),
      ),
    );
  }

  onSelectedCategoryChange(value) {
  setState(() {
    filterData['subcategory']=null;
    filterData['category']=value.id;
    filterData['subCategories']=value.children;
    subCategories=value.children;
    subList = subCategories.map((type) => SmartSelectOption<dynamic>(value: type.id, group: null, title: type.name)).toList();
    filterData['selectCategory']=value;
    filterData['selectedCategoryID']=value.id;
    if(subCategories.length>0){
      filterData['subcategory']=subCategories[0].id;
      filterData['selectedCategoryID']=subCategories[0].id;
    }
  });
  }

  void applyFilter() {
    Navigator.pop(context,filterData);
  }
}



// ---------------------------------------------------
// Helper class aimed at simplifying the way to
// automate the creation of a series of RangeSliders,
// based on various parameters
//
// This class is to be used to demonstrate the appearance
// customization of the RangeSliders
// ---------------------------------------------------
class RangeSliderData {
  double min;
  double max;
  double lowerValue;
  double upperValue;
  int divisions;
  bool showValueIndicator;
  int valueIndicatorMaxDecimals;
  bool forceValueIndicator;
  Color overlayColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color thumbColor;
  Color valueIndicatorColor;
  Color activeTickMarkColor;

  static const Color defaultActiveTrackColor = const Color(0xFF0175c2);
  static const Color defaultInactiveTrackColor = const Color(0x3d0175c2);
  static const Color defaultActiveTickMarkColor = const Color(0x8a0175c2);
  static const Color defaultThumbColor = const Color(0xFF0175c2);
  static const Color defaultValueIndicatorColor = const Color(0xFF0175c2);
  static const Color defaultOverlayColor = const Color(0x290175c2);

  RangeSliderData({
    this.min,
    this.max,
    this.lowerValue,
    this.upperValue,
    this.divisions,
    this.showValueIndicator: true,
    this.valueIndicatorMaxDecimals: 1,
    this.forceValueIndicator: false,
    this.overlayColor: defaultOverlayColor,
    this.activeTrackColor: defaultActiveTrackColor,
    this.inactiveTrackColor: defaultInactiveTrackColor,
    this.thumbColor: defaultThumbColor,
    this.valueIndicatorColor: defaultValueIndicatorColor,
    this.activeTickMarkColor: defaultActiveTickMarkColor,
  });

  // Returns the values in text format, with the number
  // of decimals, limited to the valueIndicatedMaxDecimals
  //
  String get lowerValueText =>
      lowerValue.toStringAsFixed(valueIndicatorMaxDecimals);
  String get upperValueText =>
      upperValue.toStringAsFixed(valueIndicatorMaxDecimals);

  // Builds a RangeSlider and customizes the theme
  // based on parameters
  //
  Widget build(BuildContext context, frs.RangeSliderCallback callback) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(lowerValueText),
          ),
          Expanded(
            child: SliderTheme(
              // Customization of the SliderTheme
              // based on individual definitions
              // (see rangeSliders in _RangeSliderSampleState)
              data: SliderTheme.of(context).copyWith(
                overlayColor: overlayColor,
                activeTickMarkColor: activeTickMarkColor,
                activeTrackColor: activeTrackColor,
                inactiveTrackColor: inactiveTrackColor,
                //trackHeight: 8.0,
                thumbColor: thumbColor,
                valueIndicatorColor: valueIndicatorColor,
                showValueIndicator: showValueIndicator
                    ? ShowValueIndicator.always
                    : ShowValueIndicator.onlyForDiscrete,
              ),
              child: frs.RangeSlider(
                min: min,
                max: max,
                lowerValue: lowerValue,
                upperValue: upperValue,
                divisions: divisions,
                showValueIndicator: showValueIndicator,
                valueIndicatorMaxDecimals: valueIndicatorMaxDecimals,
                onChanged: (double lower, double upper) {
                  // call
                  callback(lower, upper);
                },
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minWidth: 40.0,
              maxWidth: 40.0,
            ),
            child: Text(upperValueText),
          ),
        ],
      ),
    );
  }
}
