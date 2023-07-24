import 'package:bob/widgets/appbar.dart';
import 'package:bob/widgets/form.dart';
import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});
  @override
  State<EditPassword> createState() => _EditPassword();
}
class _EditPassword extends State<EditPassword>{
  bool passwordVisible = true;
  late TextEditingController passController;
  late TextEditingController pass2Controller;
  @override
  void initState() {
    passController = TextEditingController();
    pass2Controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    pass2Controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('비밀번호 재설정', true),
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
                        obscureText: passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: 'new password',
                          filled: true,
                          contentPadding: EdgeInsets.all(17),
                          fillColor: Colors.white,
                          enabled: true,
                          enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                    () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          )
                          //border: InputBorder.none
                        )
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: passwordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        controller: pass2Controller,
                          decoration: InputDecoration(
                              hintText: 'check new password',
                              filled: true,
                              contentPadding: EdgeInsets.all(17),
                              fillColor: Colors.white,
                              enabled: true,
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                        () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              )
                            //border: InputBorder.none
                          )
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
            ),
            ElevatedButton(
                onPressed: (){},
                style:ElevatedButton.styleFrom(
                    elevation: 0.2,
                    padding: const EdgeInsets.all(20),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xfffa625f),
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))
                ),
                child: Text('비밀번호 변경하기')
            )
          ],
        ),
      )
    );
  }
}