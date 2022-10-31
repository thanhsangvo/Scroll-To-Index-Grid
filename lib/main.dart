import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/provider.dart';
import 'package:example/screen2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider(create: (context) => MyHomePage()),
        ChangeNotifierProvider<IndexProvider>(
          create: (ctx) => IndexProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Scroll To Index Grid',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Scroll To Index Grid'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SampleImage {
  final String url;

  SampleImage(this.url);
}

List<SampleImage> testImage = [
  SampleImage('https://picsum.photos/id/0/5616/3744'),
  SampleImage('https://picsum.photos/id/1/5616/3744'),
  SampleImage('https://picsum.photos/id/10/2500/1667'),
  SampleImage('https://picsum.photos/id/100/2500/1656'),
  SampleImage('https://picsum.photos/id/1000/5626/3635'),
  SampleImage('https://picsum.photos/id/1001/5616/3744'),
  SampleImage('https://picsum.photos/id/1002/4312/2868'),
  SampleImage('https://picsum.photos/id/1003/1181/1772'),
  SampleImage('https://picsum.photos/id/1004/5616/3744'),
  SampleImage('https://picsum.photos/id/1005/5760/3840'),
  SampleImage('https://picsum.photos/id/1006/3000/2000'),
  SampleImage('https://picsum.photos/id/1008/5616/3744'),
  SampleImage('https://picsum.photos/id/1009/5000/7502'),
  SampleImage('https://picsum.photos/id/101/2621/1747'),
  SampleImage('https://picsum.photos/id/1010/5184/3456'),
  SampleImage('https://picsum.photos/id/1011/5472/3648'),
  SampleImage('https://picsum.photos/id/1012/3973/2639'),
  SampleImage('https://picsum.photos/id/1013/4256/2832'),
  SampleImage('https://picsum.photos/id/1014/6016/4000'),
  SampleImage('https://source.unsplash.com/random?sig=18'),
];

class _MyHomePageState extends State<MyHomePage> {
  static const maxCount = 30;
  final scrollDirection = Axis.vertical;
  late AutoScrollController controller;
  final itemListener = ItemPositionsListener.create();
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => counter = 0);
              _scrollToCounter();
            },
            icon: Text('First'),
          ),
          IconButton(
            onPressed: () {
              // setState(() => counter = maxCount - 1);
              // _scrollToCounter();
            },
            icon: Text('Last'),
          ),
        ],
      ),
      body: GridView.builder(
        shrinkWrap: true,
        controller: controller,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemCount: testImage.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              Navigator.of(context)
                  .push(
                    PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => Screen2(
                        imageTest: testImage,
                        currentPageValue: index,
                      ),
                    ),
                  )
                  .then((value) => _scrollToCounter1());
              // _scrollToCounter1(idx);
            },
            child: AutoScrollTag(
              key: ValueKey(index),
              index: index,
              controller: controller,
              child: Hero(
                tag: testImage[index].url,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            CachedNetworkImageProvider(testImage[index].url)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCounter,
        tooltip: 'Increment',
        child: Text(counter.toString()),
      ),
    );
  }

  int counter = -1;
  Future _nextCounter() {
    setState(() => counter = (counter + 1) % maxCount);
    return _scrollToCounter();
  }

  Future _scrollToCounter() async {
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }

  void _scrollToCounter1() {
    // print('_scrollToCounter $counter');
    final idx = context.read<IndexProvider>().getIndexCurrent;
    controller.scrollToIndex(idx,
        duration: const Duration(milliseconds: 1),
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }
}
