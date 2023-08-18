import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../services/backend.dart';

class SleepBottomSheet extends StatefulWidget {

  final int babyId;
  final void Function(int mode, String id) timeSleep;
  const SleepBottomSheet (this.babyId, this.timeSleep, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _SleepBottomSheet createState() => _SleepBottomSheet();
}

class _SleepBottomSheet extends State<SleepBottomSheet> {

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
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('수면',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.blue,
                      fontFamily: 'NanumSquareRound',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
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
                        decoration: const InputDecoration(
                            labelText: '수면 시간을 입력하세요',
                            labelStyle: TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound'),
                            suffixIcon: Icon(Icons.add_alarm_sharp),
                            filled: false, //색 지정
                            enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.blue)
                            ),
                            contentPadding: EdgeInsets.all(10)
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
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    // FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: TextFormField(
                      controller: memoController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 24, fontFamily: 'NanumSquareRound'),
                      decoration: const InputDecoration(
                          floatingLabelBehavior:FloatingLabelBehavior.always, // labelText위치
                          labelText: '메모',
                          labelStyle: TextStyle(fontSize: 30, fontFamily: 'NanumSquareRound'),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.blue)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.orangeAccent)
                          ),
                          contentPadding: EdgeInsets.all(12)
                      ),
                      keyboardType: TextInputType.text,   //키보드 타입
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('취소',style: TextStyle(fontSize: 25, fontFamily: 'NanumSquareRound'),),
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
                        print(widget.babyId);
                        String startTime = dateTimeList![0].toString();
                        String endTime = dateTimeList![1].toString();
                        String memo = memoController.text;

                        var content = {"startTime": startTime, "endTime": endTime, "memo": memo};
                        var result = await lifesetService(widget.babyId, 4, content.toString());

                        String sleepTime = '${DateTime.now().difference(dateTimeList![1]).inMinutes}분 전';
                        widget.timeSleep(4, sleepTime);
                        Navigator.pop(context);
                      },
                      child: Text('확인',style: TextStyle(fontSize: 25, fontFamily: 'NanumSquareRound'),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: BorderSide(
                            color: Colors.blue,
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
