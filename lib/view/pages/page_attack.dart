import 'package:flutter/material.dart';

import '../app.dart';

class ScreenFriends extends StatelessWidget {
  const ScreenFriends({Key? key}) : super(key: key);

  //ClassName squareBox = ClassName();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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