import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kill_alarm/view/pages/components/custom_profile_image.dart';
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

  //名前リスト
  final List<String> _nameList = [
    "せろり",
    "大橋",
    "よしたか",
    "松本",
    "やづ",
    "K.Murakami",
    "田島",
    "jinjin",
  ];

  // ユーザー名リスト
  final List<String> _userList = [
    "un_serori",
    "rate980",
    "tapi1226",
    "oshiyarenahuo",
    ".yadu_82",
    "ecc_teacher",
    "9.pi",
    "jinjin2003",
  ];

  // ユーザーの写真リスト
  final List<String> _imageList = [
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
  ];

  // 検索の条件が一致した時に表示させるwidget
  Widget _searchListView() {
    return ListView.builder(
        // 表示させるリストの数を_searchIndexListの要素数に
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(
            color: Constant.sub_color,
            elevation: 0,
            margin: const EdgeInsets.only(
              top: 5,
              right: 45,
              bottom: 5,
              left: 45,
            ),
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  CustomProfileImage(
                      image: _imageList[index],
                      size: 55,
                      top: 0,
                      left: 0,
                      buttom: 0,
                      right: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 13,
                      ),
                      CustomText(
                          text: _nameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 3),
                      CustomText(
                          text: _userList[index],
                          fontSize: 13,
                          Color: Constant.grey),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: 申請ボタンを押した時の処理
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: '申請', fontSize: 12, Color: Constant.white),
                  ),
                ],
              ),
            ),
          );
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
      style: const TextStyle(
        color: Constant.black,
        fontSize: 20,
      ),
      //キーボードのアクションボタンを指定
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
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
        automaticallyImplyLeading: false,
        leading: TextButton(
          child: Icon(Icons.arrow_back_ios, color: Constant.white,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: 90,
        elevation: 5,
        centerTitle: true,
        title: !_searchBoolean
            // 検索モードがオフの時ロゴ表示
            ? Image.asset('assets/logo_yoko.png', height: 18)
            // 検索モードがオンの時検索バー表示
            : _searchTextField(),
        backgroundColor: Constant.main,
        actions: !_searchBoolean
            ? [
                // 検索アイコン
                IconButton(
                  icon: const FaIcon(
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
                  icon: const FaIcon(
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
      body: _searchListView(),

      // TODO: [jin] 時間あればこっちに書き換える
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
