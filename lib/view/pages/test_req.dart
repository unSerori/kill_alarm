/**
 * 鯖とのリクエストのテストファイル。
 * 
 * 
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';


class PageServerReq extends StatelessWidget {
  PageServerReq({Key? key}) : super(key: key);

  // 必要な変数の初期化とIP関連の設定
  static String refToken = "";  // 
  static String accessToken = "";  // 
  static bool isAuthed = false;  // ログイン前提の処理で使う。
  static const String serverIP = "127.0.0.1";  // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"
  static const String server_port = "8000";
  static const String protocol = "http";

  // fieldの中身　ユーザー名とパスワードを取得
  final controllerUserName = TextEditingController();
  final controllerPassword = TextEditingController();

  baseUrl() {
    return protocol + "://" + serverIP + ":" + server_port;
  }
  // ボタンを押したときの処理
  // ろぐいんぼたん
  buttonLogin()async{
    debugPrint(controllerUserName.text); // debug
    debugPrint(controllerPassword.text); // debug
    debugPrint("ぼたんおしちゃったの？！"); // debug
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List logToken = await sendReq(baseUrl() + "/login", "POST", body, "");  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      refToken = jsonDecodeData["refresh_token"].toString();
      accessToken = jsonDecodeData["access_token"].toString();
      debugPrint("02logToken[1]: " + refToken); // debug
      debugPrint("02accessToken[1]: " + accessToken); // debug
      isAuthed = true;
      final Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);
    } else{
      debugPrint("しんじゃった。" + logToken[1]);
      isAuthed = false;

    }
  }

  // さいんあっぷ
  buttonSignup()async{
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List logToken = await sendReq(baseUrl() + "/signup", "POST", body, "");  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      refToken = jsonDecodeData["refresh_token"].toString();
      accessToken = jsonDecodeData["access_token"].toString();
      debugPrint("02logToken[1]: " + refToken);
      debugPrint("02accessToken[1]: " + accessToken);
      isAuthed = true;
    } else{
      debugPrint("しんじゃった。" + logToken[1]);
      isAuthed = false;
    }
  }

  // ぷろふぃーる
  buttonGetProfile()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": ""
    };

    List logToken = await sendReq(baseUrl() + "/get_profile", "GET", body, accessToken);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);
      String userid = jsonDecodeData["userid"].toString();
      String username = jsonDecodeData["username"].toString();
      

      debugPrint("02ゆーざーあいで[1]: " + userid);
      debugPrint("02ゆーざーねーむ[1]: " + username);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
      debugPrint("logToken[2]: " + logToken[2]);
    }
  }

  // 友達爆弾
  buttonWakep()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "friendid": "04f0618a587b99aa25fe0e7c996fca90e29538d4809270c638f061bf2f35f309",  // ともだちのID
      "payloads":[
        {
          "payload_name": "water",
        }
      ]
    };
    
    List logToken = await sendReq(baseUrl() + "/wakeup", "POST", body, accessToken);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      // String userid = jsonDecodeData["userid"].toString();
      // String username = jsonDecodeData["username"].toString();
      // debugPrint("02ゆーざーあいで[1]: " + userid);
      // debugPrint("02ゆーざーねーむ[1]: " + username);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // IoTとの接続
  buttonPairIoT()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "deviceid": "29f4c1d54cdcefff1caec92b4e0c37693a395158a74bea2f3622ad6cb1e38cc520ef34471dd3458d1e4bfc6db1ba33e515fb5f01c6f7e83fb1913c805a25af03"
    };

    List logToken = await sendReq(baseUrl() + "/pair_iot", "POST", body, accessToken);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      // String userid = jsonDecodeData["userid"].toString();
      // String username = jsonDecodeData["username"].toString();
      // debugPrint("02ゆーざーあいで[1]: " + userid);
      // debugPrint("02ゆーざーねーむ[1]: " + username);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }


  // リクエストを投げる万能関数
  sendReq(String reqUrl, String method, Map<String, dynamic> body, String token) async {
    // リクエストのヘッダ
    var headersList = {
      'Accept': '*/*',
      //'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token, 
    };
    // リクエストurlをUri.parse()でuriにパース パース...URLの文字列を役割ごとに分解すること
    var uri = Uri.parse(reqUrl);
      // debugPrint("reqUrl: " + reqUrl);
      // debugPrint("uri: " + uri.toString());
      // debugPrint("uri type: " + uri.runtimeType.toString());

    // リクエスト作成
    var req = http.Request(method, uri);  // HTTPリクエストメソッドの種類とuriから
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

    } catch (e) {  // タイムアウトしたとき。

      return [false, "おうとうないよ；；"];

    }
  }


  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width;  // 画面の大きさを保存しておく

    return Scaffold(  // ページの中身
      body: Container(  // 全体を囲って背景の横幅を100%で統一してる。
        width: double.infinity,
        child: Column(  // 実質の要素はここ(children)で並べてる
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ログイン
            SizedBox(
              width: _screenSizeWidth * 0.8,
              child: TextField(
              controller: controllerUserName,  // 入力内容を入れる
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),  // 枠
                  labelText: "ここはゆーざめいだ。",
                  hintText: "にほんごでおｋ",
                  errorText: "みすってるやで",  // 実際には出したり出さなかったり
                ),
              ),
            ),
            SizedBox(
              width: _screenSizeWidth * 0.8,
              child: TextField(
                controller: controllerPassword,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),  // 枠
                  labelText: "ここはpasswordだ。",
                  hintText: "にほんごでおｋ",
                  errorText: "みすってるやで",  // 実際には出したり出さなかったり
                ),
              ),
            ),
            ElevatedButton(
              onPressed: buttonLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("ろぐいん"),

            // サインあっぷ
            ),
            ElevatedButton(
              onPressed: buttonSignup, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("さいんあっぷ"),
            ),

            // プロファイル
            ElevatedButton(
              onPressed: buttonGetProfile, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("ぷろふぁいる"),
            ),

            // 友達爆弾
            ElevatedButton(
              onPressed: buttonWakep, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("友達爆弾"),
            ),

            // IoTとの紐づけ
            ElevatedButton(
              onPressed: buttonPairIoT, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("IoTとの紐づけ設定"),
            ),
          ],
        ),
      ),
    );
  }
}