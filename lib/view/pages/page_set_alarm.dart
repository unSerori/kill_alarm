import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app.dart';
import '../constant.dart';
import 'components/custom_Text.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

//box
class boxAlarm extends StatefulWidget {
  const boxAlarm({Key? key}) : super(key: key);
  @override
  _boxAlarm createState() => _boxAlarm();
}

class _boxAlarm extends State<boxAlarm> {
  //設定を保存する変数
  static var call_hour_data = "00";
  static var call_min_data = "00";
  static var name_data = "";
  static var strength_data = "middle";

  // 設定を保存するための配列
  static var timerData = {
    "timers": [
      {
        "call_hour": "00",
        "call_min": "00",
        "payloads": [
          {
            "name": "water",
            "strength": "middle",
            "args": [""]
          },
        ],
        "enabled": true
      }
    ]
  };

  //スイッチの状態
  static bool _bool = true;

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく

    return Container(
      child: Components.whiteBox(
        Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Text('${call_hour_data}:${call_min_data}'),
              //設定時刻表示
              CustomText(
                text:
                    '${call_hour_data}:${call_min_data}', //文字列の結合には${}を使えばいいらしい　そうなの～～～！？！？！？
                fontSize: 60,
                Color: Constant.black,
              ),

              //スイッチ
              CupertinoSwitch(
                  activeColor: Constant.accent_color,
                  value: _bool,
                  onChanged: (value) {
                    setState(() {
                      _bool = value;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end, //右寄せ
            children: [
              //歯車アイコン
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Constant.black,
                  size: 40,
                ),
                onPressed: () {
                  //ページ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PageSetAlarm_2()),
                  );
                },
              )
            ],
          )
        ]),
        _screenSizeWidth,
        bordercolor: Constant.main,
      ),
    );
  }
}

/*
//アラーム部分
class AlarmList extends StatefulWidget {
  const AlarmList({Key? key}) : super(key: key);
  @override
  State<AlarmList> createState() => _AlarmList();
}

class _AlarmList extends State<AlarmList> {
  //時刻 hour
  static List<String> call_hour = ["00"];
  //時刻 min
  static List<String> call_min = ["00"];
  //起こし方
  static List<List<String>> call_type = [
    ["音", "水", "光", "叩く", "振動"]
  ];

  static bool _bool = true;
  static Widget _AlarmListVew() {
    return ListView.builder(
        itemCount: _boxAlarm.timerData.length,
        itemBuilder: (context, index) {
          return Card(
            color: Constant.white,
            elevation: 0,
            child: SizedBox(
                height: 70,
                child: Column(
                  children: [
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomText(
                              text: call_hour[index],
                              fontSize: 40,
                              Color: Constant.black),
                          const CustomText(
                              text: ':', fontSize: 40, Color: Constant.black),
                          CustomText(
                              text: call_min[index],
                              fontSize: 40,
                              Color: Constant.black),
                          // //スイッチ
                          // CupertinoSwitch(
                          //     activeColor: Constant.accent_color,
                          //     value: _bool,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _bool = value;
                          //       });
                          //     }),
                        ]),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 30,
                            color: Constant.main,
                            child: Text(call_type[index][0]),
                          ),
                        ]),
                  ],
                )),
          );
        });
  }
}
*/

//ボタン表示
//動的な動作を実装するためのなんかあれ
//失敗してる
/*
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isButtonPressed = false;
  static String word = '';

  @override
  Widget build(BuildContext context) {
    //メソッドをインスタンスから呼び出す
    return _BottunState("音", widget);
  }

  Widget _BottunState(String word, Widget widget,
      {Color color = Constant.grey, Color subcolor = Constant.sub_color}) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: isButtonPressed ? Constant.sub_color : Constant.main,
            alignment: Alignment.center),
        //ボタンを押したときの動作
        onPressed: () {
          widget;
          setState(() {
            isButtonPressed = !isButtonPressed;
          });
        },
        //中に入る文字
        child: CustomText(
          text: word,
          fontSize: 16,
          Color: Constant.black,
        ),
      ),
    );
  }
}
*/

class PageSetAlarm extends StatefulWidget {
  const PageSetAlarm({Key? key}) : super(key: key);

  @override
  _PageSetAlarmState createState() => _PageSetAlarmState();
}

class _PageSetAlarmState extends State<PageSetAlarm> {
// 初期のウィジェットリスト
  List<Widget> list = <Widget>[
    _boxAlarm(),
    
  ];

  //表示するウィジェットリスト
  List<Widget> _items = <Widget>[];


  @override
  Widget build(BuildContext context) {
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
              //ぼっくす表示
              const boxAlarm(),

              //余白調整
              Container(height: 20, width: 100),

              //+アイコン
              FloatingActionButton(
                backgroundColor: Constant.accent_color,
                onPressed: () {
                  //ページ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageSetAlarm_2()),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//設定画面
class PageSetAlarm_2 extends StatefulWidget {
  const PageSetAlarm_2({Key? key}) : super(key: key);

  @override
  _PageSetAlarmState_2 createState() => _PageSetAlarmState_2();
}

class _PageSetAlarmState_2 extends State<PageSetAlarm_2> {
  //ボタン管理用の変数
  static bool voice = false;
  static bool water = false;
  static bool shine = false;
  static bool panch = false;
  static bool vib = false;

  //ボタン色変更用の変数(敗北者)
  static Color color_voice = Constant.sub_color;
  static Color color_water = Constant.sub_color;
  static Color color_shine = Constant.sub_color;
  static Color color_panch = Constant.sub_color;
  static Color color_vib = Constant.sub_color;

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく

    return Scaffold(
      body: Center(
        // ページの中身
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 80, bottom: 80), //ページそのものの余白調整
          decoration: const BoxDecoration(
            color: Color(0xFFF3FFFB),
          ),
          child: Column(
            children: [
              Row(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //左側の余白
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Constant.black,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 前のページに戻る
                    },
                  ),
                ],
              ),

              Container(height: 100, width: 100),

              //時刻設定box
              InkWell(
                onTap: () {
                  DatePicker.showTimePicker(context,
                      showTitleActions: true,
                      showSecondsColumn: false, onChanged: (date) {
                    setState(() {
                      _boxAlarm.call_hour_data = date.hour.toString();
                    });
                  }, onConfirm: (date) {
                    setState(() {
                      _boxAlarm.call_min_data = date.minute.toString();
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.jp);
                },
                child: Components.whiteBox(
                  Row(children: [
                    Text('時刻設定'),
                    // const CustomText(
                    //   text: '時刻設定',
                    //   fontSize: 20,
                    //   Color: Constant.black
                    //   ),
                    // //時刻表示
                    // CustomText(
                    //   text: '${_boxAlarm.call_hour_data}:${_boxAlarm.call_min_data}',
                    //   fontSize: 60,
                    //   Color: Constant.black
                    // )

                    Text(
                      '${_boxAlarm.call_hour_data}:${_boxAlarm.call_min_data}',
                    ),
                  ]),
                  _screenSizeWidth,
                  bordercolor: Constant.main,
                ),
              ),

              Container(height: 20, width: 100),

              //箱2
              Components.whiteBox(
                Column(children: [
                  const Text('起こし方を選んでね'),

                  //ボタンたち
                  Row(
                    children: [
                      //MyStatefulWidget(),
                      //音
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_voice,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          voice = !voice;
                          setState(() {
                            if (voice) {
                              color_voice = Constant.main;
                            } else {
                              color_voice = Constant.sub_color;
                            }
                          });
                        },
                        child: const CustomText(
                            text: '音', fontSize: 18, Color: Constant.black),
                      ),
                      Spacer(),

                      //水
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_water,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          water = !water;
                          setState(() {
                            if (water) {
                              color_water = Constant.main;
                            } else {
                              color_water = Constant.sub_color;
                            }
                          });
                        },
                        child: const CustomText(
                            text: '水', fontSize: 18, Color: Constant.black),
                      ),
                      Spacer(),

                      //光
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_shine,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          shine = !shine;
                          setState(() {
                            if (shine) {
                              color_shine = Constant.main;
                            } else {
                              color_shine = Constant.sub_color;
                            }
                          });
                        },
                        child: const CustomText(
                            text: '光', fontSize: 18, Color: Constant.black),
                      ),
                      Spacer(),

                      //叩く
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_panch,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          panch = !panch;
                          setState(() {
                            if (panch) {
                              color_panch = Constant.main;
                            } else {
                              color_panch = Constant.sub_color;
                            }
                          });
                        },
                        child: const CustomText(
                            text: '叩く', fontSize: 18, Color: Constant.black),
                      ),
                      Spacer(),

                      //振動
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_vib,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          vib = !vib;
                          setState(() {
                            if (vib) {
                              color_vib = Constant.main;
                            } else {
                              color_vib = Constant.sub_color;
                            }
                          });
                        },
                        child: const CustomText(
                            text: '振動', fontSize: 18, Color: Constant.black),
                      ),
                    ],
                  )
                ]),
                _screenSizeWidth,
                bordercolor: Constant.main,
              ),

              Container(height: 20, width: 100),

              //保存ボタン
              SizedBox(
                width: 100, //横幅
                height: 40, //高さ
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Constant.accent_color,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    // _boxAlarm.timerData.addAll(
                    //   {
                    //     "call_hour": _boxAlarm.call_hour_data,
                    //     "call_min" :_boxAlarm.call_min_data,
                    //     "payloads":[
                    //       {
                    //         "name":""
                    //       }
                    //     ]
                    //   }
                    // );
                    Navigator.pop(context); // 前のページに戻る
                  },
                  child: Text('保存'),
                  //const CustomText(
                  //   text: '保存',
                  //   fontSize: 18,
                  //   Color: Constant.black,
                  // )
                ),
              ),

              Container(height: 20, width: 100),

              //削除ボタン
              SizedBox(
                width: 100, //横幅
                height: 40, //高さ
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Constant.grey,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    //ダイアログ仮置き 書き換え予定
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("本当に削除しても\nいいですか"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text("はい"),
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoDialogAction(
                              child: Text("いいえ"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('削除'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
