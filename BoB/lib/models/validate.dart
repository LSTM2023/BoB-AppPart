import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool validateEmail(String email){
  var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if(email.isEmpty || !RegExp(emailFormat).hasMatch(email)) return false;
  return true;
}
bool validatePassword(String pass){
  if(pass.isEmpty || pass.length<8) return false;
  return true;
}
bool validateBabyName(String nickname){
  if(nickname.isEmpty) return false;
  return true;
}
bool validatePhone(String phone){
  if(phone.isEmpty) return false;
  if(phone.length != 12 && phone.length != 13) return false;
  return true;
}
bool validateBirth(DateTime birth){
  return (birth.isAfter(DateTime.now())) ? false : true;
}
bool validateName(String name){
  if(name.isEmpty || name.length<3) {
    return false;
  }
  return true;
}
bool validateGender(String gender){
  if(gender != 'F' && gender != 'M'){
    return false;
  }
  return true;
}

bool validateQaType(int type){
  if(type < 0 || 5 < type){
    return false;
  }
  return true;
}

bool validateQaAnswer(String answer){
  if(answer.isEmpty) return false;
  return true;
}