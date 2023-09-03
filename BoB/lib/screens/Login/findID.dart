import 'package:bob/models/model.dart';
import 'package:bob/models/validate.dart';
import 'package:bob/services/backend.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../widgets/form.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

import '../../widgets/text.dart';

class Login_findID extends StatefulWidget{
  const Login_findID({super.key});
  @override
  State<Login_findID> createState() => _Login_findID();
}
class _Login_findID extends State<Login_findID>{
  late SingleValueDropDownController _cnt;
  late TextEditingController phoneController;
  late TextEditingController answerController;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    phoneController = TextEditingController();
    answerController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _cnt.dispose();
    answerController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('아이디 찾기', true, 0xffF9F8F8),
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
                        decoration: formDecoration('핸드폰 번호를 입력해주세요'),
                        inputFormatters: [
                          MultiMaskedTextInputFormatter(
                              masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
                        ],
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: phoneController,
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
                  findID();
                },
                style:ElevatedButton.styleFrom(
                  elevation: 0.2,
                    padding: const EdgeInsets.all(20),
                    foregroundColor: Colors.white,
                    backgroundColor:  const Color.fromRGBO(251, 134, 101, 1),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                ),
                child: text('아이디 찾기', 'bold', 18, Colors.white)
            )
          ],
        ),
      )
    );
  }
  findID() async{
    String phone = phoneController.text.trim();
    String answer = answerController.text.trim();
    if(!validatePhone(phone) || !validateQaAnswer(answer))
      return;
    print(phone);
    var res = await findIDService(phone, answer);
    print(res);
  }
}