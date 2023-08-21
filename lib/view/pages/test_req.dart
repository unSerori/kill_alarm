/**
 * 鯖とのリクエストのテストファイル。
 * 
 * 
 */

import 'package:flutter/material.dart';


class PageServerReq extends StatelessWidget {
  const PageServerReq({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(  // ページの中身
      body: Center(
          child: Text('アカウント画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}