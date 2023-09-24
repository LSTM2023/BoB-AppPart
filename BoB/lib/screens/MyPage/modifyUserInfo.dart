import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  late TextEditingController passCtr;
  late TextEditingController passCheckCtr;
  late TextEditingController nickNameCtr;
  late TextEditingController phoneCtr;
  bool passwordVisible = true;

  @override
  void initState() {
    passCtr = TextEditingController(text: widget.userInfo.password1);
    passCheckCtr = TextEditingController(text: widget.userInfo.password1);
    nickNameCtr = TextEditingController(text: widget.userInfo.name);
    phoneCtr = TextEditingController(text: widget.userInfo.phone);
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
              const SizedBox(height: 10),
              makePWFormField('pw', passCtr, passwordVisible),
              const SizedBox(height: 10),
              makePWFormField('pw_check', passCheckCtr, passwordVisible),
              const SizedBox(height: 30),
              label('login_nickname'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('nickname', nickNameCtr, TextInputType.name),
              const SizedBox(height: 30),
              label('login_phone'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('phone', phoneCtr, TextInputType.phone),
              const SizedBox(height: 100),
              ElevatedButton(
                  style: btnStyleForm('white', 'primary'),
                  onPressed: () async => await serviceModifyUserinfo(),
                  child: label('login_modified'.tr,'extra-bold', 16, 'white')
              )
            ],
          ),
        ),
      )
    );

  }
  /// method for modify user information
  serviceModifyUserinfo() async {
    // 1. validate
    String pass = passCtr.text.trim();
    String name = nickNameCtr.text.trim();
    String phone = phoneCtr.text.trim();
    if (!validatePassword(pass) &&
        !validateName(name) &&
        !validatePhone(phone)) {
      return;
    }
    // call modifyUser API & edit local DB
    if (await editUserService({"password": pass, "name": name, "phone": phone}) == "True") {
      // (1) 비번 변경시 -> 내부 저장소 변경
      if (pass != widget.userInfo.password1) {
        await editPasswordLoginStorage(pass); // 내부 저장소 변경
      }
      Get.back(result: {"pass": pass, "name": name, "phone": phone});
    } else {
      Get.snackbar('수정 실패', '수정에 실패하였습니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
    }
  }
}