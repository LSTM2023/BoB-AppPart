import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';

Widget getErrorPharse(String comment){
  return Row(
    children: [
      const Icon(Icons.error_outline),
      const SizedBox(width: 10,),
      Text(comment)
    ],
  );
}
String getlifeRecordPharse(Duration diff){
  if(diff.inSeconds < 60){
    return '${diff.inSeconds}초 전';
  }else if(diff.inMinutes < 60){
    return '${diff.inMinutes}분 전';
  }else if(diff.inHours < 24){
    return '${diff.inHours}시간 전';
  }else{
    return '${diff.inDays}일 전';
  }
}