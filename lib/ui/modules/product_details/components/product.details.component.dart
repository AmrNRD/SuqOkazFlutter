import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/common/star.rating.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/variation.helper.dart';

class ProductDetailsComponent extends StatefulWidget {
  const ProductDetailsComponent({
    Key key,
    @required this.productModel,
    @required this.updateSettings,
    @required this.selectedVariation,
  }) : super(key: key);

  final ProductModel productModel;
  final Function(int, int, int) updateSettings;
  final int selectedVariation;

  @override
  _ProductDetailsComponentState createState() => _ProductDetailsComponentState();
}

class _ProductDetailsComponentState extends State<ProductDetailsComponent> {
  VariationHelper _variationHelper;
  ProductVariation selectedVariationModel;
  List<Widget> _attributeList = [];

  int quantity = 1;

  updateQuantity(int quantity) {
    setState(() {
      quantity = quantity;
      widget.updateSettings(
        quantity,
        _variationHelper.commonVariations[_variationHelper.selectedVariation].id,
        widget.productModel.variations.indexOf(_variationHelper.commonVariations[_variationHelper.selectedVariation]),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    selectedVariationModel = widget.productModel.variations[widget.selectedVariation];
    _variationHelper = VariationHelper(
      widget.productModel,
      widget.selectedVariation,
    );
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      createAttributeList();
      setState(() {
        _attributeList;
        updateQuantity(1);
      });
    });
  }

  createAttributeList() {
    _attributeList = [];
    var productAttributes = widget.productModel.attributes;
    for (int i = 0; i < productAttributes.length; i++) {
      _attributeList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 4, top: 8),
              child: Text(
                "${productAttributes[i].name}".toUpperCase(),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline3.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: itemsBuilder(i, productAttributes[i]),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<Widget> itemsBuilder(int attrIndex, ProductAttribute productAttribute) {
    List<Widget> temp = [];

    for (int i = 0; i < widget.productModel.attributes[attrIndex].options.length; i++) {
      if (_variationHelper.commonVariationLocator[widget.productModel.attributes[attrIndex].name]
              [widget.productModel.attributes[attrIndex].options[i]] !=
          null) {
        temp.add(
          Container(
            margin: EdgeInsetsDirectional.only(top: 8, bottom: 8, end: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20.0),
              onTap: () {
                _variationHelper.commonVariations = [];
                searchVariationInList(
                  productAttribute.name,
                  productAttribute.options[i],
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: _variationHelper.highlightButton(
                    productAttribute.options[i],
                    productAttribute.name,
                  ),
                  color: _variationHelper.containerColor(
                    productAttribute.options[i],
                    productAttribute.name,
                  ),
                ),
                child: Text(
                  "${productAttribute.options[i]}".toUpperCase(),
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return temp;
  }

  searchVariationInList(String filterName, String filterValue) {
    bool foundedInCommonVariations = false;
    for (ProductVariation variation in _variationHelper.commonVariations) {
      for (Attribute variationAttribute in variation.attributes) {
        if (variationAttribute.option == filterValue && variationAttribute.name == filterName) {
          foundedInCommonVariations = true;
          setState(() {
            _variationHelper.selectedVariation = widget.productModel.variations.indexOf(variation);
            _variationHelper.commonVariations = [];
            createAttributeList();
          });
          break;
        }
      }
    }
    if (!foundedInCommonVariations) {
      print(filterName);
      print(filterValue);
      //TODO : Refactor this to user function to break out of multiple loops
      bool matched = false;
      for (ProductVariation variation in widget.productModel.variations) {
        if (matched) {
          break;
        }
        for (Attribute variationAttribute in variation.attributes) {
          if (variationAttribute.option == filterValue && variationAttribute.name == filterName) {
            matched = true;
            selectedVariationModel = variation;
            widget.updateSettings(
              quantity,
              variation.id,
              widget.productModel.variations.indexOf(variation),
            );
            setState(() {
              _variationHelper.selectedVariation = widget.productModel.variations.indexOf(variation);
              _variationHelper.commonVariations = [];
              _variationHelper.commonVariations.add(widget.productModel.variations[widget.selectedVariation]);
              _variationHelper.commonVariationFinder(filterName, filterValue);
            });
            break;
          }
        }
      }
      if (_variationHelper.commonVariations.length > 0) {
        setState(() {
          createAttributeList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.productModel.categoryName,
                    style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.w400),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppDimens.marginSeparator4,
                  ),
                  Text(
                    widget.productModel.name,
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppDimens.marginSeparator8,
                  ),
                  SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: widget.productModel.averageRating,
                      size: 16.0,
                      color: AppColors.primaryColors[50],
                      borderColor: AppColors.primaryColors[50],
                      label: Text(
                        AppLocalizations.of(context).translate(
                          "review_count",
                          //TODO : SAD
                          replacement: "0",
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontWeight: FontWeight.w400, color: AppColors.customGreyLevels[100]),
                      ),
                      spacing: 0.0)
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                selectedVariationModel.onSale
                    ? Container(
                        child: Text(
                          AppLocalizations.of(context).translate(
                            "currency",
                            replacement: double.parse(
                              selectedVariationModel.salePrice,
                            ).toStringAsFixed(2),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontWeight: FontWeight.w400, decoration: TextDecoration.lineThrough),
                          maxLines: 3,
                          softWrap: true,
                        ),
                        margin: EdgeInsetsDirectional.only(start: AppDimens.marginDefault16),
                      )
                    : Container(),
                Container(
                  child: Text(
                    AppLocalizations.of(context).translate(
                      "currency",
                      replacement: double.parse(selectedVariationModel.price).toStringAsFixed(2),
                    ),
                    maxLines: 3,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w700),
                  ),
                  margin: EdgeInsetsDirectional.only(
                    start: AppDimens.marginDefault16,
                  ),
                ),
              ],
            )
          ],
        ),
        ..._attributeList,
      ],
    );
  }
}
