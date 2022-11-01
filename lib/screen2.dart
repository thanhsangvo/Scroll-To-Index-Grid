import 'package:example/hero_widget.dart';
import 'package:example/main.dart';
import 'package:example/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Screen2 extends StatefulWidget {
  Screen2(
      {super.key, required this.currentPageValue, required this.listImageTest});
  final List<SampleImage> listImageTest;
  final int currentPageValue;
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.currentPageValue);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<IndexProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'jfnljenlj');
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: ExtendedImageSlidePage(
        // slidePageBackgroundHandler: (offset, pageSize) => Colors.transparent,
        key: slidePagekey,
        slideAxis: SlideAxis.vertical,
        slideType: SlideType.onlyImage,
        child: ExtendedImageGesturePageView.builder(
          controller: ExtendedPageController(
            initialPage: widget.currentPageValue,
            pageSpacing: 0,
            shouldIgnorePointerWhenScrolling: false,
          ),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            print('onPageChanged $index');
            model.extendImagePageChanged(index);
          },
          itemCount: widget.listImageTest.length,
          itemBuilder: ((ctx, index) {
            return HeroWidget(
              slidePagekey: slidePagekey,
              tag: widget.listImageTest[index].url,
              child: ExtendedImage.network(
                widget.listImageTest[index].url,
                mode: ExtendedImageMode.gesture,
                enableSlideOutPage: true,
                imageCacheName: 'Photo',
              ),
            );
          }),
        ),
      ),
    );
  }
}
