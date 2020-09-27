import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/style/app.colors.dart';

class VariationHelper {
  int selectedVariation;
  ProductModel productModel;

  Map<String, Map<String, List<ProductVariation>>> commonVariationLocator = {};
  List<ProductVariation> commonVariations = [];

  Map<String, bool> isVariationMatchedBefore = {};

  VariationHelper(ProductModel productModel, int selectedVariationIndex) {
    this.productModel = productModel;
    commonVariations.add(productModel.variations[selectedVariationIndex]);
    selectedVariation = selectedVariationIndex;
    commonVariationLocatorBuilder();

    //TODO refactor commonVariationFinder
    // print("TEST");
    // print(productModel.variations[selectedVariationIndex].attributes[0].name);
    // print(productModel.variations[selectedVariationIndex].attributes[0].option);
    if (productModel.variations[selectedVariationIndex].inStock) {
      commonVariationFinder(
        productModel.variations[selectedVariationIndex].attributes[0].name,
        productModel.variations[selectedVariationIndex].attributes[0].option,
      );
    } else {
      ProductVariation variation = productModel.variations.firstWhere((element) => element.inStock, orElse: null);
      if (variation != null) {
        selectedVariation = productModel.variations.indexOf(variation) ?? 0;
        print(
          variation.attributes[0].name,
        );
        print(
          variation.attributes[0].option,
        );
        commonVariationFinder(
          variation.attributes[0].name,
          variation.attributes[0].option,
        );
      } else {
        print(productModel.variations[selectedVariationIndex].attributes[0].name);
        print(productModel.variations[selectedVariationIndex].attributes[0].option);
        commonVariationFinder(
          productModel.variations[selectedVariationIndex].attributes[0].name,
          productModel.variations[selectedVariationIndex].attributes[0].option,
        );
      }
    }

    //print("TEST");
  }

  commonVariationLocatorBuilder() {
    List<ProductVariation> temp = [];

    for (ProductAttribute attribute in productModel.attributes) {
      isVariationMatchedBefore[attribute.name] = false;
      for (String attributeValue in attribute.options) {
        temp = [];
        for (ProductVariation variation in productModel.variations) {
          for (Attribute variationAttribute in variation.attributes) {
            // print("---------------");
            // print(attribute.toJson());
            // print(attribute.name);
            // print(attributeValue);
            // print("---------------");
            // print("---------------");
            // print(variationAttribute.toJson());
            // print(variationAttribute.name);
            // print(variationAttribute.option);
            // print("---------------");
            if (variationAttribute.name == attribute.name) {
              if (variationAttribute.option == attributeValue) {
                temp.add(variation);
                if (commonVariationLocator.containsKey(attribute.name)) {
                  Map mapValue = commonVariationLocator[attribute.name];
                  mapValue[attributeValue] = temp;
                  commonVariationLocator[attribute.name] = mapValue;
                } else {
                  commonVariationLocator[attribute.name] = {attributeValue: temp};
                }
              }
              continue;
            }
          }
        }
      }
    }
    print(commonVariationLocator.toString());
  }

  commonVariationFinder(String filterName, String filterValue) {
    isVariationMatchedBefore.updateAll((key, value) => false);
    List<ProductVariation> temp = [];

    if (commonVariationLocator.containsKey(filterName)) {
      if (commonVariationLocator[filterName].containsKey(filterValue)) {
        commonVariationLocator[filterName][filterValue][0].attributes.forEach((attribute) {
          if (commonVariationLocator[attribute.name][attribute.option].isNotEmpty) {
            temp.addAll(commonVariationLocator[attribute.name][attribute.option]);
          }
        });
      }
    }
    commonVariations = temp;
    if (commonVariations.isEmpty) {
      commonVariations = (commonVariationLocator.values.toList().first).values.toList().first;
    }
  }

  Color containerColor(
    String filterName,
    String filterParentName,
  ) {
    //IF the sent attribute and attribute value equals the current selected variation heightlight it with diffrent color
    //So that the user knows what excatly variation is selected.
    for (Attribute variationAttribute in productModel.variations[selectedVariation].attributes) {
      if (variationAttribute.option == filterName && variationAttribute.name == filterParentName) {
        return Colors.white;
      }
    }
    //IF NOT, then check if the sent attribute and attribute value are in the common variation list that share attributes
    //with another variations, then highlight it with diffrent color so that the user knows that the current selected variation
    //share attributes with another variation.
    bool matched = false;
    for (ProductVariation variationUnit in commonVariations) {
      for (Attribute variationAttribute in variationUnit.attributes) {
        if (variationAttribute.name == filterParentName && variationAttribute.option == filterName) {
          matched = true;
        }
      }
    }
    return matched ? Colors.white : Color(0xFFEDEDED);
  }

  Border highlightButton(
    String filterName,
    String filterParentName,
  ) {
    for (Attribute attribute in productModel.variations[selectedVariation].attributes) {
      if (attribute.option == filterName) {
        isVariationMatchedBefore[filterParentName] = true;
        return Border.all(
          color: AppColors.primaryColors[50],
          width: 2,
        );
      }
    }
    bool matched = false;
    for (ProductVariation variationUnit in commonVariations) {
      for (Attribute variationAttribute in variationUnit.attributes) {
        if (variationAttribute.name == filterParentName && variationAttribute.option == filterName) {
          matched = true;
        }
      }
    }

    return matched
        ? Border.all(
            color: Colors.grey,
            width: 2,
          )
        : Border.all(
            color: Colors.white,
            width: 0,
          );
  }

  Color highLightColorButton(
    String filterName,
    String filterParentName,
  ) {
    for (Attribute attribute in productModel.variations[selectedVariation].attributes) {
      if (attribute.option == filterName) {
        isVariationMatchedBefore[filterParentName] = true;
        return AppColors.primaryColors[50];
      }
    }
    bool matched = false;
    for (ProductVariation variationUnit in commonVariations) {
      for (Attribute variationAttribute in variationUnit.attributes) {
        if (variationAttribute.name == filterParentName && variationAttribute.option == filterName) {
          matched = true;
        }
      }
    }
    return matched ? Colors.black.withOpacity(0.3) : Colors.white;
  }
}
