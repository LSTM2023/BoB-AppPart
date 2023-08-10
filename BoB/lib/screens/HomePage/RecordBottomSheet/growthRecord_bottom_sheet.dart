import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../../services/backend.dart';

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
              padding: const EdgeInsets.only(left: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('키, 몸무게 입력해주세요',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
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
                      activeItemTextColor: Colors.black,
                      passiveItemsTextColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          height = value;
                        });
                      },
                    ),
                    (height==null) ? Text('스크롤하여 키를 선택해 주세요',style: TextStyle(fontSize: 22, color: Colors.grey)) :
                    Text('${height.toString()} cm',style: TextStyle(fontSize: 22),),
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
                    Divider(),
                    HorizontalPicker(
                      minValue: 0,
                      maxValue: 15,
                      divisions: 150,
                      height: 100,
                      suffix: " kg",
                      showCursor: false,
                      backgroundColor: Colors.transparent,
                      activeItemTextColor: Colors.black,
                      passiveItemsTextColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          weight = value;
                        });
                      },
                    ),
                    (weight==null) ? Text('스크롤하여 몸무게를 선택해 주세요',style: TextStyle(fontSize: 22, color: Colors.grey)) :
                    Text('${weight.toString()} kg',style: TextStyle(fontSize: 22),),
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
                      backgroundColor: Colors.grey[100],
                      titleText: '측정 날짜를 선택해주세요',
                      cancelText: '취소',
                      confirmText: '확인',
                      itemTextStyle: const TextStyle(color: Color(0xffef8671)),
                      textColor: Colors.black
                    );
                    ymdtController.text = '${DateFormat('yyyy-MM-dd').format(datePicked!)}';
                    //ymdtController.text = datePicked.toString();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: ymdtController,
                        decoration: const InputDecoration(
                            labelText: '측정 날짜를 선택해주세요',
                            labelStyle: TextStyle(fontSize: 18),
                            suffixIcon: Icon(Icons.add_alarm_sharp),
                            filled: false, //색 지정
                            enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black)
                            ),
                            contentPadding: EdgeInsets.all(10)
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
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('취소',style: TextStyle(fontSize: 25),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                      ),
                    ),
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
                      child: Text('확인',style: TextStyle(fontSize: 25),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: BorderSide(
                            color: Colors.red,
                          )
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