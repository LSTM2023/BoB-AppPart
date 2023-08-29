import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:get/get.dart';
import '../../../models/model.dart';

class StopWatch extends StatefulWidget{
  Baby targetBaby;
  final closeFuction;
  final saveFuction;
  StopWatch(this.targetBaby, {Key? key, this.closeFuction, this.saveFuction}) : super(key: key);

  @override
  State<StopWatch> createState() => StopwatchState();
}

class StopwatchState extends State<StopWatch> {

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) => print('onChange $value'),
    //onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );
  int timerType = 0;
  @override
  initState(){
    super.initState();
    _stopWatchTimer.setPresetTime(mSec: 0000);
  }
  Map<int, String> type2phrase = {
    0 : '모유 수유중..',
    1 : '젖병 수유중..',
    2 : '이유식 먹는중..',
    //3:['배변중..',
    4 : '수면중..',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Text(widget.targetBaby.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                int val = _stopWatchTimer.rawTime.value;
                int re = StopWatchTimer.getRawHours(val)*60*60 + StopWatchTimer.getRawMinute(val)*60 + StopWatchTimer.getRawSecond(val);
                DateTime endT = DateTime.now();
                DateTime startT = endT.subtract(Duration(seconds: re));

                closeWidget();    // 타이머 닫기
                widget.saveFuction(timerType, startT, endT);   // 저장 bottomsheet 열기
              },
              icon: const Icon(Icons.check_circle,size: 25,color: Colors.black),
              // padding: const EdgeInsets.only(right: 13,),
              constraints: const BoxConstraints(),
            ),
            IconButton( // reset
              onPressed: () {
                closeWidget();
              },
              icon: const Icon(Icons.close,size: 25,color: Colors.black),
              // padding: const EdgeInsets.only(right: 15),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: _stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
              return Text(
                displayTime,
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'NanumSquareRound',
                    fontWeight: FontWeight.w600
                ),
              );
            },
          ),
        )
      ],
    );
  }
  closeWidget(){
    _stopWatchTimer.setPresetTime(mSec: 0000);
    _stopWatchTimer.onStopTimer();
    widget.closeFuction();
  }
  openWidget(int n, Baby t){
    _stopWatchTimer.onResetTimer();
    _stopWatchTimer.onStartTimer();
    setState(() {
      widget.targetBaby = t;
      timerType = n;
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }
}