import 'package:flutter/material.dart';
import 'package:bob/services/storage.dart';
import './Login/initPage.dart';
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
    print('s');
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
                    color: Color(0xfffa625f),
                  ),
                  child : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Image.asset('assets/images/baby.png', width: 150),
                      SizedBox(height: 50),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white,
                        ),
                      ),
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
                return Text('login 정보 O');
                //return BaseWidget(snapshot.data[0], snapshot.data[1] as List<Baby>)
              }
            }
          }
      ),
    );
  }
  Future getInitInfo() async{

    //print('getInitInfo');
    var autoLogin = await storage.read(key: 'login');
    if(autoLogin != null){
      return 1;
    }
    else{
      // login 정보 X
      return LoginInit();
    }
  }
  
}