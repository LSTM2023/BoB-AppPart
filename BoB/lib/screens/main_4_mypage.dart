import 'package:bob/models/model.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: renderAppbar('My Page', false, 0xffffffff),
      body: getSettingScreen('로그아웃', const Icon(Icons.logout),() => logout()),
    );
  }
}
logout() async{
  await deleteLogin();
  Get.offAll(LoginInit());
}
Container getSettingScreen(title, icon, func){
  return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
          onTap: func,
          child : Column(
            children: [
              Row(children: [icon, const SizedBox(width: 25), Text(title, style: const TextStyle(fontSize: 13))]),
              const SizedBox(height: 8),
              Divider(thickness: 1, color: Colors.grey[300]),
            ],
          )
      )
  );
}