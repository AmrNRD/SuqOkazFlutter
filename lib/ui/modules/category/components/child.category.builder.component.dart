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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Constants.productCategoriesPage,
                    arguments: [
                      childrenCategories[parentIndex].name,
                      childrenCategories[parentIndex].children,
                      childrenCategories[parentIndex].id,
                    ],
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      childrenCategories[parentIndex].name,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    childrenCategories[parentIndex].imageBanner == null
                        ? Container()
                        : ImageProcessor.image(
                            fit: BoxFit.cover,
                            url: childrenCategories[parentIndex].imageBanner,
                          ),
                  ],
                ),
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
                          childrenCategories[parentIndex].name,
                          childrenCategories[parentIndex].children,
                          childrenCategories[parentIndex].children[index].id,
                          childrenCategories[parentIndex].children[index].id
                        ],
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: AppColors.customGreyLevels[400],
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              child: ImageProcessor.image(
                                url: childrenCategories[parentIndex].children[index].image,
                                fit: BoxFit.cover,
                                height: screenAwareSize(70, context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          childrenCategories[parentIndex].children[index].name,
                          softWrap: true,
                          maxLines: 2,
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
