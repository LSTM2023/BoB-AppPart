import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget bottomNavBar(_selectedIndex, _onItemTapped){
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        //icon: FaIcon(FontAwesomeIcons.cameraRetro),
        icon: SvgPicture.asset(
          'assets/icon/ic_home.svg',
          color: _selectedIndex==0?Color(0xffFB8665):Color(0xff512F22),
          height: 24,
          width: 24,
        ), //Icon(Icons.home_outlined, size: 20,),
        label: '홈',
      ),
      BottomNavigationBarItem(
          icon: Icon( Icons.camera, size: 20,color: _selectedIndex==1?Color(0xffFB8665):Color(0xff512F22),),
          label: '홈캠'
      ),
      BottomNavigationBarItem(
        //icon: FaIcon(FontAwesomeIcons.cameraRetro),
        icon: SvgPicture.asset(
          'assets/icon/ic_calendar.svg',
          color: _selectedIndex==2?Color(0xffFB8665):Color(0xff512F22),
          height: 24,
          width: 24,
        ), //Icon(Icons.home_outlined, size: 20,),
        label: '일기',
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 20,color: _selectedIndex==3?Color(0xffFB8665):Color(0xff512F22),),
          label: '마이 자취'
      )
    ],
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    selectedLabelStyle: const TextStyle(fontFamily: 'NanumSquareRound', fontSize: 10),
    unselectedLabelStyle: const TextStyle(fontFamily: 'NanumSquareRound', fontSize: 10),
  );
}