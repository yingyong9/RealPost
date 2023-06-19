import 'package:flutter/material.dart';
import 'package:realpost/states/comment_chat.dart';
import 'package:upgrader/upgrader.dart';

class UpgradeAlertPage extends StatelessWidget {
  const UpgradeAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpgradeAlert(
        child: const CommentChat(),
      ),
    );
  }
}
