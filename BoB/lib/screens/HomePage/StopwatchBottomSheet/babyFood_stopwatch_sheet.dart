import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import '../../../widgets/pharse.dart';


class BabyFoodStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data) changeRecord;

  const BabyFoodStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);
  //final String feedingTime;

  @override
  State<BabyFoodStopwatchBottomSheet> createState() => _BabyFoodStopwatchBottomSheet();
}

class _BabyFoodStopwatchBottomSheet extends State<BabyFoodStopwatchBottomSheet> {

  TextEditingController memoController = TextEditingController();   // 메모 입력
  TextEditingController amountController = TextEditingController(text: '100');

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
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이유식', style: TextStyle(fontSize: 35, color: Colors.yellow[700])),
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
                      const Text('이유식 시간', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      const SizedBox(width: 20),
                      Text('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                        floatingLabelBehavior:FloatingLabelBehavior.always, // labelText위치
                        labelText: '수유량 (ml)',
                        labelStyle: TextStyle(fontSize: 25),
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
                                icon: const Icon(Icons.add_circle,size: 22,)
                            ),
                            IconButton(
                                onPressed: () {
                                  null;
                                },
                                icon: const Icon(Icons.remove_circle,size: 22,)
                            ),
                          ],
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.orangeAccent)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.orangeAccent)
                        ),
                        contentPadding: const EdgeInsets.only(left: 15)
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: memoController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                            floatingLabelBehavior:FloatingLabelBehavior.always,
                            labelText: '메모',
                            labelStyle: TextStyle(fontSize: 24, color:Colors.black),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Color(0xfffa8e00))
                            ),
                            contentPadding: EdgeInsets.all(12)
                        ),
                        keyboardType: TextInputType.text,   //키보드 타입
                      ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        String memo = memoController.text;
                        String amount = amountController.text;
                        var content = {"amount": amount, "startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo,};
                        var result = await lifesetService(widget.babyId, 2, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(2, getlifeRecordPharse(diff));
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          foregroundColor: const Color(0xfffa8e00),
                          //backgroundColor: Color(0xffff9f98),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: const BorderSide(
                            color: Color(0xfffa8e00),
                          )
                      ),
                      child: const Text('확인',style: TextStyle(fontSize: 20)),
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
