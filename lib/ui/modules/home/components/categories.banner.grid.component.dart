import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:suqokaz/data/models/banner_model.dart';
import 'package:suqokaz/ui/style/app.dimens.dart';
import 'package:suqokaz/utils/app.localization.dart';
import 'package:suqokaz/utils/constants.dart';
import 'package:suqokaz/utils/core.util.dart';

class CategoriesBannerGridComponent extends StatefulWidget {
  final List<BannerModel> banners;
  const CategoriesBannerGridComponent({Key key, this.banners}) : super(key: key);
  @override
  _CategoriesBannerGridComponentState createState() => _CategoriesBannerGridComponentState();
}

class _CategoriesBannerGridComponentState extends State<CategoriesBannerGridComponent> {
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimens.marginDefault8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // CategoryBannerHeader(),
          // CategoryBannerBox(),
          widget.banners != null && widget.banners.length != 0
              ? GestureDetector(
                  onTap: widget.banners[0].categoryId.isEmpty
                      ? null
                      : () {
                          Navigator.pushNamed(
                            context,
                            Constants.productCategoriesPage,
                            arguments: [
                              widget.banners[0].categoryName ?? AppLocalizations.of(context).translate("no_categories"),
                              [],
                              int.tryParse(
                                widget.banners[0].categoryId,
                              )
                            ],
                          );
                        },
                  child: ImageProcessor.image(
                    fit: BoxFit.fill,
                    url: widget.banners[0].image,
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: AppDimens.marginDefault8,
            ),
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              crossAxisCount: 2,
              itemCount: widget.banners.length - 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppDimens.marginDefault8,
              mainAxisSpacing: AppDimens.marginDefault8,
              staggeredTileBuilder: (int index) => StaggeredTile.count(1, 0.4),
              scrollDirection: Axis.vertical,
              addAutomaticKeepAlives: true,
              itemBuilder: (BuildContext context, int index) {
                return widget.banners[index + 1].image == null
                    ? Container()
                    : GestureDetector(
                        onTap: widget.banners[index].categoryId.isEmpty
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  Constants.productCategoriesPage,
                                  arguments: [
                                    widget.banners[index].categoryName ?? AppLocalizations.of(context).translate("no_categories"),
                                    [],
                                    int.tryParse(
                                      widget.banners[index].categoryId,
                                    )
                                  ],
                                );
                              },
                        child: ImageProcessor.image(
                          fit: BoxFit.fill,
                          url: widget.banners[index + 1].image,
                        ),
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
