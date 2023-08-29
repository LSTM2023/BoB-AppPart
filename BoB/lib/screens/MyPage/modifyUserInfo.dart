import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/model.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';
import '../../services/storage.dart';
import '../../widgets/form.dart';
import '../../widgets/text.dart';

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
      appBar: homeAppbar('회원정보 수정'),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 46, 16, 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBase('아이디', 'bold', 14),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextFormField(
                  decoration: formDecoration(widget.userInfo.email),
                  enabled: false,
                ),
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
              const SizedBox(height: 100),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xffFB8665),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      foregroundColor: Colors.white
                  ),
                  onPressed: () async => await modifyUserinfo(),
                  child: text('수정완료','extra-bold', 16, Colors.white)
              )
            ],
          ),
        ),
      )
    );

  }
  modifyUserinfo() async {
    // 1. validate
    String pass = passCtr.text.trim();
    String name = nickNameCtr.text.trim();
    String phone = phoneCtr.text.trim();
    if (!validatePassword(pass) &&
        !validateName(name) &&
        !validatePhone(phone)) {
      return;
    }
    // 2. modify
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