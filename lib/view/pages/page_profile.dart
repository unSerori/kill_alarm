import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kill_alarm/view/constant.dart';
import 'package:kill_alarm/view/pages/components/custom_text.dart';
import 'package:kill_alarm/view/pages/friend_search_page.dart';
import '../app.dart';

import 'components/custom_profile_image.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {




  static const List<Tab> myTabs = <Tab>[
    Tab(child: CustomText(text: 'フレンド', fontSize: 14, Color: Constant.black)),
    Tab(child: CustomText(text: '承認待ち', fontSize: 14, Color: Constant.black)),
    Tab(child: CustomText(text: 'リクエスト', fontSize: 14, Color: Constant.black)),
  ];

  // 自分のプロフィール
  // String name = "やづ";
  // String username = ".yadu_82";
  String image = "assets/profile_image.png";
  // Map<String, String> myProfiel = {};

  // フレンド一覧
  static var friendList = {};
  // static var friendList = {
  //   "msgcode": "11144", 
  //   "friends": [
  //     {
  //       "friendid": "", 
  //       "friend_userid": "8ffc99a0e2421f2a2e70c97c8af8ae00d5f185233ff5d74f2bbec8f890d323c5", 
  //       "friend_username": "test1", 
  //       "friend_displayname": "test1", 
  //       "friended_at": 1692986587.197176
  //     }
  //   ]
  // };
  // 承認待ち
  static var approvalList = {};
  // {
  //   "msgcode": "11146", 
  //   "requests": {
  //     "ff19472cb2772c1f3e9fdf08266d16aa4f63621014dd425d85e85f054c9f7e8d": {
  //       "friend_UserName": "test3",
  //        "friend_DisplayName": "test3", 
  //        "friend_UserId": "b0d79dcfefb32e9a0bf21599d153a325f7b5e6657376bc627c04e6ee04d0d891"
  //     }
  //   }
  // }
  // リクエスト
  static var freReqList = {};
  // {
  //   "msgcode": "11146", 
  //   "requests": {
  //     "a2bd192fc42f95019385e1e68403d338e5d8faf057bc43671f83826f352eaaa6": {
  //       "friend_UserName": "test2",
  //       "friend_DisplayName": "test2",
  //       "friend_UserId": "086e42a1578061ca395b2ff17f060cd1d5d8970891b7cfc18b00b1f2b10086b6"
  //     }
  //   }
  // }


//   // フレンド
//   //名前
//   final List<String> _fNameList = [
//     "せろり",
//     "K.Murakami",
//     "田島",
//   ];
//   //ユーザーネーム
//   final List<String> _fUserNameList = [
//     "un_serori",
//     "ecc_teacher",
//     "9.pi",
//   ];
  //image
  final List<String> _fImageList = [
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
  ];

// // 承認待ち
//   //名前
//   final List<String> _awaitNameList = [
//     "松本",
//     "jinjin",
//   ];
//   //ユーザーネーム
//   final List<String> _awaitUserNameList = [
//     "oshiyarenahuo",
//     "jinjin2003",
//   ];
//   //image
//   final List<String> _awaitImageList = [
//     'assets/profile_image.png',
//     'assets/profile_image.png',
//   ];

// // リクエスト
//   //名前
//   final List<String> _reqNameList = [
//     "よしたか",
//   ];
//   //ユーザーネーム
//   final List<String> _reqUserNameList = [
//     "tapi1226",
//   ];
//   //image
//   final List<String> _reqImageList = [
//     'assets/profile_image.png',
//   ];

  // フレンドwidget
  Widget _friendListView() {
    return ListView.builder(
        itemCount: MyWidget.getFriends()["friends"].length,
        itemBuilder: (context, index) {
          return Card(
            color: Constant.sub_color,
            elevation: 0,
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  //写真
                  CustomProfileImage(
                      //image: NetworkImage(MyWidget.baseUrl() + "/geticon/" + "a"),
                      image: _fImageList[index],
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
                      // 名前
                      CustomText(
                          text: _fImageList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 3),
                      // ユーザーネーム
                      CustomText(
                          text: _fUserNameList[index],
                          fontSize: 13,
                          Color: Constant.grey),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      // 削除ボタン押した時のダイアログ
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: Constant.white,
                            title: const CustomText(
                                text: "本当に削除しますか？",
                                fontSize: 20,
                                Color: Constant.black),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.accent_color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 3,
                                    ),
                                    //TODO: フレンドを削除する時の処理
                                    onPressed: removeRriend(),
                                    child: const CustomText(
                                        text: 'はい',
                                        fontSize: 18,
                                        Color: Constant.white),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.light_grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 3,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const CustomText(
                                        text: 'いいえ',
                                        fontSize: 18,
                                        Color: Constant.white),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.light_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: '削除', fontSize: 12, Color: Constant.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // 承認待ちwidget
  Widget _awaitApprovalListView() {
    return ListView.builder(
        itemCount: _awaitNameList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Constant.sub_color,
            elevation: 0,
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  CustomProfileImage(
                      image: _awaitImageList[index],
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
                          text: _awaitNameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 3),
                      CustomText(
                          text: _awaitUserNameList[index],
                          fontSize: 13,
                          Color: Constant.grey),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: キャンセルボタン押した時の処理
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.light_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: 'キャンセル', fontSize: 10, Color: Constant.white),
                  ),
                ],
              ),
            ),
          );
        });
  }


  // リクエストwidget
  Widget _requestListView() {
    return ListView.builder(
        itemCount: _reqNameList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Constant.sub_color,
            elevation: 0,
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  CustomProfileImage(
                      image: _reqImageList[index],
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
                          text: _reqNameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 3),
                      CustomText(
                          text: _reqUserNameList[index],
                          fontSize: 13,
                          Color: Constant.grey),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: フレンド承認した時の処理
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: '承認', fontSize: 13, Color: Constant.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: Constant.white,
                            title: const CustomText(
                                text: "このユーザーを拒否しますか？",
                                fontSize: 20,
                                Color: Constant.black),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.accent_color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 3,
                                    ),
                                    //TODO: 承認を拒否する時の処理
                                    onPressed: () {},
                                    child: const CustomText(
                                        text: 'はい',
                                        fontSize: 18,
                                        Color: Constant.white),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.light_grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      elevation: 3,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const CustomText(
                                        text: 'いいえ',
                                        fontSize: 18,
                                        Color: Constant.white),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.light_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: '拒否', fontSize: 13, Color: Constant.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ページの中身
        backgroundColor: Constant.sub_color,
        body: Builder(
            //キーボード表示した時のレイアウト崩れ防止
            builder: ((context) => SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        (Scaffold.of(context).appBarMaxHeight ?? 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 30),
                            CustomProfileImage(
                                image: image,
                                size: 80,
                                top: 0,
                                left: 20,
                                buttom: 0,
                                right: 10),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                CustomText(
                                    text: getProfile()["userid"],
                                    fontSize: 23,
                                    Color: Constant.black),
                                CustomText(
                                    text: getProfile()["username"],
                                    fontSize: 19,
                                    Color: Constant.grey),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //minimumSize: Size(300, 50),
                            backgroundColor: Constant.white,
                            foregroundColor: Constant.black,
                            side: const BorderSide(
                              color: Constant.main,
                              width: 3,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30) //こちらを適用
                                ),
                            elevation: 6,
                          ),
                          child: const SizedBox(
                            width: 280,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: Constant.black,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                CustomText(
                                    text: 'フレンド検索',
                                    fontSize: 16,
                                    Color: Constant.black),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => FriendSearchPage())),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                Container(
                                  width: 320,
                                  color: Constant.sub_color,
                                  child: TabBar(
                                    indicatorColor: Constant.black,
                                    tabs: myTabs,
                                  ),
                                ),
                                Scrollbar(
                                  child: SizedBox(
                                    child: TabBarView(
                                      children: [
                                        _friendListView(),
                                        _awaitApprovalListView(),
                                        _requestListView()
                                      ],
                                    ),
                                    height: 310,
                                    width: 320,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ))));
  }
}
