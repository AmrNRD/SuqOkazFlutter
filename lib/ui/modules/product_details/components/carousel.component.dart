import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:suqokaz/ui/common/skeleton.dart';
import 'package:suqokaz/ui/modules/product_details/components/image.inspector.component.dart';
import 'package:suqokaz/ui/style/app.colors.dart';
import 'package:suqokaz/utils/core.util.dart';

class CustomCarouselComponent extends StatefulWidget {
  final List<String> images;

  const CustomCarouselComponent({
    Key key,
    @required this.images,
  }) : super(key: key);

  @override
  _CustomCarouselComponentState createState() => _CustomCarouselComponentState();
}

class _CustomCarouselComponentState extends State<CustomCarouselComponent> {
  int _selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: _pushImageInspector,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: ImageProcessor.image(
                url: widget.images[_selectedImage],
                fit: BoxFit.contain,
                height: screenAwareSize(180, context),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Container(
          height: screenAwareSize(52, context),
          child: ListView.builder(
            itemCount: widget.images.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: screenAwareSize(52, context),
                margin: EdgeInsetsDirectional.only(end: 8),
                decoration: _selectedImage == index
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryColors[50],
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColors[50].withOpacity(0.25),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.customGreyLevels[500],
                          width: 1,
                        ),
                      ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: _selectedImage == index
                      ? null
                      : () {
                          setState(() {
                            _selectedImage = index;
                          });
                        },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: ImageProcessor.image(
                      url: widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _pushImageInspector() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) => ImageViewInspector(
          images: widget.images,
          intitalIndex: _selectedImage,
        ),
      ),
    );
  }
}
