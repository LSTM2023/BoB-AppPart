import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  final getBabiesFuction; // 아기 불러오는 fuction
  final reloadBabiesFunction;
  const MainMyPage(this.userinfo, {Key?key, this. getBabiesFuction, this.reloadBabiesFunction}):super(key:key);
  @override
  State<MainMyPage> createState() => MainMyPageState();
}
class MainMyPageState extends State<MainMyPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('4'),
    );
  }
}