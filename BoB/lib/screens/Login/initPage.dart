import 'dart:convert';
import 'dart:io';
import 'package:bob/models/model.dart' as MODEL;
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../models/validate.dart';
import '../../services/login_platform.dart';
import '../BaseWidget.dart';
import './findID.dart';
import './findPassword.dart';
import './signUp.dart';
import '../MyPage/AddBaby.dart';
import '../../widgets/form.dart';
import './findLoginInfo.dart';
import 'package:http/http.dart' as http;
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
  bool is_off = true;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xfff9f8f8),
        margin: const EdgeInsets.fromLTRB(20, 185, 20, 0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/image/logo.png', width: 158),
                ),
                const SizedBox(height: 50),
                getLoginForm(idController, "아이디 또는 이메일을 입력해주세요.", false, TextInputType.emailAddress),
                const SizedBox(height: 15),
                getLoginForm(passController, "비밀번호를 입력해주세요.", true, TextInputType.text),
                const SizedBox(height: 23),
                ElevatedButton(
                    onPressed: _isValid()? _login : null,
                    style:ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 0.2,
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Color.fromRGBO(251, 134, 101, 1),
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                    ),
                    child: const Text('로그인')
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 16,
                  child:Row(
                    children: [
                      makeText('계정을 잊으셨나요? ', Color(0xCC512F22), 12),
                      TextButton(
                          onPressed: (){
                            Get.to(()=> FindLoginInfo(0));
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: makeText('아이디 찾기 ', Color(0xfffb8665), 12)
                      ),
                      makeText('또는', Color(0xCC512F22), 12),
                      TextButton(
                          onPressed: (){
                            Get.to(()=> FindLoginInfo(1));
                          },
                          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: makeText('비밀번호 찾기 ', Color(0xfffb8665), 12)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      makeText('아직 회원이 아니신가요?', Color(0xCC512F22), 12),
                      const SizedBox(width: 4),
                      TextButton(onPressed: (){
                        Get.to(()=>SignUp());
                      }, style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                          child: makeText('회원가입', Color(0xfffb8665), 12)
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 53),
                makeText('간편 로그인', Color(0xFF512F22), 12),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialLoginButton('naver'),
                    SizedBox(width: 9.5),
                    socialLoginButton('google'),
                  ],
                )
              ],
            ),
          ),
        )
      )
    );
  }
  _after_socialLogin(String email, String nickName, String phone) async {
    String responseData = await emailOverlapService(email);
    if(responseData == "False"){   // 존재하는 아이디 // 2. 있으면, login 정보 받아와
      print('존재하는 ID 존재 -> 있는 ID 로그인');
      await post_login(email, 'naver123!@#');
    }else{        // 존재 X는 아이디  // 2. 없으면, 회원가입 진행
      print('존재하지 않는 ID');
      var response = await registerService(email, 'naver123!@#', nickName, phone, 0, "");
      await post_login(email, 'naver123!@#');
    }
  }
  post_login(String email, String pw) async{
    var loginData = await loginService(email, pw);
    if(loginData != null){
      String token = loginData['access_token'];   // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      MODEL.User userInfo = MODEL.User(loginData['email'], pw, loginData['name'], loginData['phone'],0, "");
      MODEL.Login loginInfo = MODEL.Login(token, loginData['refresh_token'], payload['user_id'],loginData['email'], pw);
      await writeLogin(loginInfo);
      print('---------------');
      // 2. babyList 가져오기
      List<MODEL.Baby> MyBabies = [];
      List<dynamic> babyList = await getMyBabies();
      print('---------------');
      for(int i=0; i<babyList.length;i++){
        // 2. 아기 등록
        MODEL.Baby_relation relation = MODEL.Baby_relation.fromJson(babyList[i]);
        var baby = await getBaby(babyList[i]['baby']);
        baby['relationInfo'] = relation.toJson();
        MyBabies.add(MODEL.Baby.fromJson(baby));
      }
      Get.snackbar('로그인 성공', '환영합니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      if(MyBabies.isEmpty){
        Get.offAll(()=> BaseWidget(userInfo, MyBabies));
      }
      else{
        Get.offAll(()=> BaseWidget(userInfo, MyBabies));
      }
    }
    else{
      Get.snackbar('로그인 실패', '등록된 사용자가 아닙니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }

  _signWithNaver() async {
    print('naver login');
    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    if (result.status == NaverLoginStatus.loggedIn) {
      // 1. 해당 정보가 있는지 확인 -> duplicate
      _after_socialLogin(result.account.email, result.account.name, result.account.mobile);
    }
  }
  _signWithGoogle() async {
    print('google login');
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if(googleUser != null){
      _after_socialLogin(googleUser.email, googleUser.displayName.toString(), '010-5555-6666');
    }else{
      Get.snackbar('login', '로그인에 실패하였습니다');
    }
  }
  InkWell socialLoginButton(String title){
    return InkWell(
      onTap: (){
        if(title=='naver') {
          _signWithNaver();
        } else if(title == 'google') {
          _signWithGoogle();
        }
      },
      child: Image.asset('assets/icon/$title.png', width: 32, height: 32)
    );
  }

  // 로그인 폼 입력값 형식 체크
  bool _isValid(){
    return (validateEmail(idController.text.trim()) && validatePassword(passController.text.trim()));
  }
  Widget getLoginForm(contoller, title, isOb, keyType){
    return CupertinoTextField(
      keyboardType: keyType,
      obscureText: isOb,
      controller: contoller,
      placeholder: title,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        //color: Color(0x512F224D),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.5)
      ),
      onChanged: (val){
        setState(() {});
      },
    );
  }
  void _login() async{
    await post_login(idController.text.trim(), passController.text.trim());
  }
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
}