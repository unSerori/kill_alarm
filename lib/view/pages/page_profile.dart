import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kill_alarm/view/constant.dart';
import 'package:kill_alarm/view/pages/components/custom_text.dart';
import 'package:kill_alarm/view/pages/friend_search_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ページの中身
      backgroundColor: Constant.sub_color,
      body: Column(
        children: [
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constant.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, //色
                      spreadRadius: 0, //影の大きさ
                      blurRadius: 4.0, //影の不透明度
                      offset: Offset(0, 4), //x軸とy軸のずらし具合
                    ),
                  ],
                ),
                child: Image.asset('assets/profile_image.png'),
              ),
              //SizedBox(width: 0),
              Column(
                children: [
                  SizedBox(height: 10),
                  CustomText(
                      text: '神 さくら', fontSize: 23, Color: Constant.black),
                  SizedBox(
                    width: 230,
                    child: Divider(
                      height: 20,
                      thickness: 2,
                      indent: 25,
                      endIndent: 0,
                      color: Constant.black,
                    ),
                  ),
                  CustomText(
                      text: 'Jin2003', fontSize: 19, Color: Constant.grey),
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
              side: BorderSide(
                color: Constant.main,
                width: 3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30) //こちらを適用
              ),
              elevation: 6,
              ),
              
            child: Container(
              width: 280,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.search, color: Constant.black),
                  FaIcon(FontAwesomeIcons.magnifyingGlass, color: Constant.black, size: 20,),
                  SizedBox(width: 8),
                  CustomText(text: 'フレンド検索', fontSize: 16, Color: Constant.black),
                ],
              ),
            ),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) =>
                              FriendSearchPage())),
                    );
            },
          ),
          SizedBox(height: 30,),
          DefaultTabController(
            length: 3, 
            child: Container(
              width: 320,

              color: Constant.sub_color,
              child: TabBar(
                indicatorColor: Constant.black,
                tabs: myTabs
              ),
            )
          ),
        ],
      ),
    );
  }
}
