import 'package:bob/screens/Login/initPage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../models/qaTypeList.dart';
import '../../models/validate.dart';
import '../../widgets/text.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
import '../../services/backend.dart';

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
        appBar: homeAppbar('회원 가입'),
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
                      label('아이디', 'bold', 14, 'base100'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: makeTextFormField('id', idCtr)
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () => duplicateCheck(idCtr.text.trim()),
                              style:  ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: const Color(0x99512f22),
                                backgroundColor: const Color(0x1a512f22),
                                  minimumSize: const Size(92, 50)
                              ),
                              child: label('중복 확인', 'bold', 16, 'white')
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      label('비밀번호', 'bold', 14, 'base100'),
                      const SizedBox(height: 10),
                      makePWFormField('pw', passCtr, passwordVisible),
                      const SizedBox(height: 10),
                      makePWFormField('pw_check', passCheckCtr, passwordVisible),
                      const SizedBox(height: 30),
                      label('닉네임', 'bold', 14, 'base100'),
                      const SizedBox(height: 10),
                      makeTextFormField('nickname', nickNameCtr),
                      const SizedBox(height: 30),
                      label('휴대폰 번호', 'bold', 14, 'base100'),
                      const SizedBox(height: 10),
                      makeTextFormField('phone', phoneCtr),
                      const SizedBox(height: 30),
                      label('질문 & 답변', 'bold', 14, 'base100'),
                      const SizedBox(height: 10),
                      DropDownTextField(
                          textFieldDecoration: formDecoration('설정한 질문 유형을 선택해주세요'),
                          controller: _cnt,
                          clearOption: false,
                          validator: (value) {
                            if (value == null) {
                              return "Required field";
                            } else {
                              return null;
                            }
                          },
                          dropDownList: qaDataModelList,
                          dropDownItemCount: 6,
                      ),
                      const SizedBox(height: 10),
                      makeTextFormField('qa_answer', answerCtr),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              ),
              ElevatedButton(
                  onPressed: () => _register(
                    idCtr.text.trim(),
                    passCtr.text.trim(),
                    nickNameCtr.text.trim(),
                    phoneCtr.text.trim(),
                    _cnt.dropDownValue?.value,
                    answerCtr.text.trim()
                  ),
                  style: btnStyleForm('white', 'primary', 15.0),
                  child: label('회원가입', 'bold', 20, 'white')
              )
            ],
          ),
        )
    );
  }
  /// [1] method for id duplicate check
  void duplicateCheck(String email) async{
    // 1. validation
    if(!validateEmail(email)){
      Get.snackbar('warning'.tr, 'keep_id'.tr);
      return;
    }
    // 2. call overlap API
    var responseData = await emailOverlapServiceFresh(email);
    if(responseData == "True"){
      _isDuplicateCheck = true;
      Get.snackbar('중복 검사', '사용 가능한 아이디 입니다.');
    }else{
      Get.snackbar('중복 검사', '중복된 아이디 입니다.');
    }
  }
  /// [2] method for register
  void _register(String email, String pass, String nickname, String phone, int qaType, String qaAnswer) async{
    // 1. validation
    String? validResult;
    if(!validateEmail(email)) validResult = '아이디 형식을 지켜주세요';
    if(!_isDuplicateCheck)  validResult =  'ID 중복체크 해주세요.';
    if(!validatePassword(pass)) validResult =  '비밀번호 형식이 맞지 않습니다';
    if(pass != passCheckCtr.text.trim()) validResult =  '비밀번호 확인이랑 맞지 않습니다';
    if(!validateName(nickname)) validResult =  '이름 형식을 지켜주세요';
    if(!validatePhone(phone)) validResult =  '휴대폰 번호가 올바르지 않습니다';
    if(!validateQaType(qaType)) validResult =  '질문&답변을 확인해주세요.';
    if(!validateQaAnswer(qaAnswer)) validResult =  '질문&답변을 확인해주세요.';
    if(validResult != null){
      Get.snackbar("주의", validResult);
      return;
    }
    // 2. call register API
    var response = await registerService(email, pass, nickname, phone, qaType, qaAnswer);
    Get.snackbar('회원가입 성공', '회원가입에 성공하였습니다. 횐영합니다 \u{1F606}');
    Get.to(() => LoginInit());
  }
}