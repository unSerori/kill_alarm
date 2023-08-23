/**
 * 鯖とのリクエストのテストファイル。
 * 
 * 
 */

import 'package:flutter/material.dart';
import 'dart:io';
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
  baseUrl() {  // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }


  // ボタンを押したときの処理
  // ろぐいんぼたん  // POST, body username password を使ってログインする。
  buttonLogin()async{
    debugPrint(controllerUserName.text); // debug
    debugPrint(controllerPassword.text); // debug
    debugPrint("ぼたんおしちゃったの？！"); // debug
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List logToken = await sendReq(baseUrl() + "/login", "POST", "", body);  // 

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
  
  // ろぐあうと  // POST, header refToken を使ってろぐあうとする。
  buttonLogout()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List logToken = await sendReq(baseUrl() + "/logout", "POST", refToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // さいんあっぷ  // POST, body username password を使ってユーザー情報を設定しサインアップする。
  buttonSignup()async{
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List logToken = await sendReq(baseUrl() + "/signup", "POST", "", body);  // 

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

  // ぷろふぃーる  // GET, header accessToken を使ってプロフィール(useridとusername)を取得する。
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

    List logToken = await sendReq(baseUrl() + "/get_profile", "GET", accessToken, body);  // 

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

  // 友達爆弾  // POST, header accessToken と body friendid payloads を使って友達爆弾をセットする。
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
    
    List logToken = await sendReq(baseUrl() + "/wakeup", "POST", accessToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      // Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      // String userid = jsonDecodeData["userid"].toString();
      // String username = jsonDecodeData["username"].toString();
      // debugPrint("02ゆーざーあいで[1]: " + userid);
      // debugPrint("02ゆーざーねーむ[1]: " + username);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // IoTとの接続  // POST, header accessToken と body deviceid を使ってIoTと接続する。
  buttonPairIoT()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "deviceid": "3b5872465adda1a3c165b52bef1e5d544c8a13463e626fd3d74799ff00396d8314346797616fe22084e4edf82a96efcae0e3d4c39649a6b5f454b5d9c9ff812b"
    };

    List logToken = await sendReq(baseUrl() + "/pair_iot", "POST", accessToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      String msgtype = jsonDecodeData["msgtype"].toString();
      String message = jsonDecodeData["message"].toString();
      String msgcode = jsonDecodeData["msgcode"].toString();
      String deviceid = jsonDecodeData["deviceid"].toString();
      debugPrint("02せいこうかしっぱい[1]: " + msgtype);
      debugPrint("02めっせじ[1]: " + message);
      debugPrint("02めっせじこーど[1]: " + msgcode);
      debugPrint("02でばいすあいでぃ[1]: " + deviceid);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // IoTとの接続解除  // POST, header accessToken を使ってIoTとの接続を解除。
  buttonUnPairIoT()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List logToken = await sendReq(baseUrl() + "/unpair_iot", "POST", accessToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      String msgtype = jsonDecodeData["msgtype"].toString();
      String message = jsonDecodeData["message"].toString();
      String msgcode = jsonDecodeData["msgcode"].toString();
      debugPrint("02せいこうかしっぱい[1]: " + msgtype);
      debugPrint("02めっせじ[1]: " + message);
      debugPrint("02めっせじこーど[1]: " + msgcode);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // れふれっしゅとーくん  // GET, header refToken を使ってaccesstokenを生成しなおす
  buttonRefreshToken()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List logToken = await sendReq(baseUrl() + "/refresh_token", "GET", refToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // ユーザー登録削除  // DELETE, header refToken を使ってアカウント情報を削除。
  buttonDeleteUser()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List logToken = await sendReq(baseUrl() + "/delete_user", "DELETE", refToken, body);  // 

    if (logToken[0]) {
      debugPrint("01logToken[1]: " + logToken[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(logToken[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + logToken[1]);
    }
  }

  // アイコン変更  // POST, header ？ を使ってアイコンを変更。
  buttonChangeIcon()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");

    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Content-Type': 'application/octet-stream', 
      'Authorization': 'Bearer ' + accessToken, 
    };

    // リクエストurlをUri.parse()でuriにパース パース...URLの文字列を役割ごとに分解すること
    var uri = Uri.parse(baseUrl() + "/change_icon");

    // 使うファイルのパスを指定
    var iconPath = File("C:\\Users\\2230105\\Desktop\\flutter\\test_project1\\assets\\images\\test.png");
    // パスで指定したファイルをバイナリに変換
    final response = await multipart(
      method: 'POST',
      url: uri,
      files: [
        http.MultipartFile.fromBytes(
          'file',
          iconPath.readAsBytesSync(),
        ),
      ],
    );

    print(response.statusCode);
    print(response.body);
  }

  Future<http.Response> multipart({
    required String method,
    required Uri url,
    required List<http.MultipartFile> files,
  }) async {
    final request = http.MultipartRequest(method, url);

    request.files.addAll(files); // 送信するファイルのバイナリデータを追加
    request.headers.addAll({'Authorization': 'Bearer ' + accessToken,'Content-Type': 'application/json'}); // 認証情報などを追加

    final stream = await request.send();

    return http.Response.fromStream(stream).then((response) {
      if (response.statusCode == 200) {
        return response;
      }

      return Future.error(response);
    });
  }

  // リクエストを投げる万能関数
  sendReq(String reqUrl, String method, String bearer, Map<String, dynamic> body) async {
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
            ),
            
            // ろぐあうと
            ElevatedButton(
              onPressed: buttonLogout, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("ろぐあうと"),
            ),

            // サインあっぷ
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

            // IoTとの紐づけ解除
            ElevatedButton(
              onPressed: buttonUnPairIoT, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("IoTとの紐づけ解除"),
            ),

            // れふれっしゅとーくん
            ElevatedButton(
              onPressed: buttonRefreshToken, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("れふれっしゅとーくん"),
            ),

            // ユーザー登録削除
            ElevatedButton(
              onPressed: buttonDeleteUser, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("ユーザー登録削除"),
            ),

            // アイコン変更
            ElevatedButton(
              onPressed: buttonChangeIcon, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text("アイコン変更"),
            ),

          ],
        ),
      ),
    );
  }
}