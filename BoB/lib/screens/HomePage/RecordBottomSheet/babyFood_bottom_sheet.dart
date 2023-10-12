import 'package:bob/widgets/pharse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:get/get.dart';

import '../../../services/backend.dart';

class BabyFoodBottomSheet extends StatefulWidget {

  final int babyId;
  final void Function(int mode, String id, DateTime date) timeBabyFood;

  const BabyFoodBottomSheet (this.babyId, this.timeBabyFood, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _BabyFoodBottomSheet createState() => _BabyFoodBottomSheet();
}

class _BabyFoodBottomSheet extends State<BabyFoodBottomSheet> {


  List<DateTime>? dateTimeList;

  GlobalKey<FormState> _fKey = GlobalKey<FormState>();
  String? yearMonthDayTime;
  TextEditingController ymdtController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController amountController = TextEditingController(text: '100');


  bool autovalidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.51,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('life2'.tr, style: TextStyle(fontSize: 32, color: Color(0xfffF9B58), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        dateTimeList = await showOmniDateTimeRangePicker(
                          context: context,
                          startInitialDate: DateTime.now(),
                          startFirstDate:
                          DateTime(1600).subtract(const Duration(days: 3652)),
                          startLastDate: DateTime.now().add(
                            const Duration(days: 3652),
                          ),
                          endInitialDate: DateTime.now(),
                          endFirstDate:
                          DateTime(1600).subtract(const Duration(days: 3652)),
                          endLastDate: DateTime.now().add(
                            const Duration(days: 3652),
                          ),
                          is24HourMode: true,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          constraints: const BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          transitionBuilder: (context, anim1, anim2, child) {
                            return FadeTransition(
                              opacity: anim1.drive(
                                Tween(
                                  begin: 0,
                                  end: 1,
                                ),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 200),
                          barrierDismissible: true,
                          selectableDayPredicate: (dateTime) {
                            // Disable 25th Feb 2023
                            if (dateTime == DateTime(2023, 2, 25)) {
                              return false;
                            } else {
                              return true;
                            }
                          },
                        );
                        ymdtController.text = '${DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateTimeList![0])} ~ '
                            '${DateFormat('HH:mm').format(dateTimeList![1])}';

                        print("Start dateTime: ${dateTimeList?[0]}");
                        print("End dateTime: ${dateTimeList?[1]}");
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: ymdtController,
                            decoration: InputDecoration(
                                labelText: 'enter_food'.tr,
                                labelStyle: TextStyle(color: Color(0x99512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                                suffixIcon: Icon(Icons.access_time_filled, color: Color(0xfffF9B58), size: 22,),
                                filled: false, //색 지정
                                enabledBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(color: Color(0x4d512F22))
                                ),
                                contentPadding: EdgeInsets.all(12)
                            ),
                            onSaved: (val) {
                              yearMonthDayTime = ymdtController.text;
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
                    const SizedBox(height: 15),
                    Text('amount_food'.tr, style: TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: TextFormField(
                          controller: amountController,
                          style: const TextStyle(fontSize: 16, color: Color(0x99512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              floatingLabelBehavior:FloatingLabelBehavior.never, // labelText위치
                              labelText: 'amount_food'.tr,
                              labelStyle: const TextStyle(color: Color(0x4d512F22), fontSize: 23, fontFamily: 'NanumSquareRound'),
                              suffixIcon: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        null;
                                      },
                                      icon: const Icon(Icons.add_circle,size: 22, color: Color(0xfffF9B58))
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        null;
                                      },
                                      icon: const Icon(Icons.remove_circle,size: 22, color: Color(0xfffF9B58))
                                  ),
                                ],
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0x4d512F22))
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0x4d512F22))
                              ),
                              contentPadding: const EdgeInsets.only(left: 15)
                          ),
                          keyboardType: TextInputType.number,   //키보드 타입
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text('memo'.tr, style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: memoController,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                          decoration: InputDecoration(
                              floatingLabelBehavior:FloatingLabelBehavior.never,
                              labelText: 'enter_content'.tr,
                              labelStyle: TextStyle(color: Color(0x99512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0x4d512F22))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0x4d512F22))
                              ),
                              contentPadding: EdgeInsets.only(left: 10, bottom: 20,)
                          ),
                          keyboardType: TextInputType.text,   //키보드 타입
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async{
                          print(widget.babyId);   // 0:모유, 1:분유
                          String amount = amountController.text;
                          String startTime = dateTimeList![0].toString();
                          String endTime = dateTimeList![1].toString();
                          String memo = memoController.text;

                          var content = {"amount": amount, "startTime": startTime, "endTime": endTime, "memo": memo,};
                          var result = await lifesetService(widget.babyId, 2, content.toString());

                          Duration babyFoodTime = DateTime.now().difference(dateTimeList![1]);
                          widget.timeBabyFood(2, getlifeRecordPharse(babyFoodTime), dateTimeList![1]);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xfffF9B58),
                          foregroundColor: const Color(0xe6ffffff),
                          minimumSize: Size((MediaQuery.of(context).size.width)*0.9, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                        ),
                        child: Text('register_record'.tr,style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w800),),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
