/**
 * ふれんど爆弾機能
 * 
 * 起こす相手を選び、何で起こすかを決定し送信
 */

import 'package:flutter/material.dart';
// こんぽーねんと？
import '../app.dart';


class ScreenFriends extends StatelessWidget {
  const ScreenFriends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  // ページの中身
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF3FFFB),
          ),
          child: Column(
            children: [
              const Text(
                      'フレンド爆弾画面',
                      style: TextStyle(fontSize: 32.0),
              ),
              ClassName.square,
            ],
          ),
        ),
      ),
    );
  }
}