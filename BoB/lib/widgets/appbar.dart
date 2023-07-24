import 'package:flutter/material.dart';

AppBar renderAppbar(String title, bool isBack){
  return AppBar(
      automaticallyImplyLeading: isBack,
      backgroundColor: Colors.white,
      elevation: 0.5,
      iconTheme : const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(title,style: TextStyle(color: Colors.black,fontSize: 15))
  );
}