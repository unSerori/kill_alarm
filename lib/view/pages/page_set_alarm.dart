import 'package:flutter/material.dart';

class ScreenAlarm extends StatelessWidget {
  const ScreenAlarm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('アラーム画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}