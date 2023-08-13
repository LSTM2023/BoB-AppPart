import 'package:bob/models/model.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/services/login_platform.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import './MyPage/Invitation.dart';
import './MyPage/AddBaby.dart';

class MainMyPage extends StatefulWidget{
  final User userinfo;
  final getBabiesFuction; // 아기 불러오는 fuction
  final reloadBabiesFunction;
  const MainMyPage(this.userinfo, {Key?key, this. getBabiesFuction, this.reloadBabiesFunction}):super(key:key);
  @override
  State<MainMyPage> createState() => MainMyPageState();
}
class MainMyPageState extends State<MainMyPage>{
  CarouselController carouselController = CarouselController();
  List<String> languageList = ['한국어', '영어'];
  List<Color> colorList = [Color(0xffFB8665), Color(0xff22513E), Color(0xff222551)];
  int cLanIdx = 0;
  late List<Baby> activateBabies;
  late List<Baby> disActivateBabies;
  String selectedLanguageMode = '한국어';

  @override
  void initState() {
    activateBabies = widget.getBabiesFuction(true);
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
          padding: const EdgeInsets.fromLTRB(25.5, 42, 25.5, 42),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('아기 관리', style: TextStyle(color: Color(0xff512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
              const SizedBox(height: 10),
              Container(
                //margin: const EdgeInsets.all(15),
                child: CarouselSlider.builder(
                  itemCount: activateBabies.length+1,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: 230,
                    reverse: false,
                    aspectRatio: 5.0,
                  ),
                  itemBuilder: (context, i, id){
                    if(i < activateBabies.length) {
                      return drawBaby(activateBabies[i], 0);
                    }else{
                      return drawAddBaby(0);
                    }
                  },
                ),
              ),
              const SizedBox(height: 86),
              drawSettingScreen('양육자/베이비시터 초대', Icons.favorite,() => invitation()),
              drawDivider(),
              drawLanguageScreen(),
              drawDivider(),
              drawSettingScreen('회원정보 수정', Icons.settings, (){}),
              drawDivider(),
              drawSettingScreen('로그아웃', Icons.logout,() => logout()),
              drawDivider(),
              const SizedBox(height: 20),
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
            const Row(
              children: [
                Icon(Icons.language, size:18, color: Color(0xFFFB8665)),
                SizedBox(width: 20),
                Text('언어', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
              ],
            ),
            Text(languageList[cLanIdx], style: const TextStyle(color: Color(0x99512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
          ],
        )
    );
  }
  Container drawBaby(Baby baby, int seed){
    print('>>. ${baby.gender}');
    return Container(
        height: 230,
        width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xCCFFFFFF),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffC1C1C1),
                    width: 0.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    )
                  ]
              ),
              child: Image.asset('assets/image/baby${baby.gender==0?0:1}.png', width: 70),
            ),
            const SizedBox(height: 12),
            Text(baby.name, style: TextStyle(color: colorList[seed%3], fontSize: 12, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
            const SizedBox(height: 13),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 41, right: 41),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          Text('생일 : ', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                          Text('${baby.birth.year}년 ${baby.birth.month}월 ${baby.birth.day}일생', style: TextStyle(color: Color(0xa1512f22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                        ],
                      )
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          const Text('성별 : ', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                          Text(baby.gender==1?'남자':'여자', style: const TextStyle(color: Color(0xa1512f22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                        ],
                      )
                  )
                ],
              ),
            )

          ],
        )
    );
  }
  Container drawAddBaby(int seed){
    return Container(
        height: 230,
        width: double.infinity,
        margin: const EdgeInsets.only(right: 10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)
                        )
                    ),
                    backgroundColor: const Color(0xffF9F8F8),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return AddBabyBottomSheet();
                    }
                );
                await widget.reloadBabiesFunction();
              },
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xCCFFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffC1C1C1),
                      width: 0.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      )
                    ]
                ),
                child: const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
              )
            ),
            const SizedBox(height: 12),
            Text('추가', style: TextStyle(color: colorList[seed%3], fontSize: 12, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
            const SizedBox(height: 13),
             Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 41, right: 41),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('생일 : ', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('성별 : ', style: TextStyle(color: Color(0xff512F22), fontSize: 10, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                  ],
                ),
            )
            ],
        )
    );
  }
  invitation() async{
    await Get.to(() => Invitation(activateBabies, disActivateBabies));
    await widget.reloadBabiesFunction();
  }
}

InkWell drawSettingScreen( title, IconData icon,  func){
  return InkWell(
    onTap: func,
    child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size:18, color: const Color(0xFFFB8665)),
            /*Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(border: Border.all(width: 1, color: Color(0xff707070)),),
            )*/
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