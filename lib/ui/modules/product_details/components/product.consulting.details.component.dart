import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:suqokaz/data/models/product_model.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.description.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.button.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.details.review.component.dart';
import 'package:suqokaz/ui/modules/product_details/components/product.specification.component.dart';
import 'package:suqokaz/utils/app.localization.dart';

class ProductConsultingDetailsComponent extends StatefulWidget {
  final ProductModel productModel;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;
  final int selectedVariation;

  const ProductConsultingDetailsComponent({
    Key key,
    @required this.productModel,
    @required this.scaffoldKey,
    @required this.scrollController,
    @required this.selectedVariation,
  }) : super(key: key);
  @override
  _ProductConsultingDetailsComponentState createState() => _ProductConsultingDetailsComponentState();
}

class _ProductConsultingDetailsComponentState extends State<ProductConsultingDetailsComponent> {
  int _selectedIndex = 0;

  List<Widget> body;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    body = [
      ProductDescriptionComponent(
        description: widget.productModel.description,
      ),
      ProductSpecificationComponent(
        productAttributes: widget.productModel.variations[widget.selectedVariation].attributes,
      ),
      ProductDetailsReviewComponent(
        scaffoldKey: widget.scaffoldKey,
        productId: widget.productModel.id,
      ),
    ];
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        Row(
          children: <Widget>[
            ProductDetailsTab(
              tabName: AppLocalizations.of(context).translate("description", defaultText: "Description").toUpperCase(),
              isSelected: _selectedIndex == 0,
              onTap: _selectedIndex == 0
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                      scrollToTheEnd();
                    },
            ),
            ProductDetailsTab(
              tabName: AppLocalizations.of(context).translate("specifications", defaultText: "Specifications").toUpperCase(),
              isSelected: _selectedIndex == 1,
              onTap: _selectedIndex == 1
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      scrollToTheEnd();
                    },
            ),
            ProductDetailsTab(
              tabName: AppLocalizations.of(context).translate("reviews", defaultText: "Reviews").toUpperCase(),
              isSelected: _selectedIndex == 2,
              onTap: _selectedIndex == 2
                  ? null
                  : () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                      scrollToTheEnd();
                    },
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        body[_selectedIndex],
        SizedBox(
          height: 130,
        ),
      ],
    );
  }

  scrollToTheEnd() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
