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
  final Function(int mode, String data, DateTime date) changeRecord;

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
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xffF9F8F8),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        height: MediaQuery.of(context).size.height * 0.42,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('이유식', style: TextStyle(fontSize: 32, color: Color(0xfffF9B58), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),),
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
                      const Text('이유식 시간 :', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Text('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', style: const TextStyle(color: Color(0xff512F22), fontSize: 21, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text('이유식 양(ml)', style: TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
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
                            labelText: '이유식 양 (ml)',
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
                  const Text('메모', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
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
                            labelText: '내용을 입력해주세요.',
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
                  const SizedBox(height: 15),
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
                        widget.changeRecord(2, getlifeRecordPharse(diff), widget.endT);
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
                      child: const Text('등 록',style: TextStyle(fontSize: 20, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w800),),
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
