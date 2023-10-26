import 'package:bob/models/model.dart';
import 'package:bob/screens/Login/initPage.dart';
import 'package:bob/screens/MyPage/OpenSourceLicenses.dart';
import 'package:bob/screens/MyPage/withdraw.dart';
import 'package:bob/services/storage.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/backend.dart';
import '../widgets/form.dart';
import './MyPage/Invitation.dart';
import './MyPage/BabyBottomSheet.dart';
import 'package:badges/badges.dart' as badges;

import 'MyPage/modifyUserInfo.dart';
class MainMyPage extends StatefulWidget{
  final User userinfo;
  final getBabiesFuction; // 아기 불러오는 fuction
  final reloadBabiesFunction;
  final changeLanguage;
  final Clanguage;
  const MainMyPage(this.userinfo, this.Clanguage, {Key?key, this. getBabiesFuction, this.reloadBabiesFunction, this.changeLanguage}):super(key:key);
  @override
  State<MainMyPage> createState() => MainMyPageState();
}
class MainMyPageState extends State<MainMyPage>{

  CarouselController carouselController = CarouselController();
  late List<Baby> activateBabies;
  late List<Baby> disActivateBabies;

  @override
  void initState() {
    print(widget.userinfo.qaType);
    activateBabies = widget.getBabiesFuction(true);
    disActivateBabies = widget.getBabiesFuction(false);

    if(activateBabies.isEmpty && disActivateBabies.isEmpty){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showModalBottomSheet(
            isDismissible: false,
          shape: modalBottomSheetFormRound(),
          backgroundColor: const Color(0xffF9F8F8),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return const AddBabyBottomSheet();
          }
        );
        await widget.reloadBabiesFunction();
      });
    }
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
              // 아이 관리 리스트
              label('main4_manageBaby'.tr, 'bold', 14, 'base100'),
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
                  return drawBabyOne((i<activateBabies.length ? activateBabies[i] : null));
                },
              ),
              const SizedBox(height: 86),
              // setting list - invitation / language / user info / logout
              drawSettingSpace('main4_InviteBabysitter'.tr, Icons.favorite,() => invitation()),
              drawSettingSpace('main4_changeLanguage'.tr, Icons.language, (){}),
              drawSettingSpace('main4_modifyUserInfo'.tr, Icons.settings, ()=>modifyUserInfo()),
              drawSettingSpace('main4_logout'.tr, Icons.logout,() => logout()),
              drawSettingSpace('main4_withdrawal'.tr, Icons.ac_unit,()=>withdraw()),
              drawSettingSpace('license'.tr, Icons.receipt_long,()=>viewOpenSourceLicenses()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    );
  }
  /*  ----------------------------  DRAW  ----------------------------------------*/
  /// setting 메뉴 그리기
  Column drawSettingSpace(String title, IconData icon, dynamic func){
    Row content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size:18, color: const Color(0xFFFB8665)),
        const SizedBox(width: 20),
        label(title, 'bold', 10, 'base100')
      ],
    );
    if(icon == Icons.language){
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          content,
          DropdownButton(
              underline: const SizedBox.shrink(),
              value: widget.Clanguage,
              items: ['한국어', 'English'].map((String item){
                return DropdownMenuItem<String>(
                  value: item,
                  child: label(item, 'bold', 10, 'base60'),
                );
              }).toList(),
              onChanged: (dynamic value) => changeLanguageMode(value)
          ),
        ],
      );
    }
    return Column(
      children: [
        InkWell(
            onTap: func,
            child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 30,
                child: content
            )
        ),
        const Padding(
            padding: EdgeInsets.all(11.5),
            child: Divider(
              thickness: 1,
              color: Color(0xffC4C4C4),
            )
        )
      ],
    );
  }
  /// baby 그리기
  Widget drawBabyOne(Baby? baby){
    late Widget imgSpace;
    late Widget nameSpace;
    if(baby != null){
      imgSpace = Container(
        height: 100,
        width: 100,
        alignment: Alignment.center,
        decoration: containerStyleFormRound(),
        child: Image.asset('assets/image/baby${baby.gender==0?0:1}.png', width: 70),
      );
      nameSpace = badges.Badge(
        position: badges.BadgePosition.topEnd(top: -13, end: -20),
        badgeContent: label(baby.relationInfo.getRelationString(), 'normal', 6, 'white'),
        badgeStyle: badges.BadgeStyle(
          shape: badges.BadgeShape.square,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          badgeColor: colorList[baby.relationInfo.relation],
        ),
        child: label((baby!=null?baby.name:'New'), 'bold', 12, 'rel${baby.relationInfo.relation}')
      );
    }
    else{
      imgSpace = InkWell(
          onTap: () async {
            await showModalBottomSheet(
                shape: modalBottomSheetFormRound(),
                backgroundColor: const Color(0xffF9F8F8),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  //return BabyBottomSheet(null);
                  return const AddBabyBottomSheet();
                }
            );
            await widget.reloadBabiesFunction();
          },
          child: Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: containerStyleFormRound(),
            child: const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
          )
      );
      nameSpace = label((baby!=null?baby.name:'New'), 'bold', 12, 'base100');
    }
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
            imgSpace,
            const SizedBox(height: 12),
            nameSpace,
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
                          label('${'birth'.tr} : ', 'bold', 10, 'base100'),
                          label((baby!=null?'${baby.birth.year}${'year'.tr} ${baby.birth.month}${'month'.tr} ${baby.birth.day}${'day_birth'.tr}':''), 'bold', 10, 'base63'),
                        ],
                      )
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          label('${'gender'.tr} : ', 'bold', 10, 'base100'),
                          label((baby!=null?(baby.gender==1?'genderM'.tr:'genderF'.tr):''), 'bold', 10, 'base63')
                        ],
                      )
                  )
                ],
              ),
            )
          ],
        )
    );
    if(baby!=null && baby?.relationInfo.relation == 0){
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
                backgroundColor: const Color(0xffB4B4B4),
                onPressed: (){
                  Get.dialog(
                      AlertDialog(
                        title: label('warning', 'extra-bold', 18, 'primary'),
                        content: label('once_delete'.tr, 'bold', 14, 'base100'),
                        actions: [
                          TextButton(
                              onPressed: ()=> deleteBaby(baby.relationInfo.BabyId),
                              child: label('delete'.tr, 'bold', 14, 'base100')
                          ),
                          TextButton(
                              onPressed: (){
                                Get.back();
                              },
                              child: label('cancel'.tr, 'bold', 14, 'base100')
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
                onPressed: () async => await editBaby(baby),
                child: const Icon(Icons.edit, size:12),
              ),
            ),
          ],
        )
        ],
      );
    }
    else{
      return content;
    }
  }
  /*  ----------------------------  METHOD  ----------------------------------------*/
  /// [0-a] method for edit baby
  editBaby(Baby baby) async {
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
          return ModifyBabyBottomSheet(baby);
        });
    await widget.reloadBabiesFunction();
  }
  /// [0-b] method for delete baby
  deleteBaby(int targetBabyID) async {
     var re = await deleteBabyService(targetBabyID);
     if(re != 200){
       Get.snackbar('warning', 'not_deleted'.tr);
       return;
     }
     Get.back();
     await widget.reloadBabiesFunction();
  }
  /// [1] method for invite additional caregivers
  invitation() async {
    await Get.to(() => Invitation(widget.userinfo.email, activateBabies, disActivateBabies));
    await widget.reloadBabiesFunction();
  }
  /// [2] method for change language mode
  changeLanguageMode(changedLanguage){
    setState(() {
      widget.changeLanguage(changedLanguage);
    });
  }
  /// [3] method for modify user information
  modifyUserInfo() async {
    var modifyInfo = await Get.to(() => ModifyUser(widget.userinfo));
    if(modifyInfo != null){
      setState((){
        widget.userinfo.modifyUserInfo(modifyInfo['name'], modifyInfo['phone'], modifyInfo['qaType'], modifyInfo['qaAnswer']);
      });
    }
  }
  /// [4] method for logout
  logout() async{
    await deleteLogin();
    Get.offAll(LoginInit());
  }
  /// [5] method for withdraw
  withdraw() {
    showModalBottomSheet(
        shape: modalBottomSheetFormRound(),
        backgroundColor: const Color(0xffF9F8F8),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return const WithdrawBottomSheet();
        }
    );
  }
  /// [6] method for view opensource licenses
  viewOpenSourceLicenses() {
    Get.to(() => OpenSourceLicenses());
  }
}