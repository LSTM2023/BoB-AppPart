import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool validateEmail(String email){
  var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if(email.isEmpty || !RegExp(emailFormat).hasMatch(email)){
    return false;
  }
  return true;
}
bool validatePassword(String pass){
  if(pass.isEmpty || pass.length<8) {
    return false;
  }
  return true;
}