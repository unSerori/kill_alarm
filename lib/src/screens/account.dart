import 'package:flutter/material.dart';

class ScreenAccount extends StatelessWidget {
  const ScreenAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('アカウント画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}