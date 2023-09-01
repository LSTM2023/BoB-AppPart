import 'dart:convert';

import 'package:bob/models/model.dart';
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
      'rtsp://203.249.22.164:8080/unicast',
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
  }

  void messageReceived(String msg){
    setState(() {
      temp = json.decode(msg);
      print(msg);
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
    String week = baby.relationInfo.Access_week.toRadixString(2);;
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
          children: [
            Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius : BorderRadius.circular(10.0),
                    child: VlcPlayer(
                      controller: _videoPlayerController,
                      aspectRatio: 16 / 9,
                      placeholder: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 200,
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('BoB '.tr, style: const TextStyle(color: Color(0xFFFB8665), fontSize: 20)),
                    Text('HomeCam'.tr, style: const TextStyle(color: Color(0xFF512F22), fontSize: 20)),
                  ],
                ),
                Row(
                    children: [
                      Column(
                        children: [
                          Text("온도", style: TextStyle(fontSize: 14)),
                          Text(temp['Temp'], style: TextStyle(fontSize: 28))
                        ],
                      ),
                      Column(
                        children: [
                          Text("습도", style: TextStyle(fontSize: 14)),
                          Text(temp['Humid'], style: TextStyle(fontSize: 28))
                        ],
                      ),
                      const VerticalDivider(thickness: 1.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding:const EdgeInsets.fromLTRB(50,0,50,0),
                          backgroundColor: Colors.pink,
                          shape: CircleBorder(),
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
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 28,
                            color: Color(0xffdf8570)),
                      ),
                    ]
                )
              ]
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
      };
      return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('main2_notAccessTitle'.tr, style: const TextStyle(fontSize: 20)),
                Text('${'main2_accessWeek'.tr} : $accessDay', style: const TextStyle(fontSize: 20)),
                Text('${'main2_accessTime'.tr} : ${baby.relationInfo.Access_startTime} ~ ${baby.relationInfo.Access_endTime}', style: const TextStyle(fontSize: 20))
              ]
          ),
        ),
      );
    }
  }
}