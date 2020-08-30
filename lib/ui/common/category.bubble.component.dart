import 'package:flutter/material.dart';
import 'package:suqokaz/data/models/category_model.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class CategoryBubbleComponent extends StatelessWidget {
  const CategoryBubbleComponent({
    Key key,
    @required this.category,
    @required this.index,
  }) : super(key: key);

  final CategoryModel category;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: index != 6 - 1 ? 18 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(26),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Constants.productCategoriesPage,
                arguments: [
                  category.name,
                  category.children,
                  category.id,
                ],
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: generateRandomColor(index),
                boxShadow: [
                  BoxShadow(
                    color: generateRandomColor(index),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: ImageProcessor.image(
                    url: category.image,
                    fit: BoxFit.cover,
                    height: 38,
                    width: 38,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            category.name,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w400, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
