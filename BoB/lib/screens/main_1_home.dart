import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';

class Main_Home extends StatefulWidget{
  final User userinfo;
  final getBabiesFunction;
  final getCurrentBabyFunction;
  final changeCurrentBabyFunction;
  const Main_Home(this.userinfo, {Key? key, this.getBabiesFunction, this.getCurrentBabyFunction, this.changeCurrentBabyFunction}) : super(key: key);
  @override
  State<Main_Home> createState() => MainHomeState();
}

class MainHomeState extends State<Main_Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('1'),
    );
  }
}