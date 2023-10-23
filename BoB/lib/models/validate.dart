import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool validateEmail(String? email){
  var emailFormat = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if(email == null || email.isEmpty || !RegExp(emailFormat).hasMatch(email)) return false;
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
  return (type < 0 || 5 < type) ? false : true;
}

bool validateQaAnswer(String answer){
  if(answer.isEmpty) return false;
  return true;
}

bool validateWeek(int allowedW){
  if(allowedW < 0 || allowedW > 127) return false;
  return true;
}
bool validateTimeRange(List<int> allowedTs){
  if(allowedTs[0] < 0 || allowedTs[0] > 23 || allowedTs[2] < 0 || allowedTs[2] > 23) return false;
  if(allowedTs[1] < 0 || allowedTs[1] > 59 || allowedTs[3] < 0 || allowedTs[3] > 59) return false;
  if((allowedTs[0]*60 + allowedTs[1]) >= (allowedTs[2]*60 + allowedTs[3]))  return false;
  print((allowedTs[0]*60 + allowedTs[1]));
  return true;
}