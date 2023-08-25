// プロフィール写真を表示するためのウィジェット

import 'package:flutter/material.dart';

import '../../constant.dart';

class CustomProfileImage extends StatelessWidget {
  final String image;
  final double size;
  final double top;
  final double left;
  final double buttom;
  final double right;
  const CustomProfileImage({
    super.key,
    required this.image,
    required this.size,
    required this.top,
    required this.left,
    required this.buttom,
    required this.right
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: size,
      height: size,
      margin: EdgeInsets.only(top: top, left: left, bottom: buttom, right: right),
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
      child: Image.asset(image),
    );
  }
}
