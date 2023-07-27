import 'package:flutter/material.dart';

InputDecoration formDecoration(String title){
  return InputDecoration(
    labelStyle: const TextStyle(color: Color(0x99512f22), fontSize: 14),
    hintStyle: const TextStyle(color: Color(0x99512f22), fontSize: 14),
    hintText: title,
    contentPadding: EdgeInsets.fromLTRB(10, 16.5, 9, 17.5),
    enabled: true,
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(width: 1.5, color: Color(0x4D512F22))
    ),
    //border: InputBorder.none
  );
}

Text makeText(String str, Color clr, double size){
  return Text(
      str,
      style: TextStyle(color: clr, fontSize: size)
  );
}

