import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget bottomNavBar(_selectedIndex, _onItemTapped){
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        //icon: FaIcon(FontAwesomeIcons.cameraRetro),
        icon: Image.asset('assets/icon/Home_A.png', height: 24, width: 24,),
        activeIcon: Image.asset('assets/icon/Home_B.png', height: 24, width: 24),//Icon(Icons.home_outlined, size: 20,),
        label: 'main_1'.tr,
      ),
      BottomNavigationBarItem(
          icon: Image.asset('assets/icon/HomeCam_A.png', height: 24, width: 24,),
          activeIcon: Image.asset('assets/icon/HomeCam_B.png', height: 24, width: 24),
          label: 'homecam'.tr
      ),
      BottomNavigationBarItem(
        //icon: FaIcon(FontAwesomeIcons.cameraRetro),
        icon: Image.asset('assets/icon/Calendar_A.png', height: 24, width: 24),
        activeIcon: Image.asset('assets/icon/Calendar_B.png', height: 24, width: 24),//Icon(Icons.home_outlined, size: 20,),
        label: 'main_3'.tr,
      ),
      BottomNavigationBarItem(
          icon: Image.asset('assets/icon/MyPage_A.png', height: 24, width: 24),
          activeIcon: Image.asset('assets/icon/MyPage_B.png', height: 24, width: 24),
          label: 'main_4'.tr
      )
    ],
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    selectedItemColor: const Color(0xffFB8665),
    selectedLabelStyle: const TextStyle(fontFamily: 'NanumSquareRound', fontSize: 10),
  );
}