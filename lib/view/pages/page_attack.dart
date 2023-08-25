/**
 * ふれんど爆弾機能
 * 
 * 起こす相手を選び、何で起こすかを決定し送信
 */

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kill_alarm/view/constant.dart';
import 'package:kill_alarm/view/pages/components/custom_text.dart';
// こんぽーねんと？

class PageAttack extends StatefulWidget {
  const PageAttack({Key? key}) : super(key: key);

  @override
  State<PageAttack> createState() => _PageAttackState();
}

class _PageAttackState extends State<PageAttack> {
  // フレンド
  //名前
  final List<String> _fNameList = [
    "せろり",
    "K.Murakami",
    "田島",
  ];
  //ユーザーネーム
  final List<String> _fUserNameList = [
    "un_serori",
    "ecc_teacher",
    "9.pi",
  ];
  //image
  final List<String> _fImageList = [
    'assets/profile_image.png',
    'assets/profile_image.png',
    'assets/profile_image.png',
  ];

  String? selectedValue;

  // 攻撃の種類
  final List<String> _attackName = ["光", "音", "水", "叩く", "振動"];
  List<bool> _onOff = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく
    return Scaffold(
      backgroundColor: Constant.sub_color,
      body: Column(
        children: [
          SizedBox(height: 35),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                  color: Constant.main, //枠線の色
                  width: 4, //太さ
                ),
                backgroundColor: Constant.white,
                elevation: 8,
              ),
              onPressed: () async {},
              child: Container(
                width: _screenSizeWidth * 0.75,
                height: 60,
                child: DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  hint: const CustomText(
                      text: '起こす相手を選んでね', fontSize: 15, Color: Constant.black),
                  items: _fNameList
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: CustomText(
                                text: item,
                                fontSize: 15,
                                Color: Constant.black),
                          ))
                      .toList(),
                  onChanged: (value) {
                    //Do something when selected item is changed.
                  },
                  onSaved: (value) {
                    selectedValue = value.toString();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 15,
                      color: Constant.black,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Constant.white,
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            //height: 500,
            width: 340,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Constant.main),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Constant.light_grey,
                    spreadRadius: 0,
                    blurRadius: 7.0,
                    offset: Offset(0, 5)),
              ],
              color: Constant.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 0, 0),
                  child: CustomText(
                      text: '何で起こす？', fontSize: 15, Color: Constant.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Wrap(
                    spacing: 3,
                    children: <Widget>[
                      // ふぉーぶーん
                      for (int i = 0; i < _attackName.length; i++)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_onOff[i]
                                  ? Constant.sub_color
                                  : Constant.main,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 3,
                            ),
                            onPressed: () {
                              //TODO：ボっタン押した時の処理
                              setState(() {
                                !_onOff[i]
                                    ? _onOff[i] = true
                                    : _onOff[i] = false;
                              });
                            },
                            child: CustomText(
                                text: _attackName[i],
                                fontSize: 13,
                                Color: Constant.black),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            width: 120,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.main,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 3,
              ),
              onPressed: () {
                //TODO：そうしーんっボタン押した時の処理
              },
              child: CustomText(text: '送信', fontSize: 16, Color: Constant.black),
            ),
          ),
        ],
      ),
    );
  }
}
