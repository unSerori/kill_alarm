/**
 * プロフィールとフレンド機能
 * 
 * プロフィール設定とフレンド機能(一覧と検索)
 */

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
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("うごく？"),
                //設定時刻表示
                // CustomText(
                //   text: '${call_hour_data}:${call_min_data}', //文字列の結合には${}を使えばいいらしい　そうなの～～～！？！？！？
                //   fontSize: 60,
                //   Color: Constant.black,
                // ),

                //スイッチ
                CupertinoSwitch(
                    activeColor: Constant.accent_color,
                    value: _bool,
                    onChanged: (value) {
                      setState(() {
                        _bool = value;
                        //timerData["timers"].add("ひどい");
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
                    //別ページ遷移
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
          ]   
        ),
        _screenSizeWidth,
        bordercolor: Constant.main,
      ),
    );
  }
}

//ボタン表示
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isButtonPressed = false;

  Widget _BottunState(String word, Widget widget,
      {Color color = Constant.grey, Color subcolor = Constant.sub_color}) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isButtonPressed ? Constant.sub_color : Constant.main,
          shape: const StadiumBorder(),
        ),

        //ボタンを押したときの動作
        onPressed: () {
          setState(() {
            isButtonPressed = !isButtonPressed;
          });
        },

        //中に入る文字
        child: CustomText(
          text: word,
          fontSize: 40,
          Color: Constant.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ボタンを表示する部分で_BottunStateを呼び出す
    return _BottunState('水', widget);
  }
}

class PageSetAlarm extends StatefulWidget {
  const PageSetAlarm({Key? key}) : super(key: key);

  @override
  _PageSetAlarmState createState() => _PageSetAlarmState();
}

class _PageSetAlarmState extends State<PageSetAlarm> {
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                const Column(
                  children:[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //MyStatefulWidget(),
                      ],
                    )
                    
                  ]
                ),
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
                  onPressed: () {},
                  child: Text('保存'),
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
                  onPressed: () {},
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
