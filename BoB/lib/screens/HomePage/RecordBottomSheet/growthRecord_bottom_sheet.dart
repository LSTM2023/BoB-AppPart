import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../../services/backend.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:get/get.dart';

class GrowthRecordBottomSheet extends StatefulWidget {

  final int babyId;
  // final void Function(String id) timeFeedingBottle;

  const GrowthRecordBottomSheet (this.babyId, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _GrowthRecordBottomSheet createState() => _GrowthRecordBottomSheet();
}

class _GrowthRecordBottomSheet extends State<GrowthRecordBottomSheet> {


  double? height;
  double? weight;

  DateTime _selectedDate = DateTime.now();

  GlobalKey<FormState> _fKey = GlobalKey<FormState>();
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
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('enter_hweight'.tr,
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff512F22),
                      fontFamily: 'NanumSquareRound',
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
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
                    (height==null) ? Text('select_height'.tr,style: TextStyle(fontSize: 20, color: Colors.grey, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)) :
                    Text('${height.toString()} cm',style: const TextStyle(color: Color(0xff512F22), fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 10),
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
                    (weight==null) ? Text('select_weight'.tr,style: TextStyle(fontSize: 20, color: Colors.grey, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)) :
                    Text('${weight.toString()} kg',style: const TextStyle(color: Color(0xff512F22), fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2040),
                      dateFormat: "yyyy-MMMM-dd",
                      locale: DateTimePickerLocale.ko,
                      looping: true,
                      backgroundColor: const Color(0xffF9F8F8),
                      titleText: 'select_date'.tr,
                      cancelText: 'cancel'.tr,
                      confirmText: 'confirm'.tr,
                      itemTextStyle: const TextStyle(color: Color(0xffFB8665), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                      textColor: const Color(0xff512F22),
                    );
                    ymdtController.text = '${DateFormat('yyyy-MM-dd').format(datePicked!)}';
                    //ymdtController.text = datePicked.toString();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: ymdtController,
                        decoration: InputDecoration(
                            labelText: 'select_date'.tr,
                            labelStyle: TextStyle(color: Color(0x99512f22), fontSize: 15, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                            suffixIcon: Icon(Icons.access_time_filled, color: Color(0xffFB8665)),
                            filled: false, //색 지정
                            enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0xcc512f22))
                            ),
                            contentPadding: EdgeInsets.only(left: 15)
                        ),
                        onSaved: (val) {
                          yearMonthDayTime = '${DateFormat('yyyy-MM-dd').parse(ymdtController.text)}';

                          // yearMonthDayTime = ymdtController.text;
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // OutlinedButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text('취소',style: TextStyle(fontSize: 25, fontFamily: 'NanumSquareRound'),),
                    //   style: OutlinedButton.styleFrom(
                    //       foregroundColor: Colors.black,
                    //       minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.all(Radius.circular(10))
                    //       )
                    //   ),
                    // ),
                    OutlinedButton(
                      onPressed: () async{
                        //print(widget.babyId);
                        double? growthHeight = height;
                        double? growthWeight = weight;
                        String growthDate = ymdtController.text;

                        var result = await growthService(widget.babyId, growthHeight!, growthWeight!, growthDate);
                        print('$growthHeight cm, $growthWeight kg, $growthDate');
                        Navigator.pop(context);
                        print(result);
                      },
                      child: Text('register_record'.tr,style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w800),),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffFB8665),
                          foregroundColor: const Color(0xe6ffffff),
                          minimumSize: Size((MediaQuery.of(context).size.width)*0.9, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                      ),
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