import 'package:flutter/material.dart';

Map<String, FontWeight> weightList = {
  'normal' : FontWeight.w400,
  'bold' : FontWeight.w700,
  'extra-bold' : FontWeight.w800,
};
Text text(String str, String weight, double size, Color color){
  return Text(
      str,
      style: TextStyle(
        color: color,
        fontWeight: weightList[weight!],
        fontFamily: 'NanumSquareRound',
        fontSize: size
      )
  );
}

Text TextBase(String str, String weight, double size){
  return Text(
      str,
      style: TextStyle(
          color: const Color(0xff512F22),
          fontWeight: weightList[weight!],
          fontFamily: 'NanumSquareRound',
          fontSize: size
      )
  );
}
