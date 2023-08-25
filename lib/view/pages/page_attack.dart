/**
 * ふれんど爆弾機能
 * 
 * 起こす相手を選び、何で起こすかを決定し送信
 */

import 'package:flutter/material.dart';
// こんぽーねんと？
import '../app.dart';


class PageAttack extends StatelessWidget {
  const PageAttack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width;  // 画面の大きさを保存しておく

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
              //ClassName.square,
              //ClassName.whiteBox(),
              //ClassName.hoge(Text("hoge")),
              //ClassName.hoge(Text("piyo")),

              Components.whiteBox(
                const Column(
                  children: [
                    Text("[ここが呼び出したぼっくすだ。]"),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("[Components.whiteBox(うぃじぇっと, 横幅の大きさ)]"),
                        Text("[やったぜ]"),
                      ],
                    )
                  ],
                ),
                _screenSizeWidth,  // 横幅の大きさ
              ),

              //ClassName.hoge(),
              //Container(),
/*               ClassName.whiteBox(
                _screenSize, 
                const Column(
                  Text("hoge"),
                  Text("hoge"),
                ),
              ),
 */            
            ],
          ),
        ),
      ),
    );
  }
}