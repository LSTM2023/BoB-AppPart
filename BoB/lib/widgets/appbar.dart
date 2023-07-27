import 'package:flutter/material.dart';

AppBar renderAppbar(String title, bool isBack, int colorCode){
  return AppBar(
      automaticallyImplyLeading: isBack,
      backgroundColor: Color(colorCode),
      elevation: 0,
      iconTheme : const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(title,style: TextStyle(color: Color(0xFF512F22),fontSize: 18)),
    shape: Border(
      bottom: BorderSide(
        color: Color(0xB3512F22),
        width: 1,
      ),
    ),
  );
}