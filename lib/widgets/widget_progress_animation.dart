import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WidgetProgessAnimation extends StatelessWidget {
  const WidgetProgessAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.flickr(
          leftDotColor: Colors.red, rightDotColor: Colors.white, size: 50),
    );
    // return Center(
    //     child:
    //         LoadingAnimationWidget.bouncingBall(color: Colors.white, size: 60));
  }
}
