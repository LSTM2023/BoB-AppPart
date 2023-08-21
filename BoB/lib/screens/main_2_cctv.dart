import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

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

  Future<void> initializePlayer() async {}

  @override
  void initState() {
    super.initState();
    baby = widget.getMyBabyFuction();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://203.249.22.164:8080/unicast',
      autoPlay: false,
      options: VlcPlayerOptions(),
    );
  }
  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }
  late Baby baby;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xD9FFE1C7),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFFFCCBF), Color(0xD9FFE1C7)],
            )
          )
        ),
        elevation: 4.0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('BoB '.tr, style: const TextStyle(color: Color(0xFFFB8665), fontSize: 20)),
              Text('HomeCam'.tr, style: const TextStyle(color: Color(0xFF512F22), fontSize: 20)),
            ],
          ),
        ),
      ),
      drawer: Drawer(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Text('babyList'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                  // Text('babyListC'.tr, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ))),
      body: viewCCTV(),
    );
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
    if (baby.relationInfo.relation == 0 || week[realE] == 1 && hour.compareTo(baby.relationInfo.Access_startTime) == -1 && hour.compareTo(baby.relationInfo.Access_endTime) == 1) {
      return Column(
          children: [
            Container(height: 26),
            Text(DateFormat('yyyy.MM.dd').format(DateTime.now()), style: const TextStyle(color: Color(0xFFFB8665), fontSize: 18)),
            Container(height: 31),
            Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius : BorderRadius.circular(5.0),
                    child: VlcPlayer(
                      controller: _videoPlayerController,
                      aspectRatio: 16 / 9,
                      placeholder: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(padding:const EdgeInsets.fromLTRB(50,0,50,0)),
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
              ],
            ),
          ],
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
      return Center(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('main2_notAccessTitle'.tr, style: const TextStyle(fontSize: 20)),
              Text('${'main2_accessWeek'.tr} : $accessDay', style: const TextStyle(fontSize: 20)),
              Text('${'main2_accessTime'.tr} : ${baby.relationInfo.Access_startTime} ~ ${baby.relationInfo.Access_endTime}', style: const TextStyle(fontSize: 20))
            ]
        ),
      );
    }
  }
}