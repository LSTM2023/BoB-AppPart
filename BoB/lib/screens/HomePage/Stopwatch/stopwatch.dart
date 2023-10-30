import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:get/get.dart';
import '../../../models/model.dart';
import '../../../widgets/text.dart';

class StopWatch extends StatefulWidget{
  Baby? targetBaby;
  final closeFuction;
  final saveFuction;
  StopWatch(this.targetBaby, {Key? key, this.closeFuction, this.saveFuction}) : super(key: key);

  @override
  State<StopWatch> createState() => StopwatchState();
}

class StopwatchState extends State<StopWatch> {
  Map<int, List<Color>> timerBackgroundColors = {
    0 : [const Color(0xffFFEFEF), const Color(0xffFFC8C8)],
    1 : [const Color(0xffFFF2EC), const Color(0xffFFD9C8)],
    2 : [const Color(0xfffffAEC), const Color(0xffFFF0C8)],
    3 : [const Color(0xffF4FFEC), const Color(0xffE0FFC8)],
    4 : [const Color(0xffF1FDFF), const Color(0xffC8F7FF)]
  };

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
    0 : 'life0_ing'.tr,
    1 : 'life1_ing'.tr,
    2 : 'life2_ing'.tr,
    //3:['배변중..',
    4 : 'life4_ing'.tr
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: timerBackgroundColors[timerType] as List<Color>
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000),
              offset: Offset(0,3),
              blurRadius: 6,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [     // 타이머 타입 설정
          if(timerType==0)
            drawRecordButton('life0'.tr, 'assets/icon/feeding_icon.svg', const Color(0xffff7a7a), const Color(0xb3ffffff), 0),
          if(timerType==1)
            drawRecordButton('life1'.tr, 'assets/icon/feedingbottle_icon.svg', const Color(0xffFF7464), const Color(0xb3FFFFFF), 1),
          if(timerType==2)
            drawRecordButton('life2'.tr, 'assets/icon/babyfood_icon.svg', const Color(0xffFF9B58), const Color(0xb3ffffff), 2),
          // if(timerType==3)
          //   drawRecordButton('lief3'.tr', 'assets/icon/diaper_icon.svg', Colors.green, const Color(0xffE0FFC8), 3),
          if(timerType==4)
            drawRecordButton('life4'.tr, 'assets/icon/sleep_icon.svg', const Color(0xff5086BC), const Color(0xb3ffffff), 4),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data!;
                final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
                return label(displayTime, 'bold', 17, 'base80');
              },
            ),
          ),
          Row(
            children: [
              IconButton(       // 타이머 입력 버튼
                  onPressed: () async {
                    int val = _stopWatchTimer.rawTime.value;
                    int re = StopWatchTimer.getRawHours(val)*60*60 + StopWatchTimer.getRawMinute(val)*60 + StopWatchTimer.getRawSecond(val);
                    DateTime endT = DateTime.now();
                    DateTime startT = endT.subtract(Duration(seconds: re));

                    closeWidget();    // 타이머 닫기
                    widget.saveFuction(timerType, startT, endT);   // 저장 bottomsheet 열기
                  },
                  icon: const Icon(Icons.check_circle_outlined, size: 23,color: Color(0xcc512F22),),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero
              ),
              IconButton(       // reset
                onPressed: () {
                  closeWidget();
                },
                icon: const Icon(Icons.close,size: 23,color: Color(0xcc512F22)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 15,left: 10),
              )
            ],
          )
        ],
      )
    );
  }
  closeWidget(){   // 타이머 종료
    _stopWatchTimer.setPresetTime(mSec: 0000);
    _stopWatchTimer.onStopTimer();
    widget.closeFuction();
  }
  openWidget(int n, Baby t){      // 타이머 시작
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
  // 버튼
  InkWell drawRecordButton(String type, String iconData, Color background, Color color, int tapMode){
    return InkWell(
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(0, 0, 0, 16),
                blurRadius: 6,
                spreadRadius: 6,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(iconData, color: background ), // <-- Icon
              const SizedBox(height: 3),
              //text(type, 'bold', 12, background)
            ],
          ),
        )
    );
  }
}