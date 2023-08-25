/**
 * MaterialAppと_MyStatefulWidgetState
 * 
 * Centerは押されたナビバーの項目に応じて遷移先からもらってくる。
 */

import 'package:flutter/material.dart';
// ページ遷移先をいんぽーと
import 'pages/page_attack.dart';
import 'pages/page_profile.dart';
import 'pages/page_set_alarm.dart';
// その他必要なファイル
import 'constant.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // でばっぐの表示を消す
      title: 'おまころ！',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class Componentsful extends StatefulWidget {
  const Componentsful({super.key});
  
  @override
  _Componentsful createState() => _Componentsful();


  static Widget typeButton(String word,bool typebool,Function(bool) onTap,{Color typecolor = Constant.sub_color,}){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: typecolor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          elevation: 3,
        ),
        onPressed: () {
          onTap(!typebool);
        },
        // child:  CustomText(
        //   text: word, fontSize: 18, Color: Constant.black
        // ),
        child: Text("aho"),
      );
  }
}

class _Componentsful extends State<Componentsful> {
  bool isTypeButtonPressed = false;

  void _handleTypeButtonTap(bool newValue) {
    setState(() {
      isTypeButtonPressed = newValue;
    });
  }  
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Componentsless {
  // こんぽーねんと？

  // widgetはColumnやRowを想定してるよ。
  static Widget whiteBox(Widget widget, double _screenSizeWidth,
      {double widthRatio = 0.8,
      double widthRatsio = 0.8,
      double paddingHor = 10,
      double paddingVer = 25,
      Color bordercolor = Colors.white}) {
    return Container(
      width: _screenSizeWidth * widthRatio,
      padding:
          EdgeInsets.symmetric(horizontal: paddingHor, vertical: paddingVer),
      decoration: BoxDecoration(
        border: Border.all(
          color: bordercolor,
          width: 5,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, //色
            //spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: widget, // BOXの中に配置するWidget
    );
  }

  static final square = Container(
    // 白いぼっくす
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      color: Constant.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
  );
}

class MyStatefulWidget extends StatefulWidget {
  // アプリケーションの動的なUIの作成と更新？
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // ページをリストに入れる。
  static const _screens = [
    PageAttack(),
    PageSetAlarm(),
    PageProfile(),
  ];

  // ページをインデックスで指定するための変数を初期化。デフォルトで1(真ん中のページ)
  int _selectedIndex = 1;

  // ナビバーの項目が変更されたらindexを更新
  void _onItemTapped(int index) {
    setState(() {
      // lambda式  // setStateで状態を更新
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // AppBar
          backgroundColor: Constant.main,
          //backgroundColor: Colors.blue,
        ),
        body: _screens[_selectedIndex], // ページを入力されたインデックスで指定

        bottomNavigationBar: BottomNavigationBar(
          // ナビバー
          currentIndex: _selectedIndex, // 現在のインデックスから項目を指定？
          onTap: _onItemTapped, // タップされたときに関数を呼び出し、画面を更新
          backgroundColor: const Color(0xFFAEEEEA), // ナビバーの背景色
          items: const <BottomNavigationBarItem>[
            // ナビバーの項目を並べる
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label:
                    'フレンド'), // ここでIcons.hogeはflutter環境に用意されているアイコン  // labelはアイコンの下に表示
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'アラーム設定'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
          type: BottomNavigationBarType.fixed, // アイテムを均等に配置
        ));
  }
}
// github通知テスト
