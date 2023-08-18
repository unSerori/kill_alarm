/**
 * 自分用アラームの設定。
 * 
 * 時間と方法と強度。n分後に追加を設定
 */

import 'package:flutter/material.dart';


class ScreenAccount extends StatelessWidget {
  const ScreenAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(  // ページの中身
      body: Center(
          child: Text('アカウント画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}