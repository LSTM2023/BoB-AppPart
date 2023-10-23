import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/qaTypeList.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
import '../../widgets/text.dart';

class SLogAddiInfo extends StatefulWidget{
  final socialType;
  final Map<String, String> autoInfo;
  const SLogAddiInfo(this.autoInfo, {super.key, this.socialType});

  @override
  State<SLogAddiInfo> createState() => _SLogAddiInfo();
}

class _SLogAddiInfo extends State<SLogAddiInfo>{

  late TextEditingController phoneCtr;
  late SingleValueDropDownController qaTypeCtr;
  late TextEditingController answerCtr;

  @override
  void initState() {
    Get.snackbar('간편 로그인', '원활한 서비스 사용을 위해 추가적인 정보를 입력해 주세요 \u{1F604}');
    phoneCtr = TextEditingController(text: widget.autoInfo['phone']);
    qaTypeCtr = SingleValueDropDownController();
    answerCtr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    phoneCtr.dispose();
    qaTypeCtr.dispose();
    answerCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar2('추가 정보 입력', false),
      body: Container(
        color:  const Color(0xffF9F8F8),
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('휴대폰 번호', 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('phone', phoneCtr),
              const SizedBox(height: 30),
              label('질문 & 답변', 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              DropDownTextField(
                textFieldDecoration: formDecoration('설정한 질문 유형을 선택해주세요'),
                controller: qaTypeCtr,
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
              ElevatedButton(
                  onPressed: () => registerSocialUser(),
                  style: btnStyleForm('white', 'primary', 15.0),
                  child: label('입력 완료', 'bold', 20, 'white')
              )
            ],
          ),
        ),
      ),
    );
  }
  /// [1] method for register - new social login user
  void registerSocialUser() async{
    // 1. validation
    String phone = phoneCtr.text.trim();
    int qaType = qaTypeCtr.dropDownValue?.value;
    String qaAnswer = answerCtr.text.trim();
    String? validResult;
    if(!validatePhone(phone)) validResult =  '휴대폰 번호가 올바르지 않습니다';
    if(!validateQaType(qaType)) validResult =  '질문&답변을 확인해주세요.';
    if(!validateQaAnswer(qaAnswer)) validResult =  '질문&답변을 확인해주세요.';
    if(validResult != null){
      Get.snackbar("주의", validResult);
      return;
    }
    // 2. call register API
    var response = await registerService(widget.autoInfo['email'], 'lstm123!@#', widget.autoInfo['nickname'], phone, qaType, qaAnswer);
    Get.back();
  }
}