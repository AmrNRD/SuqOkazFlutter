import 'package:flutter/material.dart';
import 'package:suqokaz/ui/modules/home/components/category.banner.box.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class ChildCategoryBuilderComponent extends StatelessWidget {
  final List<dynamic> childrenCategories;
  final String parentName;

  const ChildCategoryBuilderComponent({
    Key key,
    @required this.childrenCategories,
    @required this.parentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: childrenCategories.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int parentIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              parentIndex != 0
                  ? SizedBox(
                      height: 16,
                    )
                  : Container(),
              Text(
                childrenCategories[parentIndex].name,
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: screenAwareSize(80, context),
                child: CategoryBannerBox(),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                physics: BouncingScrollPhysics(),
                itemCount: childrenCategories[parentIndex].children.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Constants.productCategoriesPage,
                        arguments: [
                          parentName,
                          childrenCategories,
                          childrenCategories[0].parent,
                          childrenCategories[parentIndex].id
                        ],
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: AppColors.customGreyLevels[400],
                          child: Center(
                            child: ImageProcessor.image(
                              url: childrenCategories[parentIndex]
                                  .children[index]
                                  .image,
                              fit: BoxFit.contain,
                              height: screenAwareSize(70, context),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          childrenCategories[parentIndex].children[index].name,
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
