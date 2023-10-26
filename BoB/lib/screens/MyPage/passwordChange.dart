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

class ChangePassword extends StatefulWidget{
  final User userInfo;
  const ChangePassword(this.userInfo, {super.key});
  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {

  late TextEditingController passCtr;
  late TextEditingController passCheckCtr;
  bool passwordVisible = true;

  @override
  void initState() {
    passCtr = TextEditingController(text: widget.userInfo.password1);
    passCheckCtr = TextEditingController(text: widget.userInfo.password1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar('main4_modifyUserInfo'.tr),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 46, 16, 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              label('login_pass'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makePWFormField('pw', passCtr, passwordVisible),
              const SizedBox(height: 10),
              makePWFormField('pw_check', passCheckCtr, passwordVisible),
              const SizedBox(height: 100),
              ElevatedButton(
                  style: btnStyleForm('white', 'primary', 25),
                  onPressed: () async => await serviceModifyUserinfo(
                    passCtr.text.trim(),
                    passCheckCtr.text.trim()
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
  serviceModifyUserinfo(String pass, String passCheck) async {
    // [0] validate
    if (!validatePassword(pass) || !validatePasswordCheck(pass, passCheck))
    {
      Get.snackbar('warning'.tr, 'warning_form'.tr);
      return;
    }
    // call changePass API & edit local DB
    if(await passwordChangeService(pass) != null) {
      Get.snackbar('수정 성공', '수정 성공하였습니다');
      // (1) 비번 변경시 -> 내부 저장소 변경
      if (pass != widget.userInfo.password1) {
        await editPasswordLoginStorage(pass); // 내부 저장소 변경
      }
      Navigator.pop(context);
    } else {
      Get.snackbar('수정 실패', '수정에 실패하였습니다');
    }
  }
}