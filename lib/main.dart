//Copyright (C) 2019 Potix Corporation. All Rights Reserved.
//History: Tue Apr 24 09:29 CST 2019
// Author: Jerry Chen

import 'dart:math' as math;

import 'package:example/screen2.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll To Index Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Scroll To Index Grid'),
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

class _MyHomePageState extends State<MyHomePage> {
  static const maxCount = 100;
  final random = math.Random();
  final scrollDirection = Axis.vertical;

  late AutoScrollController controller;

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
              setState(() => counter = maxCount - 1);
              _scrollToCounter();
            },
            icon: Text('Last'),
          )
        ],
      ),
      body: GridView.builder(
        shrinkWrap: true,
        controller: controller,
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemCount: maxCount,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Screen2(
                    currentPageValue: index,
                  ),
                ),
              );
            },
            child: AutoScrollTag(
              key: ValueKey(index),
              index: index,
              controller: controller,
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://source.unsplash.com/random?sig=$index',
                    ),
                  )),
                ),
                Text('$index')
              ]),
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

//khi pop screen 2 goi func nay
  Future _scrollToCounter() async {
    await controller.scrollToIndex(counter,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(counter);
  }
}
