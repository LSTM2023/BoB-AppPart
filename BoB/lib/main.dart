import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import './screens/Splash.dart';
import './language.dart';
import 'package:get/get.dart';

void main() async {
  print('main');
  WidgetsFlutterBinding.ensureInitialized();
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
     title: 'Flutter Demo',
     theme: ThemeData(
       fontFamily: 'omew',
     ),
     debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}