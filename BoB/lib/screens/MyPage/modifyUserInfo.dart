import 'package:bob/screens/MyPage/passwordChange.dart';
import 'package:bob/widgets/appbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/qaTypeList.dart';
import '../../models/model.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';
import '../../services/storage.dart';
import '../../widgets/form.dart';
import '../../widgets/text.dart';
import 'package:get/get.dart' hide Trans;

class ModifyUser extends StatefulWidget{
  final User userInfo;
  const ModifyUser(this.userInfo, {super.key});
  @override
  State<ModifyUser> createState() => _ModifyUser();
}

class _ModifyUser extends State<ModifyUser> {


  late TextEditingController nickNameCtr;
  late TextEditingController phoneCtr;
  late SingleValueDropDownController qaTypeCtr;
  late TextEditingController answerCtr;
  bool passwordVisible = true;
  String newPass = '';
  @override
  void initState() {
    nickNameCtr = TextEditingController(text: widget.userInfo.name);
    phoneCtr = TextEditingController(text: widget.userInfo.phone);
    qaTypeCtr = SingleValueDropDownController(data: qaDataModelList[widget.userInfo.qaType]);
    answerCtr = TextEditingController(text: widget.userInfo.qaAnswer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar('passChange'.tr),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 46, 16, 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('login_id'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextFormField(
                  decoration: formDecoration(widget.userInfo.email),
                  enabled: false,
                ),
              ),
              const SizedBox(height: 30),
              label('login_pass'.tr, 'bold', 14, 'base100'),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15)
                  ),
                  onPressed: () {
                    Get.to(() => ChangePassword(widget.userInfo));
                  },
                  child: label('change_pw'.tr, 'bold', 16, 'base100'),
                ),
              ),
              label('login_nickname'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('nickname', nickNameCtr),
              const SizedBox(height: 30),
              label('login_phone'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('phone', phoneCtr),
              const SizedBox(height: 30),
              label('질문 & 답변', 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              DropDownTextField(
                textFieldDecoration: formDecoration('qaType_input_hint'.tr),
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
              const SizedBox(height: 100),
              ElevatedButton(
                  style: btnStyleForm('white', 'primary', 25),
                  onPressed: () async => await serviceModifyUserinfo(
                      nickNameCtr.text.trim(),
                      phoneCtr.text.trim(),
                      qaTypeCtr.dropDownValue?.value,
                      answerCtr.text.trim()
                  ),
                  child: label('login_modified'.tr,'extra-bold', 16, 'white')
              )
            ],
          ),
        ),
      )
    );
  }

  /// method for modify user information
  serviceModifyUserinfo( String name, String phone, int qaType, String qaAnswer) async {
    // [0] validate
    if (!validateName(name) ||
        !validatePhone(phone) ||
        !validateQaType(qaType) ||
        !validateQaAnswer(qaAnswer)
    ) {
      Get.snackbar('warning'.tr, 'warning_form'.tr);
      return;
    }
    // call modifyUser API
    var re = await editUserService({"name": name, "phone": phone, "qaType": qaType, "qaAnswer": qaAnswer});
    if (re == "Success") {
      Get.back(result: {"name": name, "phone": phone, "qaType": qaType, "qaAnswer": qaAnswer});
    } else {
      Get.snackbar('warning'.tr, 'fail_modify'.tr);
    }
  }
}