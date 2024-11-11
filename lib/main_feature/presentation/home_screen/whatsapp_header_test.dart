// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WhatsAppHeaderExample extends StatefulWidget {
  const WhatsAppHeaderExample({super.key});

  @override
  _WhatsAppHeaderExampleState createState() => _WhatsAppHeaderExampleState();
}

class _WhatsAppHeaderExampleState extends State<WhatsAppHeaderExample> {
  final ScrollController _scrollController = ScrollController();
  double _headerHeight = 70.0;

  double _initialScrollPosition = 0.0;

  ScrollDirection _previousScrollSense = ScrollDirection.reverse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            _handleScroll();
          }
          return true;
        },
        child: Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message $index'),
                );
              },
            ),
            AnimatedContainer(
              height: _headerHeight,
              color: Colors.blue,
              duration: const Duration(milliseconds: 200),
              child: const Center(
                child: Text(
                  'Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (_scrollController.position.userScrollDirection !=
        _previousScrollSense) {
      debugPrint("Current scroll: $currentScroll");
      setState(() {
        _initialScrollPosition = currentScroll;
      });
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      final scrollDelta = currentScroll - _initialScrollPosition;
      const scrollRange = 30.0;
      final Tween<double> tweenRange = Tween<double>(begin: 70.0, end: 10.0);

      setState(() {
        _previousScrollSense = ScrollDirection.reverse;
        _headerHeight =
            tweenRange.lerp((scrollDelta / scrollRange).clamp(0.0, 1.0));
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      final scrollDelta = currentScroll - _initialScrollPosition;
      const scrollRange = 30.0;
      final tweenRange = Tween<double>(begin: 70.0, end: 10.0);

      setState(() {
        _previousScrollSense = ScrollDirection.forward;
        _headerHeight =
            tweenRange.lerp((scrollDelta / scrollRange).clamp(0.0, 1.0));
      });
    }

    // }

    // final scrollDelta = currentScroll - _initialScrollPosition;
    // final scrollRange = 30.0;
    //
    // setState(() {
    //   _headerHeight = lerpDouble(
    //     10.0,
    //     70.0,
    //     scrollDelta.clamp(0.0, scrollRange) / scrollRange,
    //   )!;
    // });
  }
}
