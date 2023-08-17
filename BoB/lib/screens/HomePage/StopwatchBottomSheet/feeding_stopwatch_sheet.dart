import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:get/get.dart';
import '../../../services/backend.dart';
import 'package:bob/widgets/pharse.dart';

class FeedingStopwatchBottomSheet extends StatefulWidget {

  final int babyId;
  final DateTime startT;
  final DateTime endT;
  final Function(int mode, String data) changeRecord;

  const FeedingStopwatchBottomSheet(this.babyId, this.startT, this.endT, {Key? key, required this.changeRecord}) : super(key: key);
  //final String feedingTime;

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
    return Padding(
      padding: const EdgeInsets.all(10),//MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수유', style: TextStyle(fontSize: 35, color: Colors.red)),
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
                      const Text('수유 시간', style: TextStyle(fontSize: 17, color: Colors.grey)),
                      const SizedBox(width: 20),
                      Text('${DateFormat('HH:mm:ss').format(widget.startT)} ~ ${DateFormat('HH:mm:ss').format(widget.endT)}', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                                padding: EdgeInsets.all(10),
                                child: Text('왼쪽',style: TextStyle(fontSize: 16))
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
                                backgroundColor: !isSelect ? const Color(0xfff77b72) : null,
                              ),
                              child: const Padding(padding:EdgeInsets.all(10), child:Text('오른쪽',style: TextStyle(fontSize: 16))),

                            )
                        )
                      ],
                    ),
                  ),
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async{
                        int side = isSelect? 0 : 1;
                        String memo = memoController.text;
                        var content = {"side": side, "startTime": widget.startT.toString(), "endTime": widget.endT.toString(), "memo": memo};
                        var result = await lifesetService(widget.babyId, 0, content.toString());
                        Duration diff = (DateTime.now()).difference(widget.endT);
                        widget.changeRecord(0, getlifeRecordPharse(diff));
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
              )
            ),
          ],
        ),
      ),
    );
  }
  Future<void> call_saveApi(var content) async {
    return Future((){

    }).then((value){

    });
  }
}
