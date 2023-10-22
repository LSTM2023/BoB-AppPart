import 'package:bob/models/model.dart';
import 'package:bob/models/validate.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';

class ModifyBabyBottomSheet extends StatefulWidget {
  final Baby baby;
  const ModifyBabyBottomSheet(this.baby, {super.key});
  @override
  State<ModifyBabyBottomSheet> createState() => _ModifyBabyBottomSheet();
}
class _ModifyBabyBottomSheet extends State<ModifyBabyBottomSheet>{
  // 입력 받은 controller 준비
  late TextEditingController bNameClr;
  late List<bool> bGender;
  late DateTime bBirth;

  @override
  void initState() {
    super.initState();
    bNameClr = TextEditingController(text: widget.baby?.name);
    bGender = [widget.baby?.gender==1, widget.baby?.gender==0];
    bBirth = widget.baby!.birth;
  }
  @override
  void dispose() {
    super.dispose();
    bNameClr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      onTap: () => babyModifyService(
                          widget.baby!.relationInfo.BabyId,
                          bNameClr.text.trim(),
                          bBirth,
                          bGender[1]==true ? 'F' : 'M'
                      ),
                      child: Container(
                        height: 141,
                        width: 141,
                        alignment: Alignment.center,
                        decoration: containerStyleFormRound(),
                        child: const Icon(Icons.check, color: Color(0xFFFB8665), size:40),
                      )
                  )
              ),
              const SizedBox(height: 66),
              label('babyName'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              makeTextFormField('babyName', bNameClr),
              const SizedBox(height: 20),
              label('birth'.tr, 'bold', 14, 'base100'),
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
                    onPressed: (){
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
                              child: CupertinoDatePicker(
                                initialDateTime: bBirth,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => bBirth = newDate);
                                },
                              ),
                            ),
                          ));
                    },
                    child: label('${bBirth.year}.${bBirth.month}.${bBirth.day}', 'bold', 14, 'base60')
                ),
              ),
              const SizedBox(height: 20),
              label('gender'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              ToggleButtons(
                  borderRadius: BorderRadius.circular(8.0),
                  selectedColor : Colors.white,
                  fillColor: const Color(0xfffb8665),
                  color: Colors.grey,
                  onPressed: (int idx){
                    setState(() {
                      bGender = [idx == 0, idx == 1];
                    });
                  },
                  isSelected: bGender,
                  children:  [
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: label('genderM'.tr, 'bold', 14, 'base100')
                        )
                    ),
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: label('genderF'.tr, 'bold', 14, 'base100')
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
}

class AddBabyBottomSheet extends StatefulWidget {
  const AddBabyBottomSheet({super.key});
  @override
  State<AddBabyBottomSheet> createState() => _AddBabyBottomSheet();
}
class _AddBabyBottomSheet extends State<AddBabyBottomSheet>{
  // 입력 받은 controller 준비
  late TextEditingController bNameClr;
  late List<bool> bGender;
  late DateTime bBirth;

  @override
  void initState() {
    bNameClr = TextEditingController();
    bGender = [true, false];
    bBirth = DateTime.now();
  }
  @override
  void dispose() {
    super.dispose();
    bNameClr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      onTap: () => babyRegisterService(
                          bNameClr.text.trim(),
                          bBirth,
                          bGender[1]==true ? 'F' : 'M'
                      ),
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
              label('babyName'.tr, 'bold', 14, 'base60'),
              const SizedBox(height: 10),
              makeTextFormField('babyName', bNameClr),
              const SizedBox(height: 20),
              label('birth'.tr, 'bold', 14, 'base60'),
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
                    onPressed: (){
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
                              child: CupertinoDatePicker(
                                initialDateTime: bBirth,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                // This is called when the user changes the date.
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => bBirth = newDate);
                                },
                              ),
                            ),
                          ));
                    },
                    child: label('${bBirth.year}.${bBirth.month}.${bBirth.day}', 'bold', 14, 'base60')
                ),
              ),
              const SizedBox(height: 20),
              label('gender'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              ToggleButtons(
                  borderRadius: BorderRadius.circular(8.0),
                  selectedColor : Colors.white,
                  fillColor: const Color(0xfffb8665),
                  color: Colors.grey,
                  onPressed: (int idx){
                    setState(() {
                      bGender = [idx == 0, idx == 1];
                    });
                  },
                  isSelected: bGender,
                  children: [
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: label('genderM'.tr, 'bold', 14, 'base100')
                        )
                    ),
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: label('genderF'.tr, 'bold', 14, 'base100')
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
}

/// Method for Modify Baby Information
void babyModifyService(int bId, String bName, DateTime bBirth, String bGender) async {
  // [0] validate
  if(!validateName(bName) || !validateGender(bGender) || !validateGender(bGender)){
    Get.snackbar('warning'.tr, 'warning_form'.tr);
    return;
  }
  // modify baby data API
  var response = await editBabyService(bId, bName, bBirth, bGender);
  if(response == 200){
    Get.back();
  }
}

/// Method for Register New Baby
void babyRegisterService(String bName, DateTime bBirth, String bGender) async {
  // [0] validate
  if(!validateBabyName(bName) || !validateGender(bGender) || !validateBirth(bBirth)){
    Get.snackbar('warning'.tr, 'warning_form'.tr);
    return;
  }
  // register baby API
  var response = await setBabyService(bName, bBirth, bGender);
  if(response['result'] == 'success'){
    Get.back();
  }
}