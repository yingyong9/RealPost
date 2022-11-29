import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realpost/utility/app_constant.dart';

class EmojiPage extends StatefulWidget {
  const EmojiPage({super.key});

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  @override
  void initState() {
    super.initState();
    readAllEmoji();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.bgColor,
      appBar: AppBar(),
    );
  }
  
  Future<void> readAllEmoji() async {
    
  }
}
