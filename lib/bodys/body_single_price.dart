import 'package:flutter/material.dart';

class BodySinglePrice extends StatelessWidget {
  const BodySinglePrice({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return SizedBox(
        
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: const Text('single Price'),
      );
    });
  }
}
