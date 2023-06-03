import 'package:flutter/material.dart';
import 'package:realpost/states/main_page_view.dart';
import 'package:upgrader/upgrader.dart';

class UpgradeAlertPage extends StatelessWidget {
  const UpgradeAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        child: const MainPageView(),
      ),
    );
  }
}
