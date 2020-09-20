import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:suqokaz/ui/common/skeleton.dart';

class ImageViewInspector extends StatefulWidget {
  final List<String> images;
  final int intitalIndex;

  const ImageViewInspector({Key key, @required this.images, @required this.intitalIndex}) : super(key: key);
  @override
  _ImageViewInspectorState createState() => _ImageViewInspectorState();
}

class _ImageViewInspectorState extends State<ImageViewInspector> {
  PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.intitalIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: ClampingScrollPhysics(),
                backgroundDecoration: BoxDecoration(color: Colors.white),
                pageController: _controller,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(widget.images[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: 0.4,
                    maxScale: 1.0,
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: widget.images[index],
                    ),
                  );
                },
                itemCount: widget.images.length,
                loadingBuilder: (context, event) => Skeleton(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
