import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kill_alarm/view/constant.dart';
import 'package:kill_alarm/view/pages/components/custom_text.dart';
import 'package:kill_alarm/view/pages/friend_search_page.dart';

import 'components/custom_profile_image.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  // debag
  static const List<Tab> myTabs = <Tab>[
    Tab(child: CustomText(text: 'フレンド', fontSize: 14, Color: Constant.black)),
    Tab(child: CustomText(text: '承認待ち', fontSize: 14, Color: Constant.black)),
    Tab(child: CustomText(text: 'リクエスト', fontSize: 14, Color: Constant.black)),
  ];

  // 自分のプロフィール
  String name = "やづ";
  String username = ".yadu_82";
  String image = "assets/profile_image.png";

// フレンド
  //名前
  final List<String> _fNameList = [
    "せろり",
    "大橋",
    "K.Murakami",
    "田島",
  ];
  //ユーザーネーム
  final List<String> _fUserNameList = [
    "un_serori",
    "rate980",
    "ecc_teacher",
    "9.pi",
  ];
  //image
  final List<String> _fImageList = [
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
  ];

// 承認待ち
  //名前
  final List<String> _awaitNameList = [
    "松本",
    "jinjin",
  ];
  //ユーザーネーム
  final List<String> _awaitUserNameList = [
    "oshiyarenahuo",
    "jinjin2003",
  ];
  //image
  final List<String> _awaitImageList = [
    'assets/profile_image.png',
    'assets/profile_image.png',
  ];

// リクエスト
  //名前
  final List<String> _reqNameList = [
    "よしたか",
  ];
  //ユーザーネーム
  final List<String> _reqUserNameList = [
    "tapi1226",
  ];
  //image
  final List<String> _reqImageList = [
    'assets/profile_image.png',
  ];

  // フレンドwidget
  Widget _friendListView() {
    return ListView.builder(
        itemCount: _fNameList.length,
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
                        height: 15,
                      ),
                      // 名前
                      CustomText(
                          text: _fNameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 5),
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
                                fontSize: 18,
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
                                    onPressed: () {},
                                    child: const CustomText(
                                        text: 'はい',
                                        fontSize: 16,
                                        Color: Constant.white),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.sub_color,
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
                                        fontSize: 16,
                                        Color: Constant.accent_color),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.accent_color,
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
                        height: 15,
                      ),
                      CustomText(
                          text: _awaitNameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 5),
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
                      backgroundColor: Constant.accent_color,
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
                        height: 15,
                      ),
                      CustomText(
                          text: _reqNameList[index],
                          fontSize: 16,
                          Color: Constant.black),
                      const SizedBox(height: 5),
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
                        text: '承認', fontSize: 12, Color: Constant.white),
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
                                fontSize: 18,
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
                                        fontSize: 16,
                                        Color: Constant.white),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constant.sub_color,
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
                                        fontSize: 16,
                                        Color: Constant.accent_color),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 3,
                    ),
                    child: const CustomText(
                        text: '拒否', fontSize: 12, Color: Constant.accent_color),
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
                                    text: name,
                                    fontSize: 23,
                                    Color: Constant.black),
                                CustomText(
                                    text: username,
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
                                SizedBox(
                                  child: TabBarView(
                                    children: [
                                      Scrollbar(child: _friendListView()),
                                      Scrollbar(child: _awaitApprovalListView()),
                                      Scrollbar(child: _requestListView())
                                    ],
                                  ),
                                  height: 310,
                                  width: 320,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ))));
  }
}
