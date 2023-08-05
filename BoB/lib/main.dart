import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import './screens/Splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '8e9bc1047c7add0a7a08665270df5693'); // 이 줄을 runApp 위에 추가한다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Splash(),
    );
  }
}