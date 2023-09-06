import 'package:bob/models/model.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';

Widget getErrorPharse(String comment){
  return Row(
    children: [
      const SizedBox(width: 2),
      const Icon(Icons.error_outline, color: Color(0xff512F22)),
      const SizedBox(width: 10),
      textBase(comment, 'bold', 12)
    ],
  );
}
String getlifeRecordPharse(Duration diff){
  if(diff.inSeconds < 60 && diff.inMinutes < 1){
    return '${diff.inSeconds}초 전';
  }else if(diff.inMinutes < 60){
    return '${diff.inMinutes}분 전';
  }else if(diff.inHours < 24){
    return '${diff.inHours}시간 ${diff.inMinutes - 60 * diff.inHours}분 전 ';
  }else{
    return '${diff.inDays}일 전';
  }
}