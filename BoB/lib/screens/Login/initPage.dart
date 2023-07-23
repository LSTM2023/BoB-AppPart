import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../../models/validate.dart';
import '../BaseWidget.dart';

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
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              Offstage(
                offstage: is_off,
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    getLoginForm(idController, "아이디 또는 이메일을 입력해주세요.", false, TextInputType.emailAddress),
                    const SizedBox(height: 15),
                    getLoginForm(passController, "비밀번호를 입력해주세요.", true, TextInputType.text),
                    const SizedBox(height: 30),
                    CupertinoButton(
                        color:Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isValid()? _login : null,
                        child: const Text('로그인')
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text('계정을 잊으셨나요? '),
                        TextButton(onPressed: (){}, child: Text('아이디 찾기')),
                        Text('또는'),
                        TextButton(onPressed: (){}, child: Text('비밀번호 찾기')),

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
    }
    else{
      /*    임시    */
      // 1. UserInfo
      User userinfo = User('hehe@naver.com', 'qwe123!@#', 'nute11a', '01088885555', 0, 'haha');
      // 2. Mybabies
      Baby_relation relation = Baby_relation(0, 0, 0, '11:00', '12:00', true);
      Baby b = Baby('baby1', DateTime.now(), 0, relation);
      List<Baby> MyBabies = [b];

      Get.to(()=>BaseWidget(userinfo, MyBabies));
      //await registerService('hehe@naver.com', 'qwe123!@#', 'nute11a', '01088885555');
      //Get.snackbar('로그인 실패', '등록된 사용자가 아닙니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      print('NOT USER');
    }
  }
  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }
}