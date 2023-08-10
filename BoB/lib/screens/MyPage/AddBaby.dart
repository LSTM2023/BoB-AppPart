import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
import 'package:get/get.dart';

import '../BaseWidget.dart';

class AddBaby extends StatefulWidget {
  const AddBaby({super.key});
  @override
  State<AddBaby> createState() => _AddBaby();
}
class _AddBaby extends State<AddBaby>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('add baby', false, 0xffffffff),
      body: Text(''),
    );
  }
}

class AddBabyBottomSheet extends StatefulWidget{

  @override
  State<AddBabyBottomSheet> createState() => _AddBabyBottomSheet();
}
class _AddBabyBottomSheet extends State<AddBabyBottomSheet> {
  TextEditingController bNameClr = TextEditingController();
  TextEditingController bBirthClr = TextEditingController();
  List<bool> birthSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      padding: const EdgeInsets.only(left: 17, right: 17),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: InkWell(
                onTap: ()=> _registerBaby(),
                child: Container(
                    height: 141,
                    width: 141,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xCCFFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffC1C1C1),
                          width: 0.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          )
                        ]
                    ),
                    child: const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
                )
              )
            ),
            const SizedBox(height: 66),
            const Text('아기 이름', style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            makeTextFormField('babyName', bNameClr, TextInputType.text),
            const SizedBox(height: 20),
            const Text('생일', style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            makeTextFormField('babyBirth', bBirthClr, TextInputType.text),
            const SizedBox(height: 20),
            const Text('성별', style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            ToggleButtons(
                borderRadius: BorderRadius.circular(8.0),
                selectedColor : Colors.white,
                fillColor: const Color(0xfffb8665),
                color: Colors.grey,
                onPressed: (int idx){
                  setState(() {
                    birthSelected = [idx == 0, idx == 1];
                  });
                },
                isSelected: birthSelected,
                children: const [
                  SizedBox(
                      width: 170,
                      child: Center(
                          child: Text('남아', style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                      )
                  ),
                  SizedBox(
                      width: 170,
                      child: Center(
                          child: Text('여아', style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                      )
                  ),
                ]
            )
          ],
        ),
      )
    );
  }
  void _registerBaby() async{
    // validate
    if(bNameClr.text.isEmpty && bBirthClr.text.length < 5){
      return;
    }
    var response = await setBabyService({"baby_name":bNameClr.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(isSelected[1]==true?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      Baby_relation r = Baby_relation(11, 0, 255, "", "", true);
      Baby b = Baby(nameController.text, birth, (isSelected[1]==true? 0 : 1), r);
      Get.offAll(() => BaseWidget(widget.userInfo, [b]));
    }
  }
}