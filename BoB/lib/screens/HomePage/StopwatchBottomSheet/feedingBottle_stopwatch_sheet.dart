import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import 'package:bob/widgets/pharse.dart';

class FeedingBottleStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data, DateTime date) changeRecord;
  const FeedingBottleStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);

  @override
  _FeedingBottleStopwatchBottomSheet createState() => _FeedingBottleStopwatchBottomSheet();
}

class _FeedingBottleStopwatchBottomSheet extends State<FeedingBottleStopwatchBottomSheet> {

  bool isSelect = true;   // side 입력
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
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 25, top: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  label('life1'.tr, 'bold', 30, 'feedingBottle')
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left:25, right:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(  // 수유 타이머 시간 출력
                    children: [
                      label('feeding_time'.tr, 'bold', 15, 'base100'),
                      const SizedBox(width: 5),
                      label('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', 'bold', 20, 'base100')
                    ],
                  ),
                  const SizedBox(height: 15),
                  label('type_feed'.tr, 'bold', 15, 'base100'),
                  Padding(
                    padding: const EdgeInsets.only(top:5, bottom:8),
                    child: Row(     // 수유 타입 설정
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
                              backgroundColor: isSelect ? const Color(0xffffb1a2) : null,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('life0'.tr,style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold))
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
                                backgroundColor: !isSelect ? const Color(0xffffb1a2) : null,
                              ),
                              child: Padding(
                                  padding:const EdgeInsets.all(10),
                                  child:Text('powdered_milk'.tr, style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold))),
                            )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  label('amount_feed'.tr, 'bold', 15, 'base100'),
                  const SizedBox(height: 5),
                  SizedBox(   // 수유량 입력
                    width: MediaQuery.of(context).size.width*0.9,
                    child: TextFormField(
                      controller: amountController,
                      style: const TextStyle(fontSize: 16, color: Color(0x99512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          floatingLabelBehavior:FloatingLabelBehavior.never, // labelText위치
                          labelText: 'amount_feed'.tr,
                          labelStyle: const TextStyle(color: Color(0x4d512F22), fontSize: 23, fontFamily: 'NanumSquareRound'),
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.only(right: 10),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    null;
                                  },
                                  icon: const Icon(Icons.add_circle,size: 22, color: Color(0xffffb1a2))
                              ),
                              IconButton(
                                  padding: const EdgeInsets.only(right: 13),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    null;
                                  },
                                  icon: const Icon(Icons.remove_circle,size: 22, color: Color(0xffffb1a2))
                              ),
                            ],
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Color(0x4d512F22))
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          contentPadding: const EdgeInsets.only(left: 15)
                      ),
                      keyboardType: TextInputType.number,   //키보드 타입
                    ),
                  ),
                  const SizedBox(height: 15),
                  label('memo'.tr, 'bold', 15, 'base100'),
                  const SizedBox(height: 5),
                  GestureDetector(      // 메모 입력
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
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
                            contentPadding: const EdgeInsets.only(left: 10, bottom: 20,)
                        ),
                        keyboardType: TextInputType.text,   //키보드 타입
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(   // 수유 타이머 기록 제출
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        int side = isSelect? 0 : 1;
                        String memo = memoController.text;
                        String amount = amountController.text;
                        var content = {"type": side, "amount": amount, "startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        var result = await lifesetService(widget.babyId, 1, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(1, getlifeRecordPharse(diff), widget.endT);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xffffb1a2),
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
          ],
        ),
      ),
    );
  }
}
