import 'dart:html';

import 'package:flutter/material.dart';

Text textInfo(
    String text, FontWeight? fontWeight, Color? color, double? fontSize) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize),
  );
}
