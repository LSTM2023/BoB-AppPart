import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../services/backend.dart';

class FeedingBottomSheet extends StatefulWidget {

  final int babyId;
  final void Function(int mode, String data) timeFeeding;
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
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수유', style: TextStyle(fontSize: 35, color: Color(0xfff77b72))),
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color:Colors.grey)
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:25, right:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('수유 방향', style: TextStyle(fontSize: 17, color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.only(top:10, bottom:10),
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
                                foregroundColor: Colors.black,
                                backgroundColor: isSelect ? const Color(0xfff77b72) : null,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text('왼쪽',style: TextStyle(fontSize: 20))
                            ),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  isSelect = false;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: !isSelect ? const Color(0xfff77b72) : null,
                              ),
                              child: const Padding(padding:EdgeInsets.all(5), child:Text('오른쪽',style: TextStyle(fontSize: 20))),

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
                              labelText: '수유 시간을 입력하세요',
                              labelStyle: TextStyle(fontSize: 18),
                              suffixIcon: Icon(Icons.add_alarm_sharp),
                              filled: false, //색 지정
                              enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Color(0xfff77b72))
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
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: memoController,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 20),
                        decoration: const InputDecoration(
                            floatingLabelBehavior:FloatingLabelBehavior.always,
                            labelText: '메모',
                            labelStyle: TextStyle(fontSize: 30, color:Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0xfff77b72))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0xfff77b72))
                            ),
                            contentPadding: EdgeInsets.all(12)
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

                        String feedingTime = '${DateTime.now().difference(dateTimeList![1]).inMinutes}분 전';
                        widget.timeFeeding(0, feedingTime);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                          foregroundColor: Colors.red,
                          //backgroundColor: Color(0xffff9f98),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: const BorderSide(
                            color: Colors.red,
                          )
                      ),
                      child: const Text('확인',style: TextStyle(fontSize: 20)),
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
