import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import 'package:bob/widgets/pharse.dart';

import '../../../widgets/form.dart';

class FeedingStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data, DateTime date) changeRecord;

  const FeedingStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);

  @override
  _FeedingStopwatchBottomSheet createState() => _FeedingStopwatchBottomSheet();
}

class _FeedingStopwatchBottomSheet extends State<FeedingStopwatchBottomSheet> {

  bool isSelect = true;   // side 입력
  TextEditingController memoController = TextEditingController();   // 메모 입력

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xffF9F8F8),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
          )
      ),
      padding: bottomSheetPadding(context, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  label('life0'.tr, 'bold', 30, 'feeding')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:25, right:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(        // 모유 수유 타이머 기록 정보
                    children: [
                      label('feeding_time'.tr, 'bold', 15, 'base100'),
                      const SizedBox(width: 5),
                      label('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', 'bold', 20, 'base100')
                    ],
                  ),
                  const SizedBox(height: 15),
                  label('dir_feed'.tr, 'bold', 15, 'base100'),
                  Padding(
                    padding: const EdgeInsets.only(top:5, bottom:8),
                    child: Row(     // 모유 수유 방향 설정
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
                              backgroundColor: isSelect ? const Color(0xffFF7A7A) : null,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: label('left'.tr, 'bold', 15, (isSelect ? 'white' : 'Grey'))
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
                                backgroundColor: !isSelect ? const Color(0xffFF7A7A) : null,
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: label('right'.tr, 'bold', 15, (!isSelect ? 'white' : 'Grey'))),
                            )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  label('memo'.tr, 'bold', 15, 'base100'),
                  const SizedBox(height: 5),
                  SizedBox(         // 메모 입력
                      width: double.infinity,
                      child: TextFormField(
                        controller: memoController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                        decoration: InputDecoration(
                            floatingLabelBehavior:FloatingLabelBehavior.never,
                            labelText: 'enter_content'.tr,
                            labelStyle: const TextStyle(color: Color(0x99512F22), fontSize: 14, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0x4d512F22))
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0x4d512F22))
                            ),
                            contentPadding: const EdgeInsets.only(left: 10, bottom: 20)
                        ),
                        keyboardType: TextInputType.text,   //키보드 타입
                      ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(       // 모유 타이머 기록 제출
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        int side = isSelect? 0 : 1;
                        String memo = memoController.text;
                        var content = {"side": side, "startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        var result = await lifesetService(widget.babyId, 0, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(0, getlifeRecordPharse(diff), widget.endT);
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
                      child: label('register_record'.tr, 'extra-bold', 20, 'white'),
                    ),
                  )
                ],
              )
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
