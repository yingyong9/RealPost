import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WidgetProgessAnimation extends StatelessWidget {
  const WidgetProgessAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: LoadingAnimationWidget.flickr(
    //       leftDotColor: Colors.pink, rightDotColor: Colors.blue, size: 60),
    // );
    return Center(
        child:
            LoadingAnimationWidget.bouncingBall(color: Colors.white, size: 60));
  }
}
