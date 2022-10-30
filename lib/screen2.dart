import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  Screen2({super.key, required this.currentPageValue});
  final int currentPageValue;
  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.currentPageValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        controller: controller,
        itemCount: 100,
        itemBuilder: (context, index) {
          return Image.network('https://source.unsplash.com/random?sig=$index');
        },
      ),
    );
  }
}
