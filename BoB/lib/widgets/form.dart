import 'package:flutter/material.dart';

InputDecoration formDecoration(String title){
  return InputDecoration(
    hintText: title,
    filled: true,
    contentPadding: EdgeInsets.all(17),
    fillColor: Colors.white,
    enabled: true,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey)
    ),
    //border: InputBorder.none
  );
}