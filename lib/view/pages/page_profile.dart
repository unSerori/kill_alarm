import 'package:flutter/material.dart';
import '../app.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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

  // 必要な変数の初期化とIP関連の設定
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
  var _channel = WebSocketChannel.connect(
    Uri.parse("ws://" + serverIP + ":" + server_port + "/userws"), 
  );

  // fieldの中身を取得
  final controllerUserName = TextEditingController();  // ユーザー名
  final controllerPassword = TextEditingController();  // パスワード
  final controllerFriendID = TextEditingController(); // debug // フレンド入力 // 実際にはボタン処理ではない


  // ボタンを押したときの処理
  // ろぐいんぼたん  // POST, body username password を使ってログインする。 ついでにWSトークンを取り鯖から設定データをもらう。
  login()async{
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

      telecommunicationsProcessing.refToken = jsonDecodeData["refresh_token"].toString();
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
  logout()async{
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
  signup()async{
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
  getTimer()async{
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
  updateTimer()async{
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
  getProfile()async{
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

  // 友達爆弾  // POST, header accessToken と body friendid payloads を使って友達爆弾をセットする。
  wakeup()async{
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
  pairIoT()async{
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
  unPairIoT()async{
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
  refreshToken()async{
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
  deleteUser()async{
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
  wsMessage(String message) {
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
    }
  }

  // wsのトークン取得
  WsToken()async{
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


  // ws通信で認証をする
  // useridを取得
  getUserid(String username) async {
    var id_data = await sendReq(baseUrl() + "/getId/" + username, "GET", "",{}); 
    
    if (id_data[0]) {
      Map<String,dynamic> decode_data = json.decode(id_data[1]);

      debugPrint(decode_data["userid"].toString());

      return decode_data["userid"].toString();
    }

    return "";
  }

  // フレンドリクエスト
  wsFriendReq()async{//String friendid
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

  // フレンド一覧取得
  getFriends() async {
    // 送る中身
    var data = {
      "msgtype" : "get_friends",
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }

  // リクエスト承認
  acceptRequest() async{
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
  rejectRequest()async{
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
  cancelRequest()async{
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
  removeRriend(String friend_userid)async{
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

  // 受信済みフレンド一覧
  recvedRequests()async{
    // 送る中身
    var data = {
      "msgtype" : "recved_requests",
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }

  // 送信済みフレンド一覧
  sendedRequests()async{
    // 送る中身
    var data = {
      "msgtype" : "sended_requests",
    };
    // 送る
    _channel.sink.add(json.encode(data));
  }




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
//   //image
//   final List<String> _fImageList = [
//     'assets/profile_image.png',
//     'assets/profile_image.png',
//     'assets/profile_image.png',
//   ];

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
        itemCount: getFriends()["friends"].length,
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
                      image: NetworkImage(baseUrl().toString() + "/geticon/" + "a"),
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
                          text: _fNameList[index],
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
