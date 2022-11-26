import 'package:flutter/material.dart';
import 'package:realpost/utility/app_service.dart';
import 'package:realpost/widgets/widget_button.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WidgetButton(
        label: 'SignOut',
        pressFunc: () {
          AppService().processSignOut();
        },
      ),
    );
  }
}
