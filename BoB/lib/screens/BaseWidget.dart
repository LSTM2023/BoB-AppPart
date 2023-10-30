import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/widgets/bottomNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './main_1_home.dart';
import './main_2_cctv.dart';
import './main_3_diary.dart';
import './main_4_mypage.dart';

class BaseWidget extends StatefulWidget{
  final User userinfo;
  final List<Baby> MyBabies;
  const BaseWidget(this.userinfo, this.MyBabies, {Key?key}):super(key:key);
  @override
  State<BaseWidget> createState() => _BaseWidget();
}
class _BaseWidget extends State<BaseWidget>{
  GlobalKey<MainCCTVState> _cctvKey = GlobalKey();
  GlobalKey<MainMyPageState> _mypageKey = GlobalKey();
  GlobalKey<MainHomeState> _homepageKey = GlobalKey();
  GlobalKey<MainHomeState> _diaryKey = GlobalKey();
  late List<Baby> activeBabies;
  late List<Baby> disactiveBabies;
  int cIdx = 0;
  int _selectedIndex = 0; // 인덱싱

  // 앱에서 지원하는 언어 리스트
  final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('ko', 'KR')
  ];

  String selectedLanguageMode = '한국어';

  @override
  void initState() {
    super.initState();
    if(widget.MyBabies.isEmpty){
      _selectedIndex = 3; // 인덱싱
    }
    classifyByActive();
  }
  // 1. active / disActive 분류
  classifyByActive(){
    activeBabies = [];
    disactiveBabies = [];
    for(int i=0; i<widget.MyBabies.length; i++){
      Baby b = widget.MyBabies[i];
      if(b.relationInfo.active){

        activeBabies.add(b);
        //if(b.relationInfo.relation == 0){
        //cIdx = i;
        //}
      }else{
        disactiveBabies.add(b);
      }
    }
    //print('classify 결과 : {active : ${activeBabies.length}, disactive : ${disactiveBabies.length}}');
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  changeCurrentBaby(int i){
    setState(() {
      cIdx = i;
    });
  }
  getBabies(bool isActive){
    if(isActive) {
      return activeBabies;
    } else {
      return disactiveBabies;
    }
  }
  getCurrentBaby(){
    return activeBabies[cIdx];
  }
  reloadBabies() async{
    activeBabies.clear();
    disactiveBabies.clear();
    List<dynamic> babyRelationList = await getMyBabiesService();
    for(int i=0; i < babyRelationList.length; i++){
      var baby = await getBaby(babyRelationList[i]['baby']);
      baby['relationInfo'] = (Baby_relation.fromJson(babyRelationList[i])).toJson();
      setState(() {
        if(babyRelationList[i]['active']){
          activeBabies.add(Baby.fromJson(baby));
        }else{
          disactiveBabies.add(Baby.fromJson(baby));
        }
      });
    }
  }
  // 다국어 처리
  changeLanguageMode(String value){
    if(value == '한국어'){
      Get.updateLocale(const Locale('ko','KR'));
    }else{
      Get.updateLocale(const Locale('en','US'));
    }
    selectedLanguageMode = value;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Main_Home(widget.userinfo, key : _homepageKey, getBabiesFunction: getBabies,getCurrentBabyFunction: getCurrentBaby, changeCurrentBabyFunction: changeCurrentBaby),
      MainCctv(widget.userinfo, key:_cctvKey, getMyBabyFuction: getCurrentBaby),
      MainDiary(key:_diaryKey),
      MainMyPage(widget.userinfo, selectedLanguageMode, key: _mypageKey, getBabiesFuction: getBabies, reloadBabiesFunction: reloadBabies, changeLanguage: changeLanguageMode)
    ];

    return DefaultTabController(
        length: 4,
        initialIndex: activeBabies.isEmpty?3:0,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              body: SafeArea(
                child: widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: bottomNavBar(_selectedIndex, _onItemTapped)
          ),
        )
    );
  }

}
