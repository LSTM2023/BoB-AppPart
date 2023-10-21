import 'dart:convert';

import 'package:bob/models/model.dart';
import 'package:bob/screens/BaseWidget.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:bob/services/storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../services/loginService.dart';
import './Login/initPage.dart';
import 'package:bob/fcmSetting.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash>{
  late Future InitInfo;

  @override
  void initState() {
    super.initState();
    // 초기 로그인 불러오기
    InitInfo = getInitInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: InitInfo,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.hasData == false){
              return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFCCBF),
                  ),
                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/logo.png', width: 120),
                      label('BoB: Best of Baby', 'bold', 14, 'base100')
                    ],
                  )
              );
            }
            else if(snapshot.hasError){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }
            else{
              if(snapshot.data is LoginInit){
                return LoginInit();
              }else{
                return Scaffold(
                    body: BaseWidget(snapshot.data[0], snapshot.data[1] as List<Baby>)
                );
              }
            }
          }
      ),
    );
  }
  Future getInitInfo() async{
    // 1. storage에서 로그인 정보 가져 오기
    var existLogin = await getLoginStorage();
    if(existLogin == null){
      return LoginInit();
    }
    Login loginInfo = Login.fromJson(jsonDecode(existLogin));

    Map<String, dynamic> informs = await login(loginInfo.userEmail, loginInfo.userPassword);
    User userInfo = informs['user'];
    List<Baby> myBabies = informs['babies'];
    if(userInfo == null){
      return LoginInit();
    }
    return [userInfo, myBabies];
  }
}
