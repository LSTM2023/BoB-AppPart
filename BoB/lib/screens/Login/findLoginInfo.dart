import 'package:flutter/material.dart';
import '../../widgets/form.dart';
import '../../widgets/appbar.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:get/get.dart';

class FindLoginInfo extends StatefulWidget{
  int fType;
  FindLoginInfo(this.fType, {super.key});
  @override
  State<FindLoginInfo> createState() => _FindLoginInfo();
}
class _FindLoginInfo extends State<FindLoginInfo>{
  late TextEditingController controller;
  late String fTypeTitle;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    fTypeTitle = (widget.fType == 0)?"아이디":"비밀번호";
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('$fTypeTitle 찾기', true, 0xffF9F8F8),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            makeForm(),
            ElevatedButton(
                onPressed: (){
                  //Get.to(()=>inquiry())
                },
                child: Text('조회')
            )
          ],
        ),
      )
    );
  }
  TextFormField makeForm(){
    if(fTypeTitle==0){
      return TextFormField(
        decoration: formDecoration('아이디를 입력해주세요'),
        keyboardType: TextInputType.emailAddress,
        controller: controller,
      );
    }
    else{
      return TextFormField(
        decoration: formDecoration('핸드폰 번호를 입력해주세요'),
        inputFormatters: [
          MultiMaskedTextInputFormatter(
              masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
        ],
        keyboardType: TextInputType.number,
        controller: controller,

      );
    }
  }
}