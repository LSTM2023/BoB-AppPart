import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import './screens/Splash.dart';

void main() {
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