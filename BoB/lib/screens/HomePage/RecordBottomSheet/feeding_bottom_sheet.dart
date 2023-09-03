import 'package:bob/widgets/pharse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:get/get.dart';

import '../../../services/backend.dart';

class FeedingBottomSheet extends StatefulWidget {

  final int babyId;
  final void Function(int mode, String data, DateTime date) timeFeeding;
  const FeedingBottomSheet (this.babyId, this.timeFeeding, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _FeedingBottomSheet createState() => _FeedingBottomSheet();
}

class _FeedingBottomSheet extends State<FeedingBottomSheet> {

  bool isSelect = true;
  List<DateTime>? dateTimeList;

  GlobalKey<FormState> _fKey = GlobalKey<FormState>();
  String? yearMonthDayTime;
  TextEditingController ymdtController = TextEditingController();
  TextEditingController memoController = TextEditingController();

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
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('feeding'.tr, style: TextStyle(fontSize: 32, color: Color(0xffFF7A7A), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:25, right:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('dir_feed'.tr, style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(top:5, bottom:8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isSelect = true;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0x4d512F22)),
                              foregroundColor: isSelect ? Colors.white : Colors.grey,
                              backgroundColor: isSelect ? const Color(0xffFF7A7A) : null,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('left'.tr,style: TextStyle(fontSize: 16, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold))
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  isSelect = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0x4d512F22)),
                                foregroundColor: !isSelect ? Colors.white : Colors.grey,
                                backgroundColor: !isSelect ? const Color(0xffFF7A7A) : null,
                              ),
                              child: const Padding(
                                  padding:EdgeInsets.all(10),
                                  child:Text('right'.tr,style: TextStyle(fontSize: 16, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold))),
                            )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
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
                          decoration: const InputDecoration(
                              labelText: 'enter_feed'.tr,
                              labelStyle: TextStyle(color: Color(0x99512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                              suffixIcon: Icon(Icons.access_time_filled, color: Color(0xffFF7A7A), size: 22),
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
                  const Text('memo'.tr, style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
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
                        decoration: const InputDecoration(
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
                        print(widget.babyId);
                        int side = isSelect? 0 : 1;
                        String startTime = dateTimeList![0].toString();
                        String endTime = dateTimeList![1].toString();
                        String memo = memoController.text;

                        var content = {"side": side, "startTime": startTime, "endTime": endTime, "memo": memo};
                        var result = await lifesetService(widget.babyId, 0, content.toString());

                        Duration feedingTime = DateTime.now().difference(dateTimeList![1]);
                        widget.timeFeeding(0, getlifeRecordPharse(feedingTime), dateTimeList![1]);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffFF7A7A),
                        foregroundColor: const Color(0xe6ffffff),
                        minimumSize: Size((MediaQuery.of(context).size.width)*0.9, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                      ),
                      child: const Text('register_record',style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w800),),
                    ),
                  )
                ],
              ),
            )
          ],
        )
         ,
      ),
    );
  }
}
