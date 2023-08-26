import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../app.dart';
import '../constant.dart';
import 'components/custom_Text.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // 設定を保存するための配列の初期化
  static var timerData = {
    "timers": [
      {
        "call_hour": call_hour_data,
        "call_min": call_min_data,
        "payloads": [
          {
            "name": "water",
            "strength": "middle",
            "args": [""]
          }
        ],
        "enabled": _bool
      }
    ]
  };

  // URLとかポートとかプロトコルとか
  static const String serverIP =
      "127.0.0.1"; // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.163
  static const String server_port = "8000";
  static const String protocol = "http";
  static baseUrl() {
    // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }

// リクエストを投げる万能関数
  sendReq(String reqUrl, String method, String bearer,
      Map<String, dynamic> body) async {
    // リクエストのヘッダ
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + bearer,
    };
    // リクエストurlをUri.parse()でuriにパース パース...URLの文字列を役割ごとに分解すること
    var uri = Uri.parse(reqUrl);
    // debugPrint("reqUrl: " + reqUrl);
    // debugPrint("uri: " + uri.toString());
    // debugPrint("uri type: " + uri.runtimeType.toString());

    // リクエスト作成
    var req = http.Request(method, uri); // HTTPリクエストメソッドの種類とuriから
    // debugPrint(req.toString());
    req.headers.addAll(headersList); // header情報を追加
    // debugPrint(req.toString());
    req.body = json.encode(body); // bodyをjson形式に変換
    // debugPrint(req.toString());

    try {
      // HTTPリクエストを送信。 seconds: 5 で指定した秒数応答がなかったらタイムアウトで例外を発生させる
      var res = await req.send().timeout(const Duration(seconds: 5));
      // レスポンスをストリームから文字列に変換して保存
      final resBody = await res.stream.bytesToString();

      // ステータスコードが正常ならtrueと内容を返す
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return [true, resBody];
      } else {
        return [false, res.statusCode.toString(), resBody];
      }
    } catch (e) {
      // タイムアウトしたとき。

      return [false, "おうとうないよ；；"];
    }
  }

  //スイッチの状態
  static bool _bool = true;

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく
    return Container(
      child: Componentsless.whiteBox(
        Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
              Wrap(
                children: [
                  //選択している種類の表示
                  ComponentsAttack.Widget("音", _PageSetAlarmState_2.sound),
                  ComponentsAttack.Widget("水", _PageSetAlarmState_2.water),
                  ComponentsAttack.Widget("光", _PageSetAlarmState_2.light),
                  ComponentsAttack.Widget("叩く", _PageSetAlarmState_2.blow),
                  ComponentsAttack.Widget("振動", _PageSetAlarmState_2.vibration),
                ],
              ),

              //歯車アイコン
              SizedBox(
                child: IconButton(
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
                    ).then((value) {
                      //戻ってきたら再描画
                      setState(() {});
                    });
                  },
                ),
              ),
              Container(height: 20, width: 20), //スペース
            ],
          )
        ]),
        _screenSizeWidth,
        bordercolor: Constant.main,
      ),
    );
  }
}

//whiteboxに入れる 有効になっているおこしかた
class ComponentsAttack {
  static Widget(String word, bool typeVool) {
    if (typeVool) {
      return Container(
        width: 50,
        height: 25,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Constant.main,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, //色
              //spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CustomText(text: word, fontSize: 16, Color: Constant.black),
      );
    } else {
      return Container();
    };
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
          child: const Column(
            children: [
              //ぼっくす表示
              boxAlarm(),

              // //余白調整
              // Container(height: 20, width: 100),
              // //+アイコン
              // FloatingActionButton(
              //   backgroundColor: Constant.accent_color,
              //   onPressed: () {
              //     //ページ遷移
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => PageSetAlarm_2()),
              //     ).then((value){
              //       setState(() {});
              //     }
              //     );
              //   },
              //   child: const Icon(Icons.add),
              // ),
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
  // ログイン前提の処理で使う。
  static bool isAuthed = false;  
  //ボタン管理用の変数
  static bool sound = false;
  static bool water = false;
  static bool light = false;
  static bool blow = false;
  static bool vibration = false;

  //ボタン色変更用の変数(敗北者)
  static Color color_sound = Constant.sub_color;
  static Color color_water = Constant.sub_color;
  static Color color_light = Constant.sub_color;
  static Color color_blow = Constant.sub_color;
  static Color color_vibration = Constant.sub_color;

  set_payload() {
    final timersList = _boxAlarm.timerData["timers"] as List<dynamic>;

    final lastTimer = timersList.isNotEmpty ? timersList.last : null;

    //debugPrint("設定島￣￣￣￣￣￣￣￣￣￣￣￣￣素");
    if (lastTimer != null &&
        lastTimer is Map<String, dynamic> &&
        lastTimer["payloads"] is List<dynamic>) {
      for (int i = 0; i < lastTimer["payloads"].length; i++) {
        Map<String, dynamic> payload_info = lastTimer["payloads"][i];

        setState(() {
          if (payload_info["name"] == "sound") {
            color_sound = Constant.main;
            sound = true;
          }
          if (payload_info["name"] == "light") {
            color_light = Constant.main;
            light = true;
          }
          if (payload_info["name"] == "water") {
            color_water = Constant.main;
            water = true;
          }
          if (payload_info["name"] == "vibration") {
            color_vibration = Constant.main;
            vibration = true;
          }
          if (payload_info["name"] == "blow") {
            color_blow = Constant.main;
            blow = true;
          }
        });
      }
    }
  }

  update_payload() {
    
    if (_boxAlarm.timerData["timers"] != null) {
      final timersList = _boxAlarm.timerData["timers"] as List<dynamic>;
      final lastTimer = timersList.isNotEmpty ? timersList.last : null;
      if (lastTimer != null &&
          lastTimer is Map<String, dynamic> &&
          lastTimer["payloads"] is List<dynamic>) {
        List<Map<String, dynamic>> add_list = [];
        if (sound) {
          add_list.add({
            "name": "sound",
            "strength": "middle",
            "args": [""]
          });
        }
        if (water) {
          add_list.add({
            "name": "water",
            "strength": "middle",
            "args": [""]
          });
        }
        if (light) {
          add_list.add({
            "name": "light",
            "strength": "middle",
            "args": [""]
          });
        }

        if (blow) {
          add_list.add({
            "name": "blow",
            "strength": "middle",
            "args": [""]
          });
        }

        if (vibration) {
          add_list.add({
            "name": "vibration",
            "strength": "middle",
            "args": [""]
          });
        }
        lastTimer["payloads"] = add_list;

        if (!isAuthed) {
          debugPrint("認証しろあほ");
          return;
        }
        debugPrint("ぼたんおしちゃったの？！");
        var body = _boxAlarm.timerData;  // タイマーの設定データ

        debugPrint(_boxAlarm.timerData.toString());

        List sendReqRes = sendReq(MyWidget.baseUrl() + "/update_timer", "POST", MyWidget.accessToken, body);  // 

        if (sendReqRes[0]) {
          debugPrint("sendReqRes[1]: " + sendReqRes[1]);
          Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

          String status = jsonDecodeData["status"].toString();
          debugPrint("status: " + status);

        } else{
          debugPrint("しんじゃった。" + sendReqRes[1]);
        }
      }
    }
  }

    // リクエストを投げる万能関数
  static sendReq(String reqUrl, String method, String bearer, Map<String, dynamic> body) async {
    // リクエストのヘッダ
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + bearer, 
    };
    // リクエストurlをUri.parse()でuriにパース パース...URLの文字列を役割ごとに分解すること
    var uri = Uri.parse(reqUrl);
      // debugPrint("reqUrl: " + reqUrl);
      // debugPrint("uri: " + uri.toString());
      // debugPrint("uri type: " + uri.runtimeType.toString());

    // リクエスト作成
    var req = http.Request(method, uri);  // HTTPリクエストメソッドの種類とuriから
      // debugPrint(req.toString());
    req.headers.addAll(headersList);  // header情報を追加
      // debugPrint(req.toString());
    req.body = json.encode(body);  // bodyをjson形式に変換
      // debugPrint(req.toString());

    try {

      // HTTPリクエストを送信。 seconds: 5 で指定した秒数応答がなかったらタイムアウトで例外を発生させる
      var res = await req.send().timeout(const Duration(seconds: 5));
      // レスポンスをストリームから文字列に変換して保存
      final resBody = await res.stream.bytesToString();

      // ステータスコードが正常ならtrueと内容を返す
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return [true, resBody];
      } else {
        return [false, res.statusCode.toString(), resBody];
      }

    } catch (e) {  // タイムアウトしたとき。

      return [false, "おうとうないよ；；"];

    }
  }


  @override
  void initState() {
    set_payload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width; // 画面の大きさを保存しておく

    //set_payload();
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
                child: Componentsless.whiteBox(
                  Row(children: [
                    Container(height: 20, width: 10),
                    //Text('時刻設定'),
                    //Spacer(),
                    const CustomText(
                        text: '時刻設定', fontSize: 20, Color: Constant.black),
                    Spacer(),
                    //時刻表示
                    CustomText(
                        text:
                            '${_boxAlarm.call_hour_data}:${_boxAlarm.call_min_data}',
                        fontSize: 30,
                        Color: Constant.black),

                    Container(height: 20, width: 10),
                  ]),
                  _screenSizeWidth,
                  bordercolor: Constant.main,
                ),
              ),

              Container(height: 20, width: 100),

              //箱2
              Componentsless.whiteBox(
                Column(children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft, //左寄せ
                    child: CustomText(
                        text: "起こし方を選んでね", fontSize: 16, Color: Constant.black),
                  ),

                  //冗長的なボタンたち
                  Wrap(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color_sound,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          sound = !sound;
                          setState(() {
                            if (sound) {
                              color_sound = Constant.main;
                            } else {
                              color_sound = Constant.sub_color;
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
                          backgroundColor: color_light,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          light = !light;
                          setState(() {
                            if (light) {
                              color_light = Constant.main;
                            } else {
                              color_light = Constant.sub_color;
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
                          backgroundColor: color_blow,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          blow = !blow;
                          setState(() {
                            if (blow) {
                              color_blow = Constant.main;
                            } else {
                              color_blow = Constant.sub_color;
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
                          backgroundColor: color_vibration,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          vibration = !vibration;
                          setState(() {
                            if (vibration) {
                              color_vibration = Constant.main;
                            } else {
                              color_vibration = Constant.sub_color;
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

                    //押したときの処理
                    //jsonの追加
                    onPressed: () {
                      //建設予定地
                      update_payload();
                      Navigator.pop(context); // 前のページに戻る
                    },
                    child: const CustomText(
                      text: '保存',
                      fontSize: 16,
                      Color: Constant.white,
                    )),
              ),

              /*
              必要なくなったのでコメントアウトしました
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
              */
            ],
          ),
        ),
      ),
    );
  }
}
