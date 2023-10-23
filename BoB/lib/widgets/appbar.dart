import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSize homeAppbar2(String title, bool isAllowedBack){
  return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: AppBar(
        automaticallyImplyLeading: isAllowedBack,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFFCCBF), // <-- SEE HERE
          statusBarIconBrightness: Brightness.light,
        ),
          title: Align(
            alignment: Alignment.centerRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('BoB', style: TextStyle(color:Color(0xFFFB8665), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 20)),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(color:Color(0xFF512F22), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 18))
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
PreferredSize homeAppbar(String title){
  return PreferredSize(
      preferredSize: const Size.fromHeight(55),
      child: AppBar(

          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFFFFCCBF), // <-- SEE HERE
            statusBarIconBrightness: Brightness.light,
          ),
          title: Align(
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('BoB', style: TextStyle(color:Color(0xFFFB8665), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(title, style: const TextStyle(color:Color(0xFF512F22), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound', fontSize: 18))
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