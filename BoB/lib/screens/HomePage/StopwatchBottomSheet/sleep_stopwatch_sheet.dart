import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import '../../../widgets/pharse.dart';


class SleepStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data) changeRecord;
  const SleepStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);
  //final String feedingTime;

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
    return Padding(
      padding: const EdgeInsets.all(10),//MediaQuery.of(context).viewInsets,
      child: Container(
        color: Colors.white,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수면', style: TextStyle(fontSize: 35, color: Colors.blue, fontFamily: 'NanumSquareRound')),
                  IconButton(
                      onPressed: (){
                        Get.back();
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
                  Row(
                    children: [
                      const Text('수면 시간', style: TextStyle(fontSize: 17, color: Colors.grey, fontFamily: 'NanumSquareRound')),
                      const SizedBox(width: 20),
                      Text('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', style: const TextStyle(fontSize: 24, fontFamily: 'NanumSquareRound')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: memoController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                        decoration: const InputDecoration(
                            floatingLabelBehavior:FloatingLabelBehavior.always,
                            labelText: '메모',
                            labelStyle: TextStyle(fontSize: 24, color:Colors.black, fontFamily: 'NanumSquareRound'),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.blue)
                            ),
                            contentPadding: EdgeInsets.all(12)
                        ),
                        keyboardType: TextInputType.text,   //키보드 타입
                      ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{

                        String memo = memoController.text;
                        var content = {"startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        var result = await lifesetService(widget.babyId, 4, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(4, getlifeRecordPharse(diff));
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          foregroundColor: Colors.blue,
                          //backgroundColor: Color(0xffff9f98),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: const BorderSide(
                            color: Colors.blue,
                          )
                      ),
                      child: const Text('확인',style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound')),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
