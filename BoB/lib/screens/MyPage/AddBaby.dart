import 'package:bob/models/model.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';

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
class AddBabyBottomSheet extends StatefulWidget {
  const AddBabyBottomSheet({super.key});
  @override
  State<AddBabyBottomSheet> createState() => _AddBabyBottomSheet();
}
class _AddBabyBottomSheet extends State<AddBabyBottomSheet>{
  TextEditingController bNameClr = TextEditingController();
  List<bool> genderSelected = [true, false];
  DateTime birth = DateTime(2023, 01, 01);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 600,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 28, right: 28
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
                child: InkWell(
                    onTap: ()=>_registerBaby(),
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  width: 1.5,
                  color: const Color(0x4D512F22),
                ),
              ),
              child: CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: birth,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      // This is called when the user changes the date.
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => birth = newDate);
                      },
                    ),
                  ),
                  child: text('${birth.year}.${birth.month}.${birth.day}', 'bold', 14, Color(0x99512F22))
              ),
            ),
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
                    genderSelected = [idx == 0, idx == 1];
                  });
                },
                isSelected: genderSelected,
                children: const [
                  SizedBox(
                      width: 174,
                      child: Center(
                          child: Text('남아', style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                      )
                  ),
                  SizedBox(
                      width: 174,
                      child: Center(
                          child: Text('여아', style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                      )
                  ),
                ]
            ),
            const SizedBox(height: 28),
          ],
        )
      ),
    );
  }
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  void _registerBaby() async{
    // validate
    if(bNameClr.text.isEmpty && bNameClr.text.length < 5){
      return;
    }
    //print({"baby_name":bNameClr.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(genderSelected[1]==true?'F':'M'),"ip":null});
    var response = await setBabyService({"baby_name":bNameClr.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(genderSelected[1]==true?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      Get.back();
    }
    return;
  }
}