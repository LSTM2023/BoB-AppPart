import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../services/backend.dart';

class FeedingBottleBottomSheet extends StatefulWidget {

  final int babyId;
  final void Function(int mode, String data) timeFeedingBottle;

  const FeedingBottleBottomSheet (this.babyId, this.timeFeedingBottle, {Key? key}) : super(key: key);
  //final String feedingTime;

  @override
  _FeedingBottleBottomSheet createState() => _FeedingBottleBottomSheet();
}

class _FeedingBottleBottomSheet extends State<FeedingBottleBottomSheet> {

  bool isSelect = true;
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
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('젖병',
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xffE59E57),
                      fontFamily: 'NanumSquareRound',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 25, top: 5),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('수유 타입',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontFamily: 'NanumSquareRound',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isSelect = true;
                    });
                  },
                  child: Text('모유',style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound'),),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: isSelect ? Colors.orange[300] : null,
                      minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 35)
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isSelect = false;
                    });
                  },
                  child: Text('분유',style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound'),),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: !isSelect ? Colors.orange[300] : null,
                      minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 35)
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.9,
              child: TextFormField(
                controller: amountController,
                style: const TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound'),
                decoration: InputDecoration(
                    floatingLabelBehavior:FloatingLabelBehavior.always, // labelText위치
                    labelText: '수유량 (ml)',
                    labelStyle: TextStyle(fontSize: 23, fontFamily: 'NanumSquareRound'),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              null;
                            },
                            icon: Icon(Icons.add_circle,size: 22,)
                        ),
                        IconButton(
                            onPressed: () {
                              null;
                            },
                            icon: Icon(Icons.remove_circle,size: 22,)
                        ),
                      ],
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.orange)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    contentPadding: EdgeInsets.only(left: 15)
                ),
                keyboardType: TextInputType.number,   //키보드 타입
              ),
            ),
            const SizedBox(height: 20),
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
                            labelText: '수유 시간을 입력하세요',
                            labelStyle: TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound'),
                            suffixIcon: Icon(Icons.add_alarm_sharp),
                            filled: false, //색 지정
                            enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.orange)
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
                      style: const TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound'),
                      decoration: const InputDecoration(
                          floatingLabelBehavior:FloatingLabelBehavior.always, // labelText위치
                          labelText: '메모',
                          labelStyle: TextStyle(fontSize: 30, color:Colors.black, fontFamily: 'NanumSquareRound'),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.orange)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
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
                        int type = isSelect? 0 : 1;   // 0:모유, 1:분유
                        String amount = amountController.text;
                        String startTime = dateTimeList![0].toString();
                        String endTime = dateTimeList![1].toString();
                        String memo = memoController.text;

                        var content = {"type": type, "amount": amount, "startTime": startTime, "endTime": endTime, "memo": memo,};
                        var result = await lifesetService(widget.babyId, 1, content.toString());

                        String feedingBottleTime = '${DateTime.now().difference(dateTimeList![1]).inMinutes}분 전';
                        widget.timeFeedingBottle(1, feedingBottleTime);
                        Navigator.pop(context);
                      },
                      child: Text('확인',style: TextStyle(fontSize: 25, fontFamily: 'NanumSquareRound'),),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.orange[300],
                          minimumSize: Size((MediaQuery.of(context).size.width)/2*0.8, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: BorderSide(
                            color: Colors.orange,
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
