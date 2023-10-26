import 'package:flutter/material.dart';
import 'form.dart';

Map<String, FontWeight> weightList = {
  'normal' : FontWeight.w400,
  'bold' : FontWeight.w700,
  'extra-bold' : FontWeight.w800,
};


Text label(String str, String weight, double size, String colorTxt){
  return Text(
      str,
      style: TextStyle(
          color: str2color[colorTxt],
          fontWeight: weightList[weight!],
          fontFamily: 'NanumSquareRound',
          fontSize: size,
        overflow: TextOverflow.ellipsis
      )
  );
}
Text label_notEclipsis(String str, String weight, double size, String colorTxt){
  return Text(
      str,
      style: TextStyle(
          color: str2color[colorTxt],
          fontWeight: weightList[weight!],
          fontFamily: 'NanumSquareRound',
          fontSize: size,

      )
  );
}
