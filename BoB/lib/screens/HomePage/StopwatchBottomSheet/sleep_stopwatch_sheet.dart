import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import '../../../widgets/form.dart';
import '../../../widgets/pharse.dart';


class SleepStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data, DateTime date) changeRecord;
  const SleepStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);

  @override
  State<SleepStopwatchBottomSheet> createState() => _SleepStopwatchBottomSheet();
}

class _SleepStopwatchBottomSheet extends State<SleepStopwatchBottomSheet> {

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
                  label('life4'.tr, 'bold', 30, 'sleep')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:25, right:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(        // 수면 타미어 시간 출력
                    children: [
                      label('sleeping_time'.tr, 'bold', 15, 'base100'),
                      const SizedBox(width: 5),
                      label('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', 'bold', 20, 'base100')
                    ],
                  ),
                  const SizedBox(height: 15),
                  label('memo'.tr, 'bold', 15, 'base100'),
                  const SizedBox(height: 5),
                  SizedBox(       // 메모 입력
                    width: double.infinity,
                    child: TextFormField(
                      controller: memoController,
                      maxLines: 4,
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
                          contentPadding: const EdgeInsets.only(left: 10, bottom: 20,)
                      ),
                      keyboardType: TextInputType.text,   //키보드 타입
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(     // 수면 타이머 기록 제출
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        String memo = memoController.text;
                        var content = {"startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        var result = await lifesetService(widget.babyId, 4, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(4, getlifeRecordPharse(diff), widget.endT);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff5086BC),
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
