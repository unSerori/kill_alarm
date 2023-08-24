import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kill_alarm/view/pages/components/custom_text.dart';

import '../constant.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({super.key});

  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  // 検索モードのオンオフ
  bool _searchBoolean = true;
  // 検索された文字が含まれるリストのindexを入れる変数
  List<int> _searchIndexList = [];

  // ユーザーリスト
  List<String> _userList = [
    "あすか",
    "よしたか",
    "松本",
    "うちはら",
    "村上",
    "田島",
    "神",
  ];

  // 検索オフの時に表示させるwidget
  Widget _defaultListView() {
    return ListView.builder(
        itemCount: _userList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Constant.main,
            elevation: 0,
            margin: EdgeInsets.only(
              top: 10, //上
              right: 40, //右
              bottom: 5, //下
              left: 40, //左
            ),
            child: Container(
              height: 70,
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: 55,
                    height: 55,
                    margin: EdgeInsets.only(left: 20, right: 10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constant.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //色
                          spreadRadius: 0, //影の大きさ
                          blurRadius: 4.0, //影の不透明度
                          offset: Offset(0, 4), //x軸とy軸のずらし具合
                        ),
                      ],
                    ),
                    child: Image.asset('assets/profile_image.png'),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      CustomText(
                          text: _userList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      Text(
                        textAlign: TextAlign.left,
                        _userList[index],
                        style: GoogleFonts.kosugiMaru(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Constant.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  // 検索の条件が一致した時に表示させるwidget
  Widget _searchListView() {
    return ListView.builder(
        // 表示させるリストの数を_searchIndexListの要素数に
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(child: ListTile(title: Text(_userList[index])));
        });
  }

  // 検索バーのwidget
  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        //TextFieldに変化があったら
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < _userList.length; i++) {
            if (_userList[i].contains(s)) {
              _searchIndexList.add(i);
            }
          }
        });
      },
      // 自動でキーボード表示
      autofocus: true,
      cursorColor: Constant.black,
      style: TextStyle(
        color: Constant.black,
        fontSize: 20,
      ),
      //キーボードのアクションボタンを指定
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'user name',
        hintStyle: TextStyle(
          //hintTextのスタイル
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 5,
        centerTitle: true,
        title: !_searchBoolean
            // 検索モードがオフの時ロゴ表示
            ? Image.asset('assets/logo.png', height: 30)
            // 検索モードがオンの時検索バー表示
            : _searchTextField(),
        backgroundColor: Constant.main,
        actions: !_searchBoolean
            ? [
                // 検索アイコン
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                      _searchIndexList = [];
                    });
                  },
                )
              ]
            : [
                // ばつアイコン
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  },
                )
              ],
      ),
      backgroundColor: Constant.sub_color,

      // 検索オンとオフで表示の切り替え
      body: !_searchBoolean ? _defaultListView() : _searchListView(),

      // body: Center(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 200),
      //       Container(
      //         width: 300,
      //         height: 50,
      //         decoration: BoxDecoration(
      //           color: Constant.white,
      //           //border: Border.all(color: Constant.main, width: 3),
      //           borderRadius: BorderRadius.circular(30),
      //           boxShadow: [
      //             BoxShadow(
      //               spreadRadius: 0,
      //               blurRadius: 4.0,
      //               color: Colors.grey,
      //               offset: Offset(0, 4),
      //             )
      //           ],
      //         ),
      //         padding: const EdgeInsets.only(left: 20, top: 3, right: 14),
      //         child: Container(
      //           //width: 250,
      //           child: TextField(
      //             decoration: InputDecoration(
      //               suffixIcon: Icon(
      //                 Icons.search,
      //                 color: Constant.black,
      //                 size: 28,
      //               ),
      //               border: InputBorder.none,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
