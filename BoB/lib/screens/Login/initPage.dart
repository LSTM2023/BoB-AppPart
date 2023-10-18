import 'package:bob/models/model.dart' as MODEL;
import 'package:bob/screens/Login/socialLogin.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../fcmSetting.dart';
import '../../models/validate.dart';
import '../../services/loginService.dart';
import '../../widgets/text.dart';
import '../BaseWidget.dart';
import './findID.dart';
import './signUp.dart';
import '../../widgets/form.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginInit extends StatefulWidget{
  @override
  State<LoginInit> createState() => _LoginInit();
}

class _LoginInit extends State<LoginInit>{

  late TextEditingController idController;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    passController = TextEditingController();
  }
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: const Color(0xfff9f8f8),
            margin: const EdgeInsets.fromLTRB(20, 185, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/image/logo.png', width: 158),
                ),
                const SizedBox(height: 50),
                makeTextFormField('id', idController),
                const SizedBox(height: 15),
                makePWFormField('pw', passController, true),
                const SizedBox(height: 23),
                ElevatedButton(
                    onPressed:()=> _login(idController.text.trim(), passController.text.trim()),
                    style: btnStyleForm('white', 'primary', 15.0),
                    child: const Text('로그인')
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 16,
                  child:Row(
                    children: [
                      label('계정을 잊으셨나요? ', 'bold', 12, 'base80'),
                      TextButton(
                          onPressed: (){
                            Get.to(()=> Login_findID());
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: label('아이디 찾기 ', 'bold', 12, 'primary')
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      label('아직 회원이 아니신가요?', 'bold', 12, 'base80'),
                      const SizedBox(width: 4),
                      TextButton(onPressed: (){
                        Get.to(()=>SignUp());
                      }, style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: label('회원가입', 'bold', 12, 'primary')
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 53),
                label('간편 로그인', 'bold', 12, 'base100'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: ()=>_socialLogin('naver'),
                        child: Image.asset('assets/icon/naver.png', width: 32, height: 32)
                    ),
                    const SizedBox(width: 9.5),
                    InkWell(
                        onTap: ()=>_socialLogin('google'),
                        child: Image.asset('assets/icon/google.png', width: 32, height: 32)
                    )
                  ],
                )
              ],
            )
        )
      )
    );
  }

  /// *method* for social login
  _socialLogin(String title) async {
    Map<String, String> autoInfo = {
      'email': '', 'nickname': '', 'phone': ''
    };

    if(title == 'naver'){
      final NaverLoginResult result = await naverLogin();
      if(result.status != NaverLoginStatus.loggedIn){
        Get.snackbar('naver 로그인', '로그인에 실패하였습니다');
        return;
      }
      autoInfo['email'] = result.account.email;
      autoInfo['nickname'] = result.account.name;
      autoInfo['mobile'] = result.account.mobile;
    }
    else if(title == 'google'){
      final GoogleSignInAccount? googleUser = await googleLogin();
      if(googleUser == null){
        Get.snackbar('google 로그인', '로그인에 실패하였습니다');
        return;
      }
      autoInfo['email'] = googleUser!.email;
      autoInfo['nickname'] = googleUser.displayName.toString();
    }

    var responseData = await emailOverlapService(autoInfo['email']!);
    if(responseData != "False"){
      // 신규 유저 -> 추가 정보 입력 페이지로 이동하여 추가 정보 기입 및 회원가입 진행
      await Get.to(() => SLogAddiInfo(autoInfo, socialType: title));
    }
    // 로그인 진행
    await _login(autoInfo['email']!, 'lstm123!@#');
  }

  _login(String email, String pw) async{
    if(validateEmail(email) && validatePassword(pw) == false){
      return;
    }
    var informs = await login(email, pw);
    if(informs == null){
      Get.snackbar('로그인 실패', '등록된 사용자가 아닙니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      return;
    }
    Get.snackbar('로그인 성공', '환영합니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    MODEL.User userInfo = informs['user'];
    List<MODEL.Baby> myBabies = informs['babies'];

    Get.offAll(()=> BaseWidget(userInfo, myBabies));
  }
  Widget getLoginForm(contoller, title, isOb, keyType){
    return CupertinoTextField(
      keyboardType: keyType,
      obscureText: isOb,
      controller: contoller,
      placeholder: title,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.5)
      ),
      onChanged: (val){
        setState(() {});
      },
    );
  }
}