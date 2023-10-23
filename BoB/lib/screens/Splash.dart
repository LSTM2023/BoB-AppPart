import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:safe_device/safe_device.dart';
import '../models/model.dart';
import '../widgets/text.dart';
import '../services/storage.dart';
import '../services/loginService.dart';
import 'BaseWidget.dart';
import 'Login/initPage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _Splash();
}

class _Splash extends State<Splash>{

  late Future InitInfo;
  String? _result;
  @override
  void initState() {
    super.initState();
    securityCheck();
    // 초기 로그인 불러오기
    InitInfo = getInitInfo();

  }

  securityCheck() async{
    final bool isJailBroken = await SafeDevice.isJailBroken;
    if (Platform.isAndroid) {
      setState(() {
        _result = isJailBroken ? 'Rooted' : 'Not rooted';
      });
    } else if (Platform.isIOS) {
      setState(() {
        _result = isJailBroken ? 'Jailbroken' : 'Not jailbroken';
      });
    } else {
      setState(() {
        _result = '-';
      });
    }
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
