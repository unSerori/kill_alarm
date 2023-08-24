import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color;
  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.Color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      text,
      style: GoogleFonts.kosugiMaru(
        //fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: Color,
      ),
    );
  }
}
