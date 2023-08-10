import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar renderAppbar(String title, bool isBack, int colorCode){
  return AppBar(
      automaticallyImplyLeading: isBack,
      backgroundColor: Color(colorCode),
      elevation: 0,
      iconTheme : const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(title,style: TextStyle(color: Color(0xFF512F22),fontSize: 18)),
    shape: Border(
      bottom: BorderSide(
        color: Color(0xB3512F22),
        width: 1,
      ),
    ),
  );
}
PreferredSize homeAppbar(String title){
  return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.green, // <-- SEE HERE
          statusBarIconBrightness: Brightness.light,
        ),
          title: const Align(
            alignment: Alignment.centerRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('BoB', style: TextStyle(color:Color(0xFFFB8665), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 20)),
                SizedBox(width: 5),
                Text('마이페이지', style: TextStyle(color:Color(0xFF512F22), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 20))
              ],
            )
          ),
          backgroundColor: const Color(0xD9FFE1C7),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFFFCCBF), Color(0xD9FFE1C7)],
                  )
              ),
          ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10)
          ),
        ),
        shadowColor: const Color(0x4D584639)
      )
  );
}