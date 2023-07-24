import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:bob/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../models/validate.dart';
import '../BaseWidget.dart';
import './findID.dart';
import './findPassword.dart';
import '../MyPage/AddBaby.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 150, 20, 0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        is_off = !is_off;
                      });
                    },
                    child: const Icon(Icons.ac_unit,size: 100),
                  ),
                  SizedBox(height: 20,),
                  Offstage(
                    offstage: !is_off,
                    child: const Text('로고를 클릭해주세요'),
                  ),
                  Offstage(
                      offstage: is_off,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          getLoginForm(idController, "아이디 또는 이메일을 입력해주세요.", false, TextInputType.emailAddress),
                          const SizedBox(height: 15),
                          getLoginForm(passController, "비밀번호를 입력해주세요.", true, TextInputType.text),
                          const SizedBox(height: 30),
                          ElevatedButton(
                              onPressed: _isValid()? _login : null,
                              style:ElevatedButton.styleFrom(
                                  elevation: 0.2,
                                  padding: const EdgeInsets.all(20),
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xfffa625f),
                                  minimumSize: const Size.fromHeight(55),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                              ),
                              child: Text('로그인')
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Text('계정을 잊으셨나요? '),
                              TextButton(onPressed: (){
                                Get.to(()=>const Login_findID());
                              }, child: Text('아이디 찾기')),
                              Text('또는'),
                              TextButton(onPressed: (){
                                Get.to(()=>const Login_findPass());
                              }, child: Text('비밀번호 찾기')),

                            ],
                          ),
                          Row(
                            children: [
                              Text('아직 회원이 아니신가요? '),
                              TextButton(onPressed: (){}, child: Text('회원가입'))
                            ],
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        )
      )
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5)
      ),
      onChanged: (val){
        setState(() {});
      },
    );
  }
  void _login() async{
    var loginData = await loginService(idController.text.trim(), passController.text.trim());
    if(loginData != null){
      print('USER');
      String token = loginData['access_token'];   // response의 token키에 담긴 값을 token 변수에 담아서
      Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
      User userInfo = User(loginData['email'], passController.text.trim(), loginData['name'], loginData['phone'],0, "");
      Login loginInfo = Login(token, loginData['refresh_token'], payload['user_id'],loginData['email'], passController.text);
      await writeLogin(loginInfo);
      // 2. babyList 가져오기
      List<Baby> MyBabies = [];
      List<dynamic> babyList = await getMyBabies();
      for(int i=0; i<babyList.length;i++){
        // 2. 아기 등록
        Baby_relation relation = Baby_relation.fromJson(babyList[i]);
        var baby = await getBaby(babyList[i]['baby']);
        baby['relationInfo'] = relation.toJson();
        MyBabies.add(Baby.fromJson(baby));
      }
      Get.snackbar('로그인 성공', '환영합니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      if(MyBabies.isEmpty){
        Get.to(()=> AddBaby());
      }
      else{
        Get.to(()=> BaseWidget(userInfo, MyBabies));
      }

    }
    else{
      Get.snackbar('로그인 실패', '등록된 사용자가 아닙니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      passController.clear();
    }
  }
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
}