import 'dart:convert';
import 'package:bob/models/model.dart';
import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';

class Main_Cctv extends StatefulWidget {
  final User userinfo;
  final getMyBabyFuction;
  const Main_Cctv(this.userinfo, {super.key, this.getMyBabyFuction});
  @override
  State<Main_Cctv> createState() => MainCCTVState();
}
class MainCCTVState extends State<Main_Cctv>{
  late VlcPlayerController _videoPlayerController;
  bool _isPlaying = false;

  TcpSocketConnection socketConnection = TcpSocketConnection("203.249.22.164", 8081);
  Map temp = {"Temp": "-", "Humid": "-"};

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();
    startConnection();
    baby = widget.getMyBabyFuction();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://203.249.22.164:9001/unicast', // 'rtsp://210.99.70.120:1935/live/cctv001.stream'
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
  }

  void messageReceived(String msg){
    setState(() {
      temp = json.decode(msg);
    });
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(true);    //use this to see in the console what's happening
    if(await socketConnection.canConnect(5000, attempts: 3)){   //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }
  late Baby baby;

  @override
  Widget build(BuildContext context) {
    return viewCCTV();
  }

  Widget viewCCTV() {
    String week = baby.relationInfo.Access_week.toRadixString(2);
    for (int i=week.length; i<7; i++) {
      week = '0$week';
    }
    var now = DateTime.now();
    String eeee = DateFormat('EEEE').format(now);
    String hour = DateFormat('hh:mm:ss').format(now);
    int realE = -1;
    switch (eeee) {
      case 'Monday':
        realE = 0;
        break;
      case 'Tuesday':
        realE = 1;
        break;
      case 'Wednesday':
        realE = 2;
        break;
      case 'Thursday':
        realE = 3;
        break;
      case 'Friday':
        realE = 4;
        break;
      case 'Saturday':
        realE = 5;
        break;
      case 'Sunday':
        realE = 6;
        break;
    }
    if (baby.relationInfo.relation == 0 || week[realE] == '1' && hour.compareTo(baby.relationInfo.Access_startTime) == -1 && hour.compareTo(baby.relationInfo.Access_endTime) == 1) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: VlcPlayer(
                    controller: _videoPlayerController,
                    aspectRatio: 3 / 4,
                    placeholder: const Center(child: CircularProgressIndicator()),
                ),
            ),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius : BorderRadius.circular(30.0),
          child: BottomAppBar(
            elevation: 6,
            color: const Color(0xFFF9F8F8),
            padding: const EdgeInsets.all(24),
            height: 170,
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('BoB ', style: TextStyle(color: Color(0xFFFB8665), fontSize: 20)),
                      Text('homecam'.tr, style: const TextStyle(color: Color(0xFF512F22), fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 36),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            label('temp'.tr, 'bold', 14, 'base100'),
                            const SizedBox(height: 16),
                            label(temp['Temp']+'°C', 'bold', 28, 'base100'),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Container(width: 1, height: 64, color: const Color(0xFF512F22)),
                        const SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('humid'.tr, style: const TextStyle(fontSize: 14, color: Color(0xFF512F22))),
                            const SizedBox(height: 16),
                            Text(temp['Humid']+'%', style: const TextStyle(fontSize: 28, color: Color(0xFF512F22)))
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: const Size(60, 60),
                                elevation: 6,
                                backgroundColor: const Color(0xFFFB8665),
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {
                                if (_isPlaying) {
                                  setState(() {
                                    _videoPlayerController.pause();
                                    _isPlaying = false;
                                  });
                                } else {
                                  setState(() {
                                    _videoPlayerController.play();
                                    _isPlaying = true;
                                  });
                                }
                              },
                              child: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 40,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ]
                  )
                ]
            ),
          ),
        ),
      );
    }
    else {
      String accessDay = '';
      for (int i=0; i<7; i++) {
        if (week[i] == '1') {
          switch (i) {
            case 0:
              accessDay += '월 ';
              break;
            case 1:
              accessDay += '화 ';
              break;
            case 2:
              accessDay += '수 ';
              break;
            case 3:
              accessDay += '목 ';
              break;
            case 4:
              accessDay += '금 ';
              break;
            case 5:
              accessDay += '토 ';
              break;
            case 6:
              accessDay += '일 ';
              break;
          }
        }
      }
      return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                label('main2_notAccessTitle'.tr, 'bold', 16, 'base100'),
                label('${'main2_accessWeek'.tr} : $accessDay', 'bold', 16, 'base100'),
                label('${'main2_accessTime'.tr} : ${baby.relationInfo.Access_startTime} ~ ${baby.relationInfo.Access_endTime}', 'bold', 16, 'base100'),
              ]
          ),
        ),
      );
    }
  }
}