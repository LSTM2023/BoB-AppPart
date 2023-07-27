import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
import 'package:get/get.dart';
import './editPassword.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

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
                            child: makeTextFormField('아이디를 입력해주세요', idCtr)
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Color(0x99512f22),
                                backgroundColor: Color(0x1a512f22),
                                  minimumSize: Size(92, 50)
                              ),
                              child: Text('중복 확인')
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      makeText('비밀번호', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeTextFormField('비밀번호는 8~16자를 입력해주세요.', passCtr),
                      const SizedBox(height: 10),
                      makeTextFormField('비밀번호 재입력.', passCheckCtr),
                      const SizedBox(height: 30),
                      makeText('닉네임', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeTextFormField('닉네임을 입력해주세요', nickNameCtr),
                      const SizedBox(height: 30),
                      makeText('휴대폰 번호', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeTextFormField('휴대폰번호를 입력해주세요', phoneCtr),
                      const SizedBox(height: 30),
                      makeText('질문 & 답변', Color(0xFF512F22), 14),
                      const SizedBox(height: 10),
                      makeDropDownField(_cnt, '설정한 질문 유형을 선택해주세요'),
                      const SizedBox(height: 10),
                      makeTextFormField('답변', answerCtr),
                      const SizedBox(height: 30),
                    ],
                  ),
                )
              ),
              ElevatedButton(
                  onPressed: (){
                    Get.to(()=> EditPassword());
                  },
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
  SizedBox makeTextFormField(String str, TextEditingController controller){
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: controller,
        decoration: formDecoration(str),
      ),
    );
  }

}
