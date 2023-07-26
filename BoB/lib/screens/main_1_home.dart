import 'package:bob/models/model.dart';
import 'package:bob/screens/HomePage/Stopwatch/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/backend.dart';

class Main_Home extends StatefulWidget {
  final User userinfo;
  final getBabiesFunction;
  final getCurrentBabyFunction;
  final changeCurrentBabyFunction;

  const Main_Home(this.userinfo,
      {Key? key,
      this.getBabiesFunction,
      this.getCurrentBabyFunction,
      this.changeCurrentBabyFunction})
      : super(key: key);

  @override
  State<Main_Home> createState() => MainHomeState();
}

class MainHomeState extends State<Main_Home> {
  GlobalKey<StopwatchState> _stopwatchKey = GlobalKey();

  late Baby currentBaby;

  String _feeding = '-';        // 모유
  String _feedingBottle = '-';  // 젖병
  String _babyfood = '-';       // 이유식
  final String _diaper = '-';         // 기저귀
  String _sleep = '-';          // 수면

  bool timerClosed = true;

  String nextVaccineDate = '';
  String nextMedicalCheckUpDate = '';

  List<Color> timerBackgroundColors= [const Color(0xffffdbd9),const Color(0xfffae2be),const Color(0xfffff7d4), const Color(0xffedfce6), const Color(0xffe6eafc)];
  Color timerBackgroundColor = const Color(0xffffdbd9);
  int timerType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentBaby = widget.getCurrentBabyFunction();
    String _feeding = '-';        // 모유
    String _feedingBottle = '-';  // 젖병
    String _babyfood = '-';       // 이유식
    String _diaper = '-';         // 기저귀
    String _sleep = '-';          // 수면

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffcd3c2),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
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
                        // SingleChildScrollView(
                        //   child:ExpansionTile(
                        //       initiallyExpanded: true,
                        //       title: Text('relation0'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        //       children: getDrawerDatas(0, context, const Color(0xfffa625f))
                        //   ),
                        // ),
                        // SingleChildScrollView(
                        //   child:ExpansionTile(
                        //       initiallyExpanded: true,
                        //       title: Text('relation1'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        //       children: getDrawerDatas(1, context, Colors.blueAccent)
                        //   ),
                        // ),
                        // SingleChildScrollView(
                        //   child:ExpansionTile(
                        //       initiallyExpanded: true,
                        //       title: Text('relation2'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        //       children: getDrawerDatas(2, context, Colors.grey)
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ))),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffcd3c2), Color(0xffffe4d8)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 3,
                    )
                  ]),
              child: const Center(
                  // child: drawBaby(currentBaby.name, currentBaby.birth),
                  ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('생활 기록', style: TextStyle(fontSize: 19, color: Colors.black)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('모유', style: TextStyle(fontSize: 17, color: Colors.grey[800])),
                            Text(_feeding, style: TextStyle(fontSize: 20, color: Colors.grey[800]))
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('젖병', style: TextStyle(fontSize: 17, color: Colors.grey[800])),
                            Text(_feedingBottle, style: TextStyle(fontSize: 20, color: Colors.grey[800]))
                          ],
                        ),)
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('기저귀', style: TextStyle(fontSize: 17, color: Colors.grey[600])),
                            Text(_diaper, style: TextStyle(fontSize: 20, color: Colors.grey[800]))
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('수면', style: TextStyle(fontSize: 17, color: Colors.grey[600])),
                            Text(_sleep, style: TextStyle(fontSize: 20, color: Colors.grey[800]))
                          ],
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //생활 기록 box
            Row(
              children: [
                Expanded(
                    flex:1,
                    child: GestureDetector(
                      onTap: () {
                        // Get.to(()=>BabyGrowthStatistics(currentBaby, myBabyGrowthRecordList)
                        // );
                      },
                      child: Container(
                        height: 235,
                        margin: const EdgeInsets.fromLTRB(20, 0, 5, 10),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text('grow_record'.tr,style: const TextStyle(fontSize: 22)),
                                const Text('성장 기록',style: TextStyle(fontSize: 19)),
                                IconButton(
                                    onPressed: () {
                                      // showModalBottomSheet(
                                      //     shape: const RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.only(
                                      //             topRight: Radius.circular(20),
                                      //             topLeft: Radius.circular(20)
                                      //         )
                                      //     ),
                                      //     backgroundColor: Colors.grey[100],
                                      //     isScrollControlled: true,
                                      //     context: context,
                                      //     builder: ( BuildContext context ) {
                                      //       return GrowthRecordBottomSheet(currentBaby.relationInfo.BabyId);
                                      //     }
                                      // );
                                    },
                                    icon: const Icon(Icons.add_circle_outline, size: 25, color: Colors.black54)
                                ),
                              ],
                            ),
                            const Text('2023.05.06 갱신', style: TextStyle(color:Colors.grey, fontSize: 12)),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('키', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                Center(child: Text('90cm', style: TextStyle(fontSize: 18))),
                                SizedBox(height: 25),
                                Text('몸무게', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                Center(child: Text('10kg', style: TextStyle(fontSize: 18))),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                ),
                //성장기록 구현
                Expanded(
                    flex:1,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                        child: Column(
                          children: [
                            GestureDetector(
                                // onTap: () {
                                //   Get.to(() => BabyVaccination(currentBaby, myBabyvaccineList));
                                // },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        )
                                      ]
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text('vaccination'.tr, style: const TextStyle(fontSize: 22, color: Colors.black)),
                                        const Text('예방 접종', style: TextStyle(fontSize: 18, color: Colors.black)),
                                        // Text(
                                        //   'next_vaccination'.tr,
                                        //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        // ),
                                        const SizedBox(height: 5,),
                                        const Text(
                                          '다음 예방 접종',
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                            child: Text(
                                              nextVaccineDate,
                                              style: const TextStyle(fontSize: 19, color: Color(0xfffa625f)),
                                            )
                                        )
                                      ]
                                  ),
                                )
                            ),
                            //예방 접종 페이지 이동
                            const SizedBox(height: 15),
                            GestureDetector(
                                // onTap: () {
                                //   Get.to(()=>BabyMedicalCheckup(currentBaby, myBabyMedicalCheckList));
                                // },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  width: double.infinity,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        )
                                      ]
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text('medical_checkup'.tr, style: const TextStyle(fontSize: 22, color: Colors.black)),
                                        const Text('건강 검진', style: TextStyle(fontSize: 22, color: Colors.black)),
                                        const Text(
                                          '다음 건강 검진',
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                            child: Text(
                                              nextMedicalCheckUpDate,
                                              style: const TextStyle(fontSize: 19, color: Color(0xfffa625f)),
                                            )
                                        )
                                      ]
                                  ),
                                )
                            )
                            //건강 검진 페이지 이동
                          ],
                        )
                    )
                )
                //예방 접종, 건강 검진 구현
              ],
            ),
            //성장 기록, 예방 접종, 검강 검진
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Text('버튼을 길게 누르면 타이머가 작동합니다.',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        drawRecordButton(context, '모유', Icons.water_drop_outlined, Colors.red, const Color(0xfffFFD2D2), 0),
                        drawRecordButton(context, '젖병', Icons.water_drop, Colors.orange, const Color(0xffFFE0D2), 1),
                        drawRecordButton(context, '이유식', Icons.rice_bowl_rounded, const Color(0xfffacc00), const Color(0xffFFF2D2), 2),
                        drawRecordButton(context, '기저귀', Icons.baby_changing_station, Colors.green, const Color(0xffE6FFD2), 3),
                        drawRecordButton(context, '수면', Icons.nights_stay_sharp, Colors.blueAccent, const Color(0xffD2F8FF), 4)
                      ],
                    ),
                  ],
                )
            ),
          ],
        ),
      ),

    );
  }

  //기록 버튼 롱 클릭 시
  InkWell drawRecordButton(BuildContext rootContext, String type, IconData iconData, Color background, Color color, int tapMode){
    return InkWell(
        onTap: () => record_with_ModalBottomSheet(rootContext, tapMode),
        onLongPress: (){
          if(tapMode==3){
            DateTime now = DateTime.now();
            // 1. 시간 저장
            // 2. dialog - 대/소변
            Get.dialog(
                AlertDialog(
                    backgroundColor: const Color(0xffedfce6),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () async {
                              var content = {"type": 0, "startTime": now, "endTime": now, "memo": null};
                              var result = await lifesetService(currentBaby.relationInfo.BabyId, 3, content.toString());
                              print(result);
                              Get.back();
                            },
                            child: const Text('대변', style: TextStyle(color: Colors.black),)
                        ),
                        const Divider(thickness: 0.2, color: Colors.grey),
                        TextButton(
                          onPressed: () async{
                            var content = {"type": 1, "startTime": now, "endTime": now, "memo": null};
                            var result = await lifesetService(currentBaby.relationInfo.BabyId, 3, content.toString());
                            print(result);
                            Get.back();
                          },
                          child: const Text('소변',style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    )
                )
            );
          }
          else{
            timerType = tapMode;
            timerBackgroundColor = timerBackgroundColors[tapMode];
            // offstage 보이게
            setState(() {
              timerClosed = false;
              // 타이머 시작
              _stopwatchKey.currentState?.openWidget(tapMode, currentBaby);
            });
          }
          //globalKeys[tapMode].currentState?.start();
        },
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, color: background), // <-- Icon
              Text(type, style: TextStyle(fontSize: 13, color: background)), // <-- Text
            ],
          ),
        )
    );
  }

  //기록 버튼 클릭 시
  record_with_ModalBottomSheet(BuildContext rootContext, int tapMode){
    // showModalBottomSheet(
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             topRight: Radius.circular(20),
    //             topLeft: Radius.circular(20)
    //         )
    //     ),
    //     backgroundColor: Colors.grey[50],
    //     isScrollControlled: true,
    //     context: rootContext,
    //     builder: (BuildContext context) {
    //       if(tapMode==0){
    //         return FeedingBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
    //       }else if(tapMode==1){
    //         return FeedingBottleBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
    //       }
    //       else if(tapMode==2){
    //         return BabyFoodBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
    //       }
    //       else if(tapMode==3){
    //         return DiaperBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
    //       }
    //       else{
    //         return SleepBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
    //       }
    //     }
    // );
  }
}
