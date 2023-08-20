import 'dart:math';
import 'package:bob/models/model.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/babyFood_bottom_sheet.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/diaper_bottom_sheet.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/feedingBottle_bottom_sheet.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/feeding_bottom_sheet.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/growthRecord_bottom_sheet.dart';
import 'package:bob/screens/HomePage/RecordBottomSheet/sleep_bottom_sheet.dart';
import 'package:bob/screens/HomePage/Stopwatch/stopwatch.dart';
import 'package:bob/screens/HomePage/StopwatchBottomSheet/babyFood_stopwatch_sheet.dart';
import 'package:bob/screens/HomePage/StopwatchBottomSheet/feedingBottle_stopwatch_sheet.dart';
import 'package:bob/screens/HomePage/StopwatchBottomSheet/feeding_stopwatch_sheet.dart';
import 'package:bob/screens/HomePage/StopwatchBottomSheet/sleep_stopwatch_sheet.dart';
import 'package:bob/screens/HomePage/baby_growthStatistics.dart';
import 'package:bob/screens/HomePage/baby_medicalCheckup.dart';
import 'package:bob/screens/HomePage/baby_vaccination.dart';
import 'package:bob/widgets/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../services/backend.dart';

class Main_Home extends StatefulWidget {
  final User userinfo;
  final getBabiesFunction;
  final getCurrentBabyFunction;
  final changeCurrentBabyFunction;
  const Main_Home(this.userinfo, {Key? key, this.getBabiesFunction, this.getCurrentBabyFunction, this.changeCurrentBabyFunction}) : super(key: key);
  @override
  State<Main_Home> createState() => MainHomeState();
}

class MainHomeState extends State<Main_Home> {
  GlobalKey<StopwatchState> _stopwatchKey = GlobalKey();
  late List<Baby> activeBabies;
  late Baby currentBaby;

  String _feeding = '-';        // 모유
  String _feedingBottle = '-';  // 젖병
  String _babyfood = '-';       // 이유식
  String _diaper = '-';         // 기저귀
  String _sleep = '-';          // 수면

  bool timerClosed = true;

  List<Vaccine> myBabyvaccineList = [];
  late List<MedicalCheckUp> myBabyMedicalCheckList;

  late List<GrowthRecord> myBabyGrowthRecordList = [];

  void addLifeRecord(int type, String val){
    setState(() {
      if(type==0){
        _feeding = val;
      }
      else if(type==1){
        _feedingBottle = val;
      }
      else if(type==2){
        _babyfood = val;
      }
      else if(type==3){
        _diaper = val;
      }
      else{
        _sleep = val;
      }
    });
  }

  closeOffset(){
    setState(() {
      timerClosed = true;
    });
  }

  List<Color> timerBackgroundColors= [const Color(0xffFFEFEF),const Color(0xfffae2be),const Color(0xfffff7d4), const Color(0xffedfce6), const Color(0xffe6eafc)];
  Color timerBackgroundColor = const Color(0xffFFEFEF);
  int timerType = 0;
  late StopWatch stopWatchWidget;

  String nextVaccineDate = '';
  String nextMedicalCheckUpDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeBabies = widget.getBabiesFunction(true);
    currentBaby = widget.getCurrentBabyFunction();
    stopWatchWidget = StopWatch(currentBaby, key : _stopwatchKey, closeFuction: closeOffset, saveFuction: showTimerBottomSheet);
    loadMyBabyVaccineInfo();
    loadMyBabyMedicalCheckInfo();
  }
  loadMyBabyVaccineInfo(){
    myBabyvaccineList = [
      Vaccine(ID: 0, title: '결핵 경피용', times: 'BCG 1회/기타', recommendationDate: '2023.01.20 ~ 2023.02.19', detail: '생후 4주 이내 접종, 민간의료기관, 유료'),
      Vaccine(ID: 1, title: '결핵 피내용', times: 'BCG 1회/기타', recommendationDate: '2023.01.20 ~ 2023.02.19', detail: '생후 4주 이내 접종, 민간의료기관, 유료'),
      Vaccine(ID: 2, title: 'B형 간염', times: 'HepB 1차/국가', recommendationDate: '2023.01.20', detail: '생후 12시간 이내 접종(모체가 양성일 경우 HBIG와 함께 접종)'), // 2
      Vaccine(ID: 3, title: 'B형 간염', times: 'HepB 2차/국가', recommendationDate: '2023.02.20', detail: '만 1개월에 접종'),
      Vaccine(ID: 4, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 1회/국가', recommendationDate: '2023.03.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 5, title: '폴리오', times: 'IPV 1회/국가', recommendationDate: '2023.03.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 6, title: 'b형 헤모필루스인플루엔자', times: 'Hib 1차/국가', recommendationDate: '2023.03.20', detail: '뇌수막염 예방접종'),
      Vaccine(ID: 7, title: '폐렴구균', times: 'PCV(단백결합) 1차/국가', recommendationDate: '2023.03.20', detail: ''),
      Vaccine(ID: 8, title: '로타바이러스(로타릭스)', times: 'RV1 1차/기타', recommendationDate: '2023.03.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 9, title: '로타바이러스(로타텍)', times: 'RV5 1차/기타', recommendationDate: '2023.03.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 10, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 2차/국가', recommendationDate: '2023.05.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 11, title: '폴리오', times: 'IPV 2차/국가', recommendationDate: '2023.05.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 12, title: 'b형 헤모필루스인플루엔자', times: 'Hib 2차/국가', recommendationDate: '2023.05.20', detail: '뇌수막염 예방접종, 만 4개월에 접종'),
      Vaccine(ID: 13, title: '폐렴구균', times: 'PCV(단백결합) 2차/국가', recommendationDate: '2023.05.20', detail: '만 4개월에 접종'),
      Vaccine(ID: 14, title: '로타바이러스(로타릭스)', times: 'RV1 2차/기타', recommendationDate: '2023.05.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 15, title: '로타바이러스(로타텍)', times: 'RV5 2차/기타', recommendationDate: '2023.05.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 16, title: 'B형 간염', times: 'HepB 3차/국가', recommendationDate: '2023.07.20', detail: '만 6개월에 접종'),
      Vaccine(ID: 17, title: '디프테리아, 파상풍, 백일해', times: 'DTaP 3차/국가', recommendationDate: '2023.07.20', detail: 'DTaP-IPV 폴리오와 혼합 접종 가능'),
      Vaccine(ID: 18, title: '폴리오', times: 'IPV 3차/국가', recommendationDate: '2023.07.20', detail: 'DTaP-IPV 혼합 접종 가능'),
      Vaccine(ID: 19, title: 'b형 헤모필루스인플루엔자', times: 'Hib 3차/국가', recommendationDate: '2023.07.20', detail: '뇌수막염 예방접종, 만 6개월에 접종'),
      Vaccine(ID: 20,title: '폐렴구균', times: 'PCV(단백결합) 3차/국가', recommendationDate: '2023.07.20', detail: '만 6개월에 접종'),
      Vaccine(ID: 21,title: '로타바이러스(로타텍)', times: 'RV5 3차/기타', recommendationDate: '2023.07.20', detail: '유료, 로타릭스/로타텍 중 선택 접종'),
      Vaccine(ID: 22,title: '인플루엔자', times: 'IIV 1차/국가', recommendationDate: '2023.07.20 ~ 2023.08.19', detail: '만 6개월 후 지정기간에서 접종\n생애 최초 시 4주 후 2차 접종'),
      Vaccine(ID: 23,title: '인플루엔자', times: 'IIV 2차/국가', recommendationDate: '2023.07.20 ~ 2023.08.19', detail: '만 6개월 후 지정기간에서 접종\n생애 최초 시 4주 후 2차 접종'),
      Vaccine(ID: 24,title: 'b형 헤모필루스인플루엔자', times: 'Hib 추가 4차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '뇌수막염 접종, 만 12~15개월에 접종'),
      Vaccine(ID: 25,title: '폐렴구균', times: 'PCV(단백결합) 추가 4차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 26,title: '홍역, 유행성이하선염, 풍진', times: 'MMR 1차/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 27,title: '수두', times: 'VAR 1회/국가', recommendationDate: '2024.01.20 ~ 2024.05.19', detail: '만 12~15세 접종'),
      Vaccine(ID: 28,title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 4차/국가', recommendationDate: '2024.04.20 ~ 2024.08.19', detail: '만 15~18세 접종'),
      Vaccine(ID: 29,title: 'A형 간염', times: 'HepA 1차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '만 12~23세 접종'),
      Vaccine(ID: 30, title: 'A형 간염', times: 'HepA 2차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '만 12~23세 접종'),
      Vaccine(ID: 31, title: '일본뇌염 사백신', times: 'IJEV 1차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '사백신 총 5회 접종'),
      Vaccine(ID: 32, title: '일본뇌염 사백신', times: 'IJEV 2차/국가', recommendationDate: '2024.01.20 ~ 2024.12.19', detail: '1차 접종 1개월 후 접종'),
      Vaccine(ID: 33, title: '일본뇌염 사백신', times: 'IJEV 3차/국가', recommendationDate: '2025.12.20 ~ 2027.01.19', detail: '2차 접종 11개월 후 접종'),
      Vaccine(ID: 34, title: '일본뇌염 생백신', times: 'LJEV 1차/국가', recommendationDate: '2024.01.20 ~ 2025.12.19', detail: '총 2회 접종, 1차 접종 12개월 후 2차 접종(무료/유료)'),
      Vaccine(ID: 35, title: '일본뇌염 생백신', times: 'LJEV 2차/국가', recommendationDate: '2024.01.20 ~ 2025.12.19', detail: '총 2회 접종, 1차 접종 12개월 후 2차 접종(무료/유료)'),
      Vaccine(ID: 36, title: '인플루엔자', times: 'IIV 1회/국가', recommendationDate: '2024.12.20 ~ 2025.12.19', detail: '국가지정기간에서 접종(보통 10월중순 즘 시작)'),
      Vaccine(ID: 37, title: '인플루엔자', times: 'IIV 2회/국가', recommendationDate: '2025.12.20 ~ 2027.12.19', detail: '국가지정기간에서 접종(보통 10월중순 즘 시작)'),
      Vaccine(ID: 38, title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 5차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 39, title: '디프테리아 / 파상풍 / 백일해', times: 'DTaP 추가 6차/국가', recommendationDate: '2034.01.20 ~ 2036.01.19', detail: '만 11~12세 접종'),
      Vaccine(ID: 40, title: '폴리오', times: 'IPV 추가 4차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 41, title: '홍역 / 유행성 이하선염 / 풍진', times: 'MMR 2차/국가', recommendationDate: '2027.01.20 ~ 2030.01.19', detail: '만 4~6세 접종'),
      Vaccine(ID: 42, title: '일본뇌염 사백신', times: 'IJEV(사백신) 추가 4차/국가', recommendationDate: '2029.01.20', detail: '총 5회 접종, 4차 접종'),
      Vaccine(ID: 43, title: '일본뇌염 사백신', times: 'IJEV(사백신) 추가 5차/국가', recommendationDate: '2035.01.20', detail: '총 5회 접종, 5차 접종'),
      Vaccine(ID: 44, title: '인유두종 바이러스 감염증', times: 'HPV 1차/국가', recommendationDate: '2035.01.20 ~ 2036.01.19', detail: '자궁경부암백신, 여아만 해당\n만 12세에 6개월 간격으로 2회 접종')
    ];
    for(int i=0; i<myBabyvaccineList.length; i++){
      if(!myBabyvaccineList[i].isInoculation){
        setState(() {
          nextVaccineDate = myBabyvaccineList[i].title;
        });
        return;
      }
    }
  }
  loadMyBabyMedicalCheckInfo(){
    myBabyMedicalCheckList = [
      MedicalCheckUp(0, '1차 건강검진',[1, 14, 35], currentBaby.birth),
      MedicalCheckUp(1, '2차 건강검진',[0, 4, 6], currentBaby.birth),
      MedicalCheckUp(2, '3차 건강검진',[0, 9, 12], currentBaby.birth),
      MedicalCheckUp(3, '4차 건강검진',[0, 18, 24], currentBaby.birth),
      MedicalCheckUp(4, '1차 구강검진',[0, 18, 24], currentBaby.birth),
      MedicalCheckUp(5, '5차 건강검진',[0, 30, 36], currentBaby.birth),
      MedicalCheckUp(6, '2차 구강검진',[0, 30, 41], currentBaby.birth),
      MedicalCheckUp(7, '6차 건강검진',[0, 42, 48], currentBaby.birth),
      MedicalCheckUp(8, '3차 구강검진',[0, 42, 53], currentBaby.birth),
      MedicalCheckUp(9, '7차 건강검진',[0, 54, 60], currentBaby.birth),
      MedicalCheckUp(10, '4차 구강검진',[0, 54, 65], currentBaby.birth),
      MedicalCheckUp(11, '8차 건강검진',[0, 66, 71], currentBaby.birth)
    ];
    for(int i=0; i<myBabyMedicalCheckList.length; i++){
      if(!myBabyMedicalCheckList[i].isInoculation){
        setState(() {
          nextMedicalCheckUpDate = myBabyMedicalCheckList[i].title;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: const Text("BoB", style: TextStyle(color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontSize: 20, fontWeight: FontWeight.w700),),
        backgroundColor: const Color(0xffffccbf),
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
                  textBase('아기 리스트', 'extra-bold', 20),
                  const SizedBox(height: 8),
                  textBase('클릭하면 해당 아기를 관리할 수 있습니다.', 'bold', 12),
                  const SizedBox(height: 29),
                  Expanded(
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              // title: Text('relation0'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              title: textBase('부모', 'extra-bold', 14),
                              children: getDrawerDatas(0, context, const Color(0xfffa625f))
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              // title: Text('relation1'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              title: textBase('가족', 'extra-bold', 14),
                              children: getDrawerDatas(1, context, Colors.blueAccent)
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              // title: Text('relation2'.tr, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              title: textBase('베이비시터', 'extra-bold', 14),
                              children: getDrawerDatas(2, context, Colors.grey)
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
          )
      ),
      //drawer 구현
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
                      colors: [Color(0xffffccbf), Color(0xffffe1c9)]),
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
              child: Center(
                child: drawBaby(currentBaby.name, currentBaby.birth),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                decoration: BoxDecoration(
                    color: const Color(0xffF9F8F8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29512F22),
                        blurRadius: 6,
                        spreadRadius: 3,
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('생활 기록', style: TextStyle(fontSize: 18, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('모유', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound')),
                            Text(_feeding, style: const TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound'))
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('젖병', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound')),
                            Text(_feedingBottle, style: const TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound'))
                          ],
                        ),)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('기저귀', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound')),
                            Text(_diaper, style: const TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound'))
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('수면', style: TextStyle(fontSize: 16, color: Color(0xff512F22), fontFamily: 'NanumSquareRound')),
                            Text(_sleep, style: const TextStyle(fontSize: 15, color: Color(0xff512F22), fontFamily: 'NanumSquareRound'))
                          ],
                        )),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //생활 기록 box
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                    flex:1,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(()=>BabyGrowthStatistics(currentBaby, myBabyGrowthRecordList)
                        );
                      },
                      child: Container(
                        height: 235,
                        margin: const EdgeInsets.fromLTRB(20, 0, 5, 10),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            color: const Color(0xffF9F8F8),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x29512F22),
                                blurRadius: 6,
                                spreadRadius: 3,
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
                                const Text('성장 기록',style: TextStyle(fontSize: 18, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w600)),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20)
                                              )
                                          ),
                                          backgroundColor: Colors.grey[100],
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ( BuildContext context ) {
                                            return GrowthRecordBottomSheet(currentBaby.relationInfo.BabyId);
                                          }
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle_outline, size: 25, color: Colors.black54)
                                ),
                              ],
                            ),
                            const Text('2023.05.06 갱신', style: TextStyle(color:Colors.grey, fontFamily: 'NanumSquareRound', fontSize: 12)),
                            const SizedBox(height: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('키', style: TextStyle(fontSize: 16, fontFamily: 'NanumSquareRound')),
                                Center(child: Text('90cm', style: TextStyle(fontSize: 17, fontFamily: 'NanumSquareRound'))),
                                SizedBox(height: 25),
                                Text('몸무게', style: TextStyle(fontSize: 16, fontFamily: 'NanumSquareRound')),
                                Center(child: Text('10kg', style: TextStyle(fontSize: 17, fontFamily: 'NanumSquareRound'))),
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
                                onTap: () {
                                  Get.to(() => BabyVaccination(currentBaby, myBabyvaccineList));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF9F8F8),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x29512F22),
                                          blurRadius: 6,
                                          spreadRadius: 3,
                                        )
                                      ]
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text('vaccination'.tr, style: const TextStyle(fontSize: 22, color: Colors.black)),
                                        const Text('예방 접종', style: TextStyle(fontSize: 18, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w600)),
                                        // Text(
                                        //   'next_vaccination'.tr,
                                        //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        // ),
                                        const SizedBox(height: 5,),
                                        const Text(
                                          '다음 예방 접종',
                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'NanumSquareRound'),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                            child: Text(
                                              nextVaccineDate,
                                              style: const TextStyle(fontSize: 18, color: Color(0xfffa625f), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'),
                                            )
                                        )
                                      ]
                                  ),
                                )
                            ),
                            //예방 접종 페이지 이동
                            const SizedBox(height: 15),
                            GestureDetector(
                                onTap: () {
                                  Get.to(()=>BabyMedicalCheckup(currentBaby, myBabyMedicalCheckList));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  width: double.infinity,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF9F8F8),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x29512F22),
                                          blurRadius: 6,
                                          spreadRadius: 3,
                                        )
                                      ]
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Text('medical_checkup'.tr, style: const TextStyle(fontSize: 22, color: Colors.black)),
                                        const Text('건강 검진', style: TextStyle(fontSize: 18, color: Color(0xff512F22), fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 5),
                                        const Text(
                                          '다음 건강 검진',
                                          style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'NanumSquareRound'),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                            child: Text(
                                              nextMedicalCheckUpDate,
                                              style: const TextStyle(fontSize: 18, color: Color(0xfffa625f), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 1),
                      child: Text('버튼을 길게 누르면 타이머가 작동합니다.',
                        style: TextStyle(color: Colors.grey[500], fontFamily: 'NanumSquareRound'),
                      ),
                    ),
                  ],
                )
            ),
            Offstage(
              offstage: !timerClosed,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    drawRecordButton(context, '모유', Icons.water_drop_outlined, Colors.red, const Color(0xffFFC8C8), 0),
                    drawRecordButton(context, '젖병', Icons.water_drop, Colors.orange, const Color(0xffFFD9C8), 1),
                    drawRecordButton(context, '이유식', Icons.rice_bowl_rounded, const Color(0xfffacc00), const Color(0xffFFF0C8), 2),
                    drawRecordButton(context, '기저귀', Icons.baby_changing_station, Colors.green, const Color(0xffE0FFC8), 3),
                    drawRecordButton(context, '수면', Icons.nights_stay_sharp, Colors.blueAccent, const Color(0xffC8F7FF), 4)
                  ],
                ),
              ),
            ),
            Offstage(
                offstage: timerClosed,
                child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: timerBackgroundColors
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                          )
                        ]
                    ),
                    child: stopWatchWidget
                )
            ),
            //타이머 구현
          ],
        ),
      ),

    );
  }

  //Drawer 데이터
  List<InkWell> getDrawerDatas(int relation, BuildContext context, Color color){
    List<InkWell> datas = [];
    for(int i=0; i<activeBabies.length; i++){
      Baby b = activeBabies[i];
      if(b.relationInfo.relation == relation){
        datas.add(
            InkWell(
                onTap: (){
                  setState(() {
                    widget.changeCurrentBabyFunction(i);
                    currentBaby = widget.getCurrentBabyFunction();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: 36,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        )
                      ],
                      border: Border(
                        left: BorderSide(
                            color: color,
                            width: 6.0
                        ),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(2,10,2,10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textBase(b.name, 'extra-bold', 12),
                        Row(
                          children: [
                            text(b.getGenderString()=='F' ? "여자" : "남자", 'bold', 10, Color(0x99512f22)),
                            SizedBox(width: 6),
                            textBase(DateFormat('yyyy-MM-dd').format(b.birth), 'bold', 10)
                          ],
                        )
                      ],
                    )
                )
            )
        );
      }
    }
    return datas;
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
                              log(result);
                              Get.back();
                            },
                            child: const Text('대변', style: TextStyle(color: Colors.black, fontFamily: 'NanumSquareRound'))
                        ),
                        const Divider(thickness: 0.2, color: Colors.grey),
                        TextButton(
                          onPressed: () async{
                            var content = {"type": 1, "startTime": now, "endTime": now, "memo": null};
                            var result = await lifesetService(currentBaby.relationInfo.BabyId, 3, content.toString());
                            log(result);
                            Get.back();
                          },
                          child: const Text('소변',style: TextStyle(color: Colors.black, fontFamily: 'NanumSquareRound')),
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
              Text(type, style: TextStyle(fontSize: 13, color: background, fontFamily: 'NanumSquareRound')), // <-- Text
            ],
          ),
        )
    );
  }

  //기록 버튼 클릭 시
  record_with_ModalBottomSheet(BuildContext rootContext, int tapMode){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        backgroundColor: Colors.grey[50],
        isScrollControlled: true,
        context: rootContext,
        builder: (BuildContext context) {
          if(tapMode==0){
            return FeedingBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
          }else if(tapMode==1){
            return FeedingBottleBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
          }
          else if(tapMode==2){
            return BabyFoodBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
          }
          else if(tapMode==3){
            return DiaperBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
          }
          else{
            return SleepBottomSheet(currentBaby.relationInfo.BabyId, addLifeRecord);
          }
        }
    );
  }

  //타이머 종료 시 bottomsheet
  showTimerBottomSheet(int type, DateTime startTime, DateTime endTime){
    if(type == 0){        // 모유
      Get.bottomSheet(
          Container(
              color: Colors.white,
              child: FeedingStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else if(type == 1) {    // 젖병
      Get.bottomSheet(
          Container(
              color: Colors.white,
              child: FeedingBottleStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else if(type == 2) {    // 이유식
      Get.bottomSheet(
          Container(
              color: Colors.white,
              child: BabyFoodStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else{                 // 수면
      Get.bottomSheet(
          Container(
            color: Colors.white,
            child: SleepStopwatchBottomSheet(
                currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord),
          ),
          isScrollControlled: true
      );
    }
  }
}

Widget drawBaby(String name, DateTime birth){
  final now = DateTime.now();
  return Container(
      padding: const EdgeInsets.only(left: 25),
      child: Column(
          children:[
            Row(
              children: [
                Image.asset('assets/image/baby1.png',scale: 2.7,),
                const SizedBox(width: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: const TextStyle(color: Color(0xff512F22), fontSize: 30, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(
                      '${birth.year}.${birth.month}.${birth.day}',
                      style: const TextStyle(color: Color(0xff512F22), fontSize: 17, fontFamily: 'NanumSquareRound'),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'D+ ${DateTime(now.year, now.month, now.day).difference(birth).inDays+2}',
                      style: const TextStyle(color: Color(0xff512F22), fontSize: 17, fontFamily: 'NanumSquareRound'),
                    ),
                  ],
                )
              ],
            )
          ]
      )
  );
}