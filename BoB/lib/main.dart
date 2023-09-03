import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import './screens/Splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import './language.dart';
import 'package:get/get.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
     translations: Languages(),
     locale: Get.deviceLocale,  // 기기에 설정한 언어
     fallbackLocale:  const Locale('ko','KR'),
     debugShowCheckedModeBanner: false,
      //theme: ThemeData(),
      home: const Splash(),
    );
  }
}