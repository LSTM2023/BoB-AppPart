import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../widgets/form.dart';
import 'package:get/get.dart';
import './editPassword.dart';

class Login_findPass extends StatefulWidget{
  const Login_findPass({super.key});
  @override
  State<Login_findPass> createState() => _Login_findPass();
}
class _Login_findPass extends State<Login_findPass>{
  late SingleValueDropDownController _cnt;
  late TextEditingController idController;
  late TextEditingController answerController;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    idController = TextEditingController();
    answerController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _cnt.dispose();
    answerController.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('비밀번호 찾기', true, 0xffF9F8F8),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: formDecoration('아이디를 입력해주세요'),
                      ),
                      const SizedBox(height: 20),
                      //Text('질문'),
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
                        dropDownList: const [
                          DropDownValueModel(name: '다른 이메일 주소는?', value: 0),
                          DropDownValueModel(name: '나의 보물 1호는?', value: 1),
                          DropDownValueModel(name: '나의 출신 초등학교는?', value: 2),
                          DropDownValueModel(name: '나의 이상형은?', value: 3),
                          DropDownValueModel(name: '어머니 성함은?', value: 4),
                          DropDownValueModel(name: '아버지 성함은?', value: 6),
                        ],
                        dropDownItemCount: 6,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: answerController,
                        decoration: formDecoration('답변을 입력해주세요'),
                      ),
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
                    backgroundColor: const Color(0xfffa625f),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                ),
                child: Text('비밀번호 찾기')
            )
          ],
        ),
      )
    );
  }
}
