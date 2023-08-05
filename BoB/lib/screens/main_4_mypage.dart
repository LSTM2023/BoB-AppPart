import 'package:bob/models/model.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/services/login_platform.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  final getBabiesFuction; // 아기 불러오는 fuction
  final reloadBabiesFunction;
  const MainMyPage(this.userinfo, {Key?key, this. getBabiesFuction, this.reloadBabiesFunction}):super(key:key);
  @override
  State<MainMyPage> createState() => MainMyPageState();
}
class MainMyPageState extends State<MainMyPage>{

  List<String> languageList = ['한국어', '영어'];
  List<Color> colorList = [Color(0xffFB8665), Color(0xff22513E), Color(0xff222551)];
  int cLanIdx = 0;
  late List<Baby> activateBabies;
  late List<Baby> disActivateBabies;
  String selectedLanguageMode = '한국어';

  @override
  void initState() {
    activateBabies = widget.getBabiesFuction(true);
    activateBabies = activateBabies+ activateBabies;
    disActivateBabies = widget.getBabiesFuction(false);
    //log('MyPage : ${activateBabies.length} | ${disActivateBabies.length}');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: homeAppbar('My Page'),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 42, 16, 42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                  margin: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('아기 관리', style: TextStyle(color: Color(0xff512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
                        IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: (){
                            },
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: Color(0xff512F22))
                        )
                      ],
                    )
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 148,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: activateBabies.length,
                    itemBuilder: (BuildContext context, int index){
                      int seed = Random().nextInt(5); // 0 ~ 4 랜덤
                      return drawBaby(activateBabies[index]!, seed);
                    }
                )
              ),
              const SizedBox(height: 48),
              Container(
                height: 166,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8F8),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29512F22),
                      spreadRadius: 0,
                      blurRadius: 6.0,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F8F8),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29512F22),
                      spreadRadius: 0,
                      blurRadius: 6.0,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    drawSettingScreen('로그아웃', const Icon(Icons.logout),() => logout()),
                    drawDivider(),
                    drawSettingScreen('회원정보 수정', Icons.add, (){}),
                    drawDivider(),
                    drawLanguageScreen(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  Container drawLanguageScreen(){
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Color(0xff707070)),),
                ),
                const SizedBox(width: 20),
                const Text('언어', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
              ],
            ),
            Text(languageList[cLanIdx], style: const TextStyle(color: Color(0x99512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
          ],
        )
    );
  }

  Container drawBaby(Baby baby, int seed){
    return Container(
        height: 130,
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F8F8),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29512F22),
              spreadRadius: 0,
              blurRadius: 3.0,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/baby${seed%5}.png', width: 80),
            const SizedBox(height: 12),
            Text(baby.name, style: TextStyle(color: colorList[seed%3], fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
          ],
        )
    );
  }
}

InkWell drawSettingScreen( title, icon,  func){
  return InkWell(
    onTap: func,
    child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(border: Border.all(width: 1, color: Color(0xff707070)),),
            ),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,))
          ],
        )
    )
  );
}

Padding drawDivider(){
  return const Padding(
      padding: EdgeInsets.all(11.5),
      child: Divider(
        thickness: 1,
        color: Color(0xffC4C4C4),
      )
  );
}

logout() async{
  await deleteLogin();
  LoginPlatform _loginPlatform = LoginPlatform.none;
  Get.offAll(LoginInit());
}