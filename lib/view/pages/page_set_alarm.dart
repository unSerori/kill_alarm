/**
 * プロフィールとフレンド機能
 * 
 * プロフィール設定とフレンド機能(一覧と検索)
 */

import 'package:flutter/material.dart';


class PageAlarm extends StatelessWidget {
  const PageAlarm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(  // ページの中身
      body: Center(
          child: Text('アラーム画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}