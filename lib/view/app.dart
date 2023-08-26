/**
 * MaterialAppと_MyStatefulWidgetState
 * 
 * Centerは押されたナビバーの項目に応じて遷移先からもらってくる。
 */

import 'package:flutter/material.dart';
// ページ遷移先をいんぽーと
import 'constant.dart';
import 'pages/page_attack.dart';
import 'pages/page_profile.dart';
import 'pages/page_set_alarm.dart';
import 'pages/test_req.dart';
// その他必要なファイル
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // でばっぐの表示を消す
      title: 'おまころ！',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatefulWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  MyWidget({super.key});

  // 必要な変数の初期化とIP関連の設定
  // httpTokens
  static String refToken = "";  // 
  static String accessToken = "";  // 
  static var friendList = {};
  // static Map<String, dynamic> timerData = {};
  static Map<String, dynamic> timerData = {
  "timers" : [
    {
      "call_hour":"09",
      "call_min" : "00",
      "payloads":[
        {
          "name" : "water",
          "strength" : "high",
          "args" : [""]
        },
        {
          "name" : "light",
          "strength" : "low",
          "args" : [""]
        },
        {
          "name" : "blow",
          "strength" : "middle",
          "args" : [""]
        }
      ],
      "enabled":true
    }
  ]
};
  // ws
  static String requestid = "";
  static bool wsTokenAuth = false;
  // ログイン前提の処理で使う。
  static bool isAuthed = false;  
  // URLとかポートとかプロトコルとか
  static const String serverIP = "127.0.0.1";  // "127.0.0.1""10.200.0.82""tidalhip.local""10.200.0.115"10.25.10.10710.200.0.163
  static const String server_port = "8000";
  static const String protocol = "http";
  static baseUrl() {  // 鯖のURLを設定
    return protocol + "://" + serverIP + ":" + server_port;
  }
  // ws通信の接続先を指定
  static var _channel = WebSocketChannel.connect(
    Uri.parse("ws://" + serverIP + ":" + server_port + "/userws"), 
  );

  // fieldの中身を取得
  static final controllerUserName = TextEditingController();  // ユーザー名
  static final controllerPassword = TextEditingController();  // パスワード
  static final controllerFriendID = TextEditingController(); // debug // フレンド入力 // 実際にはボタン処理ではない


  // ボタンを押したときの処理
  // ろぐいんぼたん  // POST, body username password を使ってログインする。 ついでにWSトークンを取り鯖から設定データをもらう。
  static login()async{
    debugPrint(controllerUserName.text); // debug
    debugPrint(controllerPassword.text); // debug
    debugPrint("ぼたんおしちゃったの？！"); // debug
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List sendReqRes = await sendReq(baseUrl() + "/login", "POST", "", body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      refToken = jsonDecodeData["refresh_token"].toString();
      accessToken = jsonDecodeData["access_token"].toString();
      debugPrint("02sendReqRes[1]: " + refToken); // debug
      debugPrint("02accessToken[1]: " + accessToken); // debug
      isAuthed = true;
      final Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);
      await WsToken();
      await getTimer();
      // if(!WsToken()) {  // ログインが成功したらWSTokenもとってくる。
      //   debugPrint("WSTokenとれなかったぜ；；");
      // }
      // if(!getTimer()){  // 失敗したらreturn
      //   debugPrint("ログイン時のデータ取得できなかったぜ；；");
      // }
    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
      isAuthed = false;
    }
  }
  
  // ろぐあうと  // POST, header refToken を使ってろぐあうとする。
  static logout()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List sendReqRes = await sendReq(baseUrl() + "/logout", "POST", refToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // さいんあっぷ  // POST, body username password を使ってユーザー情報を設定しサインアップする。
  static signup()async{
    debugPrint(controllerUserName.text);
    debugPrint(controllerPassword.text);
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "username" : controllerUserName.text,
      "password" : controllerPassword.text,
    };
    List sendReqRes = await sendReq(baseUrl() + "/signup", "POST", "", body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      refToken = jsonDecodeData["refresh_token"].toString();
      accessToken = jsonDecodeData["access_token"].toString();
      debugPrint("02sendReqRes[1]: " + refToken);
      debugPrint("02accessToken[1]: " + accessToken);
      isAuthed = true;
    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
      isAuthed = false;
    }
  }

  // ログイン時に鯖にデータを問い合わせる。
  static getTimer()async{
    debugPrint("ぼたんおしちゃったの？！"); // debug
    var body = {
      "" : "",
    };
    List sendReqRes = await sendReq(baseUrl() + "/get_timer", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("sendReqRes: " + sendReqRes.toString());
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);  // [0]の真偽値を覗いてでコード

      // debugPrint("02sendReqRes[1]: " + refToken); // debug
      // debugPrint("02accessToken[1]: " + accessToken); // debug
      isAuthed = true;  // 
      //final Map<String, dynamic> decodedToken = Jwt.parseJwt(accessToken);
      try {
        debugPrint("timerData");  
        timerData = jsonDecodeData["timer_data"];
        debugPrint(timerData.toString());
      }catch (ex) {
        debugPrint("error");
        debugPrint(ex.toString());
      }
    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
      isAuthed = false;
    }
  }

  // 設定時に鯖にデータをぶち込む
  static updateTimer()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = timerData;  // タイマーの設定データ

    debugPrint(timerData.toString());

    List sendReqRes = await sendReq(baseUrl() + "/update_timer", "POST", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("status: " + status);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // ぷろふぃーる  // GET, header accessToken を使ってプロフィール(useridとusername)を取得する。
  static getProfile()async{
    if (!isAuthed) {
      debugPrint("Authentication.");
      return;
    }
    // body
    var body = {
      "": ""
    };

    List sendReqRes = await sendReq(baseUrl() + "/get_profile", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);
      String userid = jsonDecodeData["userid"].toString();
      String username = jsonDecodeData["username"].toString();   
      debugPrint("userid: " + userid);
      debugPrint("username: " + username);
      return sendReqRes[1];
    } else{
      debugPrint("No response. " + sendReqRes[1]);
      debugPrint("sendReqRes[2]: " + sendReqRes[2]);
      return sendReqRes[1];
    }
  }

  // フレンド一覧  // GET, header accessToken を使ってプロフィール(useridとusername)を取得する。
  static getFriends()async{
    if (!isAuthed) {
      debugPrint("Authentication.");
      return;
    }
    // body
    var body = {
      "": ""
    };

    List sendReqRes = await sendReq(baseUrl() + "/get_friends", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);
      String userid = jsonDecodeData["userid"].toString();
      String username = jsonDecodeData["username"].toString();   
      debugPrint("userid: " + userid);
      debugPrint("username: " + username);
      return sendReqRes[1];
    } else{
      debugPrint("No response. " + sendReqRes[1]);
      debugPrint("sendReqRes[2]: " + sendReqRes[2]);
      return sendReqRes[1];
    }
  }

  // 承認待ち  // GET, header accessToken を使ってプロフィール(useridとusername)を取得する。
  static getRecvdRequests()async{
    if (!isAuthed) {
      debugPrint("Authentication.");
      return;
    }
    var body = {
      "": ""
    };

    List sendReqRes = await sendReq(baseUrl() + "/get_recvd_requests", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);
      String userid = jsonDecodeData["userid"].toString();
      String username = jsonDecodeData["username"].toString();   
      debugPrint("userid: " + userid);
      debugPrint("username: " + username);
      return sendReqRes[1];
    } else{
      debugPrint("No response. " + sendReqRes[1]);
      debugPrint("sendReqRes[2]: " + sendReqRes[2]);
      return sendReqRes[1];
    }
  }

  // 承認待ち  // GET, header accessToken を使ってプロフィール(useridとusername)を取得する。
  static getSendedRequests()async{
    if (!isAuthed) {
      debugPrint("Authentication.");
      return;
    }
    // body
    var body = {
      "": ""
    };

    List sendReqRes = await sendReq(baseUrl() + "/get_sended_requests", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);
      String userid = jsonDecodeData["userid"].toString();
      String username = jsonDecodeData["username"].toString();   
      debugPrint("userid: " + userid);
      debugPrint("username: " + username);
      return sendReqRes[1];
    } else{
      debugPrint("No response. " + sendReqRes[1]);
      debugPrint("sendReqRes[2]: " + sendReqRes[2]);
      return sendReqRes[1];
    }
  }



  // 友達爆弾  // POST, header accessToken と body friendid payloads を使って友達爆弾をセットする。
  static wakeup()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "friendid": "04f0618a587b99aa25fe0e7c996fca90e29538d4809270c638f061bf2f35f309",  // ともだちのID
      "payloads":[
        {
          "p　ｍｍｍｍンんンんンんンんンんンんンんンんンんンんンayload_name": "water",
        }
      ]
    };
    
   List sendReqRes = await sendReq(baseUrl() + "/wakeup", "POST", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      // Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      // String userid = jsonDecodeData["userid"].toString();
      // String username = jsonDecodeData["username"].toString();
      // debugPrint("02ゆーざーあいで[1]: " + userid);
      // debugPrint("02ゆーざーねーむ[1]: " + username);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // IoTとの接続  // POST, header accessToken と body deviceid を使ってIoTと接続する。
  static pairIoT()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "deviceid": "3b5872465adda1a3c165b52bef1e5d544c8a13463e626fd3d74799ff00396d8314346797616fe22084e4edf82a96efcae0e3d4c39649a6b5f454b5d9c9ff812b"
    };

    List sendReqRes = await sendReq(baseUrl() + "/pair_iot", "POST", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String msgtype = jsonDecodeData["msgtype"].toString();
      String message = jsonDecodeData["message"].toString();
      String msgcode = jsonDecodeData["msgcode"].toString();
      String deviceid = jsonDecodeData["deviceid"].toString();
      debugPrint("02せいこうかしっぱい[1]: " + msgtype);
      debugPrint("02めっせじ[1]: " + message);
      debugPrint("02めっせじこーど[1]: " + msgcode);
      debugPrint("02でばいすあいでぃ[1]: " + deviceid);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // IoTとの接続解除  // POST, header accessToken を使ってIoTとの接続を解除。
  static unPairIoT()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List sendReqRes = await sendReq(baseUrl() + "/unpair_iot", "POST", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String msgtype = jsonDecodeData["msgtype"].toString();
      String message = jsonDecodeData["message"].toString();
      String msgcode = jsonDecodeData["msgcode"].toString();
      debugPrint("02せいこうかしっぱい[1]: " + msgtype);
      debugPrint("02めっせじ[1]: " + message);
      debugPrint("02めっせじこーど[1]: " + msgcode);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // れふれっしゅとーくん  // GET, header refToken を使ってaccesstokenを生成しなおす
  static refreshToken()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List sendReqRes = await sendReq(baseUrl() + "/refresh_token", "GET", refToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // ユーザー登録削除  // DELETE, header refToken を使ってアカウント情報を削除。
  static deleteUser()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": "",
    };

    List sendReqRes = await sendReq(baseUrl() + "/delete_user", "DELETE", refToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);

      String status = jsonDecodeData["status"].toString();
      debugPrint("02すていたす[1]: " + status);

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
    }
  }

  // // アイコン変更  // POST, header ？ を使ってアイコンを変更。
  // Future<List<int>> getImageBytes(String iconPath) async {
  //   File imageFile = File(iconPath);  // 画像ファイルのパスを指定してください
  //   return await imageFile.readAsBytes();
  // }
  // Future<void>  Icon() async {
  //   List<int> imageBytes = await getImageBytes("C:\\Users\\2230105\\Desktop\\flutter\\test_project1\\assets\\images\\test.png");
  //   debugPrint("shine");

  //   debugPrint(imageBytes.toString());
  //   // サーバーのエンドポイントURLを指定してください
  //   var uri = Uri.parse(PageServerReq.baseUrl() + "/change_icon");

  //   var request = http.MultipartRequest('POST', uri);
  //   request.files.add(http.MultipartFile.fromBytes('image', imageBytes,
  //       filename: 'image.jpg'));  // サーバー側で使用するファイル名を指定してください

  //   // 任意のヘッダーを設定する場合
  //   request.headers['Authorization'] = 'Bearer ' + PageServerReq.accessToken;

  //   var response = await request.send();
    
  //   if (response.statusCode == 200) {
  //     print('Image uploaded successfully');
  //   } else {
  //     print('Image upload failed with status code: ${response.statusCode}');
  //   }
  // }

  // changeIcon()async{
  //   if (!isAuthed) {
  //     debugPrint("認証しろあほ");
  //     return;
  //   }
  //   debugPrint("ぼたんおしちゃったの？！");

    
    // var headersList = {
    //   'Accept': '*/*',
    //   'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    //   'Content-Type': 'application/octet-stream', 
    //   'Authorization': 'Bearer ' + accessToken, 
    // };
    // // リクエストurlをUri.parse()でuriにパース パース...URLの文字列を役割ごとに分解すること
    // var uri = Uri.parse(baseUrl() + "/change_icon").toString();

    // // 使うファイルのパスを指定
    // var iconPath = File("C:\\Users\\2230105\\Desktop\\flutter\\test_project1\\assets\\images\\test.png");

    // // パスで指定したファイルでリクエストを作成
    // var request = http.MultipartRequest('POST', Uri.parse(uri));
    // request.files.add(await http.MultipartFile.fromPath('image', selectedImage.path));
    // // リクエスト作成
    // var req = http.Request(method, uri);  // HTTPリクエストメソッドの種類とuriから
    //   // debugPrint(req.toString());
    // req.headers.addAll(headersList);  // header情報を追加
    //   // debugPrint(req.toString());
    // req.body = json.encode(body);  // bodyをjson形式に変換
    //   // debugPrint(req.toString());

    // try {

    //   // HTTPリクエストを送信。 seconds: 5 で指定した秒数応答がなかったらタイムアウトで例外を発生させる
    //   var res = await req.send().timeout(const Duration(seconds: 5));
    //   // レスポンスをストリームから文字列に変換して保存
    //   final resBody = await res.stream.bytesToString();

    //   // ステータスコードが正常ならtrueと内容を返す
    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     // return [true, resBody];
    //   debugPrint("01sendReqRes[1]: " + [true, resBody][1].toString());
    //   Map<String, dynamic> jsonDecodeData = json.decode([true, resBody][1].toString());

    //   String status = jsonDecodeData["status"].toString();
    //   debugPrint("02すていたす[1]: " + status);

    //   } else {
    //     // return [false, res.statusCode.toString(), resBody];
    //     debugPrint("しんじゃった。" + [false, res.statusCode.toString(), resBody][1].toString());
    //   }

    // } catch (e) {  // タイムアウトしたとき。

    //   // return [false, "おうとうないよ；；"];
    //   debugPrint("しんじゃった。" + [false, "おうとうないよ；；"][1].toString());

    // }
    //}

  //Websocketメッセージ
  static wsMessage(String message) {
    debugPrint("ここが鯖から届いためっせーじ: " + message.toString());
    Map<String,dynamic> decode_dict = json.decode(message.toString());

    switch (decode_dict["msgcode"].toString()) {
      case "11131":  // sent a friend request
        requestid = decode_dict["requestid"].toString();
        break;
      case "11110":  // 認証失敗
        wsTokenAuth = false;
      case "11111":  // 認証成功
        wsTokenAuth = true;
        break;
      case "11144":  // フレンド一覧通知
        friendList = decode_dict["friends"];
        
    }
  }

  // wsのトークン取得
  static WsToken()async{
    if (!isAuthed) {
      debugPrint("認証しろあほ");
      return;
    }
    debugPrint("ぼたんおしちゃったの？！");
    var body = {
      "": ""
    };

    List sendReqRes = await sendReq(baseUrl() + "/ws_token", "GET", accessToken, body);  // 

    if (sendReqRes[0]) {
      debugPrint(sendReqRes.toString());
      debugPrint("01sendReqRes[1]: " + sendReqRes[1]);
      Map<String, dynamic> jsonDecodeData = json.decode(sendReqRes[1]);
      String wsToken = jsonDecodeData["token"].toString();
      
      debugPrint("うぇぶそけっとのとーくん[1]: " + wsToken);
     
      // ws通信で認証をする
      // 受信する
/*       try {
        _channel.sink.close();
      } catch (ex) {
        
      }

      _channel = WebSocketChannel.connect(
        Uri.parse("ws://" + serverIP + ":" + server_port + "/userws"), 
      );
      try {
        _channel.stream.listen((message) {
          wsMessage(message);
        });
      } catch (ex) {
      }
 */   
      _channel = WebSocketChannel.connect(
        Uri.parse("ws://" + serverIP + ":" + server_port + "/userws"), 
      );
      _channel.stream.listen((message) {
        wsMessage(message);
      });

      // 送る中身
      var authMsg = {
          "msgtype" : "authToken",
          "token" : wsToken,
      };

      // 送る
      _channel.sink.add(json.encode(authMsg));

    } else{
      debugPrint("しんじゃった。" + sendReqRes[1]);
      debugPrint("sendReqRes[2]: " + sendReqRes[2]);
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


  // ws通信で認証をする
  // useridを取得
  static getUserid(String username) async {
    var id_data = await sendReq(baseUrl() + "/getId/" + username, "GET", "",{}); 
    
    if (id_data[0]) {
      Map<String,dynamic> decode_data = json.decode(id_data[1]);

      debugPrint(decode_data["userid"].toString());

      return decode_data["userid"].toString();
    }

    return "";
  }

  // フレンドリクエスト
  static wsFriendReq()async{//String friendid
    // friendidを取る
    String friend_userid = await getUserid(controllerFriendID.text);
    if(friend_userid.isEmpty) {
      debugPrint("ユーザーが存在しません。");
      return;  // 早期リターン
    }

    debugPrint(friend_userid);
    debugPrint(controllerFriendID.text);

    // 送る中身
    var friendReq = {
      "msgtype" : "friend_request",
      "friendid" : friend_userid, //friendid
    };
    // 送る
    _channel.sink.add(json.encode(friendReq)); 
  }

  // // フレンド一覧取得
  // static getFriends() async {
  //   // 送る中身
  //   var data = {
  //     "msgtype" : "get_friends",
  //   };
  //   // 送る
  //   _channel.sink.add(json.encode(data));
  // }

  // リクエスト承認
  static acceptRequest() async{
    // friendidを取る
    String friend_userid = await getUserid(controllerFriendID.text);
    if(friend_userid.isEmpty) {
      debugPrint("ユーザーが存在しません。");
      return;  // 早期リターン
    }

    // 送る中身
    var data = {
      "msgtype": "accept_request",
      "accept_request": friend_userid,
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }
  
  // リクエスト拒否
  static rejectRequest()async{
    // friendidを取る
    String friend_userid = await getUserid(controllerFriendID.text);
    if(friend_userid.isEmpty) {
      debugPrint("ユーザーが存在しません。");
      return;  // 早期リターン
    }

    // 送る中身
    var data = {
      "msgtype": "reject_request",
      "reject_request": friend_userid,
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }

  // キャンセルリクエスト
  static cancelRequest()async{
    // friendidを取る
    String friend_userid = await getUserid(controllerFriendID.text);
    if(friend_userid.isEmpty) {
      debugPrint("ユーザーが存在しません。");
      return;  // 早期リターン
    }

    // 送る中身
    var data = {
      "msgtype": "reject_request",
      "reject_request": friend_userid,
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }

  // フレンド削除
  static removeRriend(String friend_userid)async{
    // friendidを取る
    if(friend_userid.isEmpty) {
      debugPrint("User does not exist.");
      return;  // 早期リターン
    }

    // 送る中身
    var data = {
      "msgtype": "remove_friend",
      "remove_friend": friend_userid,
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }


  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Components {
  // こんぽーねんと？

  // widgetはColumnやRowを想定してるよ。
  static Widget whiteBox(
    Widget widget,
    double _screenSizeWidth, {
    double widthRatio = 0.8,
    double widthRatsio = 0.8,
    double paddingHor = 10,
    double paddingVer = 25,
  }) {
    return Container(
      width: _screenSizeWidth * widthRatio,
      padding:
          EdgeInsets.symmetric(horizontal: paddingHor, vertical: paddingVer),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, //色
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: widget, // BOXの中に配置するWidget
    );
  }

  static final square = Container(  // 白いぼっくす

    width: 200,
    height: 200,
    decoration: BoxDecoration(
      color: Constant.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
  );
}

class MyStatefulWidget extends StatefulWidget {
  // アプリケーションの動的なUIの作成と更新？
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // ページをリストに入れる。
  static final _screens = [
    const PageAttack(),
    const PageSetAlarm(),
    //const PageProfile(),
    PageServerReq(),
  ];

  // ページをインデックスで指定するための変数を初期化。デフォルトで1(真ん中のページ)
  int _selectedIndex = 1;

  // ナビバーの項目が変更されたらindexを更新
  void _onItemTapped(int index) {
    setState(() {
      // lambda式  // setStateで状態を更新
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // AppBar
          backgroundColor: Constant.main,
          toolbarHeight: 90,
          centerTitle: true,
          title: Image.asset('assets/logo_yoko.png', height: 18),
          //backgroundColor: Colors.blue,
        ),
        body: _screens[_selectedIndex], // ページを入力されたインデックスで指定

        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex, // 現在のインデックスから項目を指定？
        animationDuration: const Duration(seconds: 1),
        elevation: 6,
        height: 90,
        backgroundColor: Constant.main,
        indicatorColor: const Color.fromARGB(121, 251, 255, 253),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const <Widget>[
          NavigationDestination(
              icon: ImageIcon(
                    AssetImage('assets/icons/bomb_icon.png'),
                    color: Constant.black,
                  ),
                  label: 'attack',
                  
          ),
          NavigationDestination(icon: ImageIcon(
                    AssetImage('assets/icons/alarm_icon.png'),
                    color: Constant.black,
                  ),
                  label: 'alarm'),
           NavigationDestination(
              icon: ImageIcon(
                    AssetImage('assets/icons/user_icon.png'),
                    color: Constant.black,
                    size: 22,
                  ),
                  label: 'profile'),
          //  NavigationDestination(
          //     icon: ImageIcon(
          //           AssetImage('assets/icons/user_icon.png'),
          //           color: Constant.black,
          //           size: 22,
          //         ),
          //         label: 'profile'),
        ],
      ),


        // NavBar のデザイン変更しました
        // bottomNavigationBar: Container(
        //   height: 90,
        //   child: BottomNavigationBar(
        //     // ナビバー
        //     currentIndex: _selectedIndex, // 現在のインデックスから項目を指定？
        //     selectedFontSize: 0,
        //     onTap: _onItemTapped, // タップされたときに関数を呼び出し、画面を更新
        //     backgroundColor: Constant.main, // ナビバーの背景色
        //     items: const <BottomNavigationBarItem>[
        //       // ナビバーの項目を並べる
              // BottomNavigationBarItem(
              //     icon: ImageIcon(
              //       AssetImage('assets/icons/bomb_icon.png'),
              //       color: Constant.white,
              //       size: 35,
              //     ),
              //     label:
              //         'attack'), // ここでIcons.hogeはflutter環境に用意されているアイコン  // labelはアイコンの下に表示
              // BottomNavigationBarItem(
              //     icon: ImageIcon(
              //       AssetImage('assets/icons/alarm_icon.png'),
              //       color: Constant.white,
              //       size: 35,
              //     ),
              //     label: 'alarm'),
              // BottomNavigationBarItem(
              //     tooltip: null,
              //     icon: ImageIcon(
              //       AssetImage('assets/icons/user_icon.png'),
              //       color: Constant.white,
              //       size: 30,
                  // ),
                  // label: 'profile'),
        //     ],
        //     type: BottomNavigationBarType.fixed, // アイテムを均等に配置
        //   ),
        // )
        );
  }
}
// github通知テスト 