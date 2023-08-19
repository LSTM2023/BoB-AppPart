import 'package:bob/models/model.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/withdraw.dart';
import 'package:bob/services/login_platform.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/backend.dart';
import './MyPage/Invitation.dart';
import './MyPage/AddBaby.dart';
import 'package:badges/badges.dart' as badges;

import 'MyPage/modifyUserInfo.dart';
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
    super.initState();
    if(activateBabies.length==0 && disActivateBabies.length==0){
      WidgetsBinding.instance.addPostFrameCallback((_){
        openAddBabyScreen();
      });
    }
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
              CarouselSlider.builder(
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
              const SizedBox(height: 86),
              drawSettingScreen('양육자/베이비시터 초대', Icons.favorite,() => invitation()),
              drawDivider(),
              drawLanguageScreen(),
              drawDivider(),
              drawSettingScreen('회원정보 수정', Icons.settings, ()=>modifyUserInfo()),
              drawDivider(),
              drawSettingScreen('로그아웃', Icons.logout,() => logout()),
              drawDivider(),
              drawSettingScreen('서비스 탈퇴', Icons.ac_unit,()=>withdraw()),
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
  Widget drawBaby(Baby baby, int seed){
    Container content = Container(
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
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -13, end: -20),
              badgeContent: text(baby.relationInfo.getRelationString(), 'normal', 6, Colors.white),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.square,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                badgeColor: colorList[baby.relationInfo.relation],
              ),
              child: Text(baby.name, style: TextStyle(color: colorList[baby.relationInfo.relation], fontSize: 12, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold,)),
            ),
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
    if(baby.relationInfo.relation == 0){
      return Stack(
        children: [
          content,
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 20,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Color(0xffB4B4B4),
                onPressed: (){
                  Get.dialog(
                      AlertDialog(
                        title: text('warning', 'extra-bold', 18, Color(0xffFB8665)),
                        content: textBase('한 번 삭제한 내용은 복구가 불가능합니다.\n 정말로 삭제하시겠습니까?', 'bold', 14),
                        actions: [
                          TextButton(
                              onPressed: ()=> {}, // deleteBaby(baby.relationInfo.BabyId),
                              child: textBase('삭제', 'bold', 14)
                          ),
                          TextButton(
                              onPressed: (){
                                Get.back();
                              },
                              child: textBase('취소', 'bold', 14)
                          )
                        ],
                      ),
                      barrierDismissible: false
                  );
                },
                child: const Icon(Icons.delete, size:12),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 20,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: colorList[baby.relationInfo.relation],
                onPressed: () async {
                    // await showModalBottomSheet(
                    //     shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.only(
                    //             topRight: Radius.circular(20),
                    //             topLeft: Radius.circular(20)
                    //         )
                    //     ),
                    //     backgroundColor: const Color(0xffF9F8F8),
                    //     isScrollControlled: true,
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return BabyBottomSheet(baby);
                    //     }
                    // );
                    await widget.reloadBabiesFunction();
                },
                child: const Icon(Icons.edit, size:12),
              ),
            ),
          ],
        )
        ],
      );
    }else{
      return content;
    }
  }
  Widget drawAddBaby(int seed){
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
                onTap: () => openAddBabyScreen(),
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
  openAddBabyScreen() async {
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
  }
  invitation() async {
    await Get.to(() => Invitation(activateBabies, disActivateBabies));
    await widget.reloadBabiesFunction();
  }
  modifyUserInfo() async {
    var modifyInfo = await Get.to(() => ModifyUser(widget.userinfo));
    if(modifyInfo != null){
      setState((){
        widget.userinfo.modifyUserInfo(modifyInfo['pass'], modifyInfo['name'], modifyInfo['phone']);
      });
    }
  }
  withdraw() {
    showModalBottomSheet(
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
          return WithdrawBottomSheet();
        }
    );
  }
  // deleteBaby(int targetBabyID) async {
  //   var re = await deleteBabyService(targetBabyID);
  //   if(re != 200){
  //     Get.snackbar('warning', '삭제하지 못했습니다');
  //     return;
  //   }
  //   Get.back();
  //   await widget.reloadBabiesFunction();
  // }
}

InkWell drawSettingScreen(String title, IconData icon, dynamic func){
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
  Get.offAll(LoginInit());
}