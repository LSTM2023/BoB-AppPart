import 'package:bob/screens/Login/initPage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
import '../../services/backend.dart';
import '../../models/validate.dart';
import '../../widgets/text.dart';
import './editPassword.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUp();
}
class _SignUp extends State<SignUp>{
  late SingleValueDropDownController _cnt;
  late TextEditingController idCtr;
  late TextEditingController passCtr;
  late TextEditingController passCheckCtr;
  late TextEditingController nickNameCtr;
  late TextEditingController phoneCtr;
  late TextEditingController answerCtr;
  bool _isDuplicateCheck = false;
  bool passwordVisible = true;
  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    idCtr = TextEditingController();
    passCtr = TextEditingController();
    passCheckCtr = TextEditingController();
    nickNameCtr = TextEditingController();
    phoneCtr = TextEditingController();
    answerCtr = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    idCtr.dispose();
    passCtr.dispose();
    passCheckCtr.dispose();
    nickNameCtr.dispose();
    phoneCtr.dispose();
    answerCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: renderAppbar('회원가입', true, 0xffF9F8F8),
        body: Container(
          color:  const Color(0xffF9F8F8),
          padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      makeText('아이디', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: makeTextFormField('id', idCtr, TextInputType.emailAddress)
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () => duplicateCheck(),
                              style:  ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Color(0x99512f22),
                                backgroundColor: Color(0x1a512f22),
                                  minimumSize: Size(92, 50)
                              ),
                              child: label('중복 확인', 'bold', 16, 'white')
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      makeText('비밀번호', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makePWFormField('pw', passCtr, passwordVisible),
                      const SizedBox(height: 10),
                      makePWFormField('pw_check', passCheckCtr, passwordVisible),
                      const SizedBox(height: 30),
                      makeText('닉네임', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeTextFormField('nickname', nickNameCtr, TextInputType.name),
                      const SizedBox(height: 30),
                      makeText('휴대폰 번호', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeTextFormField('phone', phoneCtr, TextInputType.phone),
                      const SizedBox(height: 30),
                      makeText('질문 & 답변', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeDropDownField(_cnt, '설정한 질문 유형을 선택해주세요'),
                      const SizedBox(height: 10),
                      makeTextFormField('qa_answer', answerCtr, TextInputType.text),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              ),
              ElevatedButton(
                  onPressed: () => _register(),
                  style:ElevatedButton.styleFrom(
                      elevation: 0.2,
                      padding: const EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xfffb8665),
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                  ),
                  child: Text('회원 가입', style: TextStyle(fontSize: 20))
              )
            ],
          ),
        )
    );
  }
  DropDownTextField makeDropDownField(SingleValueDropDownController clr, String hintTxt){
    return DropDownTextField(
      textFieldDecoration: formDecoration(hintTxt),
      controller: clr,
      clearOption: false,
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          return null;
        }
      },
      dropDownList: const [
        DropDownValueModel(name: '다른 이메일 주소는?', value: 0),
        DropDownValueModel(name: '나의 보물 1호는?', value: 1),
        DropDownValueModel(name: '나의 출신 초등학교는?', value: 2),
        DropDownValueModel(name: '나의 이상형은?', value: 3),
        DropDownValueModel(name: '어머니 성함은?', value: 4),
        DropDownValueModel(name: '아버지 성함은?', value: 6),
      ],
      dropDownItemCount: 6,
    );
  }
  // 중복 검사
  void duplicateCheck() async{
    String email = idCtr.text.trim();

    if(!validateEmail(email)){
      Get.snackbar('', '아이디 형식을 지켜주세요', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      return;
    }
    // 1. validation

    // 2. check
    var responseData = await emailOverlapService(email);
    if(responseData == "True"){
      _isDuplicateCheck = true;
      Get.snackbar('중복 검사', '사용 가능한 아이디 입니다.', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    }else{
      Get.snackbar('중복 검사', '중복된 아이디 입니다.', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }
  String? vaild_all(String email, String pass, String nickname, String phone, String qa_answer){
    if(!validateEmail(email)) return '아이디 형식을 지켜주세요';
    if(!_isDuplicateCheck)  return 'ID 중복체크 해주세요.';
    if(!validatePassword(pass)) return '비밀번호 형식이 맞지 않습니다';
    if(pass != passCheckCtr.text.trim()) return '비밀번호 확인이랑 맞지 않습니다';
    if(!validateNickname(nickname)) return '비밀번호 확인이랑 맞지 않습니다';
    if(!validatePhone(phone)) return '휴대폰 번호가 올바르지 않습니다';
    if(!validateQaAnswer(qa_answer)) return '질문&답변을 확인해주세요.';

    return null;
  }
  void _register() async{
    String email = idCtr.text.trim();
    String pass = passCtr.text.trim();
    String nickname = nickNameCtr.text.trim();
    String phone = phoneCtr.text.trim();
    String qaAnswer = answerCtr.text.trim();

    String? vaildResult = vaild_all(email, pass, nickname, phone, qaAnswer);
    if(vaildResult == null){
      var response = await registerService(email, pass, nickname, phone, _cnt.dropDownValue?.value, qaAnswer);
      //print(response);
      Get.snackbar('회원가입 성공', '회원가입에 성공하였습니다. 횐영합니다 \u{1F606}');
      Get.to(() => LoginInit());
    }else{
      Get.snackbar("입력을 확인해주세요", vaildResult);
    }
  }
}
