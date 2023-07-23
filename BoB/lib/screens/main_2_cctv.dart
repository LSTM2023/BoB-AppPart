import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';

class Main_Cctv extends StatefulWidget{
  final User userinfo;
  final getMyBabyFuction;
  const Main_Cctv(this.userinfo, {super.key, this.getMyBabyFuction});
  @override
  State<Main_Cctv> createState() => MainCCTVState();
}
class MainCCTVState extends State<Main_Cctv>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('2'),
    );
  }
}