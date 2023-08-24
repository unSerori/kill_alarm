/**
 * ふれんど爆弾機能
 * 
 * 起こす相手を選び、何で起こすかを決定し送信
 */

import 'package:flutter/material.dart';
// こんぽーねんと？
import '../app.dart';
import '../constant.dart';

class PageAttack extends StatelessWidget {
  const PageAttack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく

    return Scaffold(
      body: Center(
        // ページの中身
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(40),
          decoration: const BoxDecoration(
            color: Color(0xFFF3FFFB),
          ),
          child: Column(
            children: [
              //箱１
              Components.whiteBox(
                const Column(
                  children: [
                    Text("起こす相手を選んでね"),
                  ],
                ),
                _screenSizeWidth, // 横幅の大きさ
                bordercolor: Constant.main,
              ),

              //余白調整
              Container(height: 20, width: 100),

              //箱２
              Components.whiteBox(
                const Column(
                  children: [
                    Text("何で起こす？"),

                    //ボタン
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('ここにボタン入れたかった'),
                          //MyStatefulWidget(),
                      ]         
                    ),
                  ],
                ),
                _screenSizeWidth, // 横幅の大きさ
                bordercolor: Constant.main,
              ),

              //余白調整
              Container(height: 20, width: 100),

              //送信ボタン
              SizedBox(
                width: 100, //横幅
                height: 40, //高さ
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Constant.accent_color,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: Text('送信'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
