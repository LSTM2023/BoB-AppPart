import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import 'package:bob/widgets/pharse.dart';

class FeedingBottleStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data) changeRecord;
  const FeedingBottleStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);
  //final String feedingTime;

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
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.white,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('젖병 수유', style: TextStyle(fontSize: 35, color: Colors.deepOrangeAccent)),
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
                  Row(
                    children: [
                      const Text('수유 시간', style: TextStyle(fontSize: 17, color: Colors.grey)),
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
                  const SizedBox(height: 10),
                  const Text('수유 타입', style: TextStyle(fontSize: 17, color: Colors.black)),
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
                              backgroundColor: isSelect ? const Color(0xfff7a972) : null,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text('모유',style: TextStyle(fontSize: 16))
                            ),
                          ),
                        ),
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
                                backgroundColor: !isSelect ? const Color(0xfff7a972) : null,
                              ),
                              child: const Padding(padding:EdgeInsets.all(10), child:Text('분유',style: TextStyle(fontSize: 16))),

                            )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: memoController,
                        maxLines: 1,
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
                                borderSide: BorderSide(color: Color(0xfff77b72))
                            ),
                            contentPadding: EdgeInsets.all(12)
                        ),
                        keyboardType: TextInputType.text,   //키보드 타입
                      ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        int side = isSelect? 0 : 1;
                        String memo = memoController.text;
                        String amount = amountController.text;
                        var content = {"type": side, "amount": amount, "startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        print(content);
                        var result = await lifesetService(widget.babyId, 1, content.toString());
                        print(result);
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(1, getlifeRecordPharse(diff));
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          foregroundColor: Colors.orangeAccent,
                          //backgroundColor: Color(0xffff9f98),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          side: const BorderSide(
                            color: Colors.orangeAccent,
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
