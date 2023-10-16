import 'package:bob/models/model.dart';
import 'package:bob/widgets/form.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;

class BabyBottomSheet extends StatefulWidget {
  final Baby baby;
  const BabyBottomSheet(this.baby, {super.key});
  @override
  State<BabyBottomSheet> createState() => _BabyBottomSheet();
}

class _BabyBottomSheet extends State<BabyBottomSheet>{
  late TextEditingController bNameClr;
  late List<bool> genderSelected;
  late DateTime birth;
  @override
  void initState() {
    if(widget.baby == null){  // new
      bNameClr = TextEditingController();
      genderSelected = [true, false];
      birth = DateTime(2023, 01, 01);
    }
    else{
      bNameClr = TextEditingController(text: widget.baby.name);
      genderSelected = [widget.baby.gender==1, widget.baby.gender==0];
      birth = widget.baby.birth;
    }
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
                      onTap: ()=>_BabyService(),
                      child: Container(
                        height: 141,
                        width: 141,
                        alignment: Alignment.center,
                        decoration: containerStyleFormRound(),
                        child: const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
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
                    child: label('${birth.year}.${birth.month}.${birth.day}', 'bold', 14, 'base60')
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
                      genderSelected = [idx == 0, idx == 1];
                    });
                  },
                  isSelected: genderSelected,
                  children:  [
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: Text('genderM'.tr, style: const TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                        )
                    ),
                    SizedBox(
                        width: 174,
                        child: Center(
                            child: Text('genderF'.tr, style: const TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
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
  void _BabyService() async{
    String bName = bNameClr.text.trim();
    // validate
    if(bName.isEmpty && bName.length < 5){
      return;
    }
    // modify
    var response = await editBabyService(widget.baby.relationInfo.BabyId, bName, (genderSelected[1]==true?'F':'M'));
    if(response == 200){
      Get.back();
    }
  }
}

class AddBabyBottomSheet extends StatefulWidget {
  const AddBabyBottomSheet({super.key});
  @override
  State<AddBabyBottomSheet> createState() => _AddBabyBottomSheet();
}
/*drawBabyInputForm(context, ServiceFunc, bNameClr, birth, genderSelected){
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
                  onTap: ()=> ServiceFunc,
                  child: Container(
                    height: 141,
                    width: 141,
                    alignment: Alignment.center,
                    decoration: containerStyleFormRound(),
                    child: const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
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
                child: label('${birth.year}.${birth.month}.${birth.day}', 'bold', 14, 'base60')
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
                  genderSelected = [idx == 0, idx == 1];
                });
              },
              isSelected: genderSelected,
              children:  [
                SizedBox(
                    width: 174,
                    child: Center(
                        child: Text('genderM'.tr, style: const TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                    )
                ),
                SizedBox(
                    width: 174,
                    child: Center(
                        child: Text('genderF'.tr, style: const TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                    )
                ),
              ]
          ),
          const SizedBox(height: 28),
        ],
      ),
    ),
  );
}*/
class _AddBabyBottomSheet extends State<AddBabyBottomSheet>{
  TextEditingController bNameClr = TextEditingController();
  List<bool> genderSelected = [true, false];
  DateTime birth = DateTime(2023, 01, 01);

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
                    onTap: () => _registerBaby(),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Color(0xFFFB8665), size:40),
                          label('입력 후 눌러주세요', 'extra-bold', 10, 'grey'),
                        ],
                      )
                    )
                )
            ),
            const SizedBox(height: 66),
            Text('babyName'.tr, style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            makeTextFormField('babyName', bNameClr),
            const SizedBox(height: 20),
            Text('birth'.tr, style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
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
                  child: label('${birth.year}.${birth.month}.${birth.day}', 'bold', 14, 'base60')
              ),
            ),
            const SizedBox(height: 20),
            Text('gender'.tr, style: TextStyle(color: Color(0xFF512F22),fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14)),
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
                children: [
                  SizedBox(
                      width: 174,
                      child: Center(
                          child: Text('genderM'.tr, style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
                      )
                  ),
                  SizedBox(
                      width: 174,
                      child: Center(
                          child: Text('genderF'.tr, style: TextStyle(fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold, fontSize: 14))
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
    String bName = bNameClr.text.trim();
    // validate
    if(bName.isEmpty && bName.length < 5){
      return;
    }
    var response = await setBabyService({"baby_name":bNameClr.text, "birth":DateFormat('yyyy-MM-dd').format(birth), "gender":(genderSelected[1]==true?'F':'M'),"ip":null});
    if(response['result'] == 'success'){
      Get.back();
    }
    return;
  }
}