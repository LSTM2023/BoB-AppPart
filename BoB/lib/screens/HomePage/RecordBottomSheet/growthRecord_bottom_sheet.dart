import 'package:bob/models/model.dart';
import 'package:bob/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../../services/backend.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:get/get.dart';

class GrowthRecordBottomSheet extends StatefulWidget {
  final Baby baby;
  final int babyId;

  const GrowthRecordBottomSheet(this.baby, this.babyId, {Key? key}) : super(key: key);

  @override
  _GrowthRecordBottomSheet createState() => _GrowthRecordBottomSheet();
}

class _GrowthRecordBottomSheet extends State<GrowthRecordBottomSheet> {

  double? height;
  double? weight;

  String? yearMonthDayTime;
  TextEditingController ymdtController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  label('enter_hweight'.tr, 'bold', 22, 'base100')
                ],
              ),
            ),
            SafeArea(       // 키 설정
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HorizontalPicker(
                      minValue: 0,
                      maxValue: 100,
                      divisions: 1000,
                      height: 100,
                      suffix: " cm",
                      showCursor: false,
                      backgroundColor: Colors.transparent,
                      activeItemTextColor: const Color(0xff512F22),
                      passiveItemsTextColor: const Color(0xffFB8665),
                      onChanged: (value) {
                        setState(() {
                          height = value;
                        });
                      },
                    ),
                    (height==null) ? label('select_height'.tr, 'bold', 20, 'Grey') : label('${height.toString()} cm', 'bold', 20, 'base100'),
                  ],
                ),
              ),
            ),
            SafeArea(       // 몸무게 설정
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Divider(color: Color(0xff512F22)),
                    HorizontalPicker(
                      minValue: 0,
                      maxValue: 15,
                      divisions: 150,
                      height: 100,
                      suffix: " kg",
                      showCursor: false,
                      backgroundColor: Colors.transparent,
                      activeItemTextColor: const Color(0xff512F22),
                      passiveItemsTextColor: Colors.blueAccent,
                      onChanged: (value) {
                        setState(() {
                          weight = value;
                        });
                      },
                    ),
                    (weight==null) ? label('select_weight'.tr, 'bold', 20, 'Grey') : label('${weight.toString()} kg', 'bold', 20, 'base100'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(      // 측정 날짜 설정
                  onTap: () async {
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime.now(),
                      firstDate: widget.baby.birth,
                      lastDate: DateTime.now(),
                      dateFormat: "yyyy-MMMM-dd",
                      locale: DateTimePickerLocale.ko,
                      looping: false,
                      backgroundColor: const Color(0xffF9F8F8),
                      titleText: 'select_date'.tr,
                      cancelText: 'cancel'.tr,
                      confirmText: 'confirm'.tr,
                      itemTextStyle: const TextStyle(color: Color(0xffFB8665), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                      textColor: const Color(0xff512F22),
                    );
                    ymdtController.text = DateFormat('yyyy-MM-dd').format(datePicked!);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: ymdtController,
                        decoration: InputDecoration(
                            labelText: 'select_date'.tr,
                            labelStyle: const TextStyle(color: Color(0x99512f22), fontSize: 15, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                            suffixIcon: const Icon(Icons.access_time_filled, color: Color(0xffFB8665)),
                            filled: false, //색 지정
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0xcc512f22))
                            ),
                            contentPadding: const EdgeInsets.only(left: 15)
                        ),
                        onSaved: (val) {
                          yearMonthDayTime = '${DateFormat('yyyy-MM-dd').parse(ymdtController.text)}';
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Year-Month-Date is necessary';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(    // 성장 기록 제출
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () async{
                        print(widget.babyId);
                        double? growthHeight = height;
                        double? growthWeight = weight;
                        String growthDate = ymdtController.text;

                        var result = await growthService(widget.babyId, growthHeight!, growthWeight!, growthDate);
                        print('$growthHeight cm, $growthWeight kg, $growthDate');
                        Navigator.pop(context);
                        print(result);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffFB8665),
                          foregroundColor: const Color(0xe6ffffff),
                          minimumSize: Size((MediaQuery.of(context).size.width)*0.9, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                      ),
                      child: label('register_record'.tr, 'extra-bold', 20, 'white'),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}