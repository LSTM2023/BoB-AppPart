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
import 'package:bob/screens/HomePage/Statistic/baby_growthStatistics.dart';
import 'package:bob/screens/HomePage/baby_medicalCheckup.dart';
import 'package:bob/screens/HomePage/baby_vaccination.dart';
import 'package:bob/widgets/pharse.dart';
import 'package:bob/widgets/text.dart';
import 'package:bob/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bob/services/backend.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;

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

  DateTime? last_feeding;          // 모유
  DateTime? last_feedingBottle ;   // 젖병
  DateTime? last_babyfood;         // 이유식
  DateTime? last_diaper;           // 기저귀
  DateTime? last_sleep ;           // 수면

  bool timerClosed = true;

  List<Vaccine> myBabyVaccineList = [];
  late List<MedicalCheckUp> myBabyMedicalCheckList;
  late List<GrowthRecord> myBabyGrowthRecordList = [];

  void addLifeRecord(int type, String val, DateTime lastDate){
    setState(() {
      if(type==0){
        _feeding = val;
        last_feeding = lastDate;
      }
      else if(type==1){
        _feedingBottle = val;
        last_feedingBottle = lastDate;
      }
      else if(type==2){
        _babyfood = val;
        last_babyfood = lastDate;
      }
      else if(type==3){
        _diaper = val;
        last_diaper = lastDate;
      }
      else{
        _sleep = val;
        last_sleep = lastDate;
      }
    });
  }

  closeOffset(){
    setState(() {
      timerClosed = true;
    });
  }

  Color timerBackgroundColor = Colors.black;

  int timerType = 0;
  late StopWatch stopWatchWidget;

  String nextVaccineDate = '';

  String nextMedicalCheckDate = '-';
  String nextVaccineCheckDate = '-';

  late Future getGrowthRecord;
  late List<dynamic> getGrowthRecordList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeBabies = widget.getBabiesFunction(true);
    currentBaby = widget.getCurrentBabyFunction();
    stopWatchWidget = StopWatch(currentBaby, key : _stopwatchKey, closeFuction: closeOffset, saveFuction: showTimerBottomSheet);
    getGrowthRecord = getMyGrowthInfo();

    loadMyBabyMedicalInfo();
    loadLastLifeRecord();
  }

  Future getMyGrowthInfo() async{
    List<dynamic> growthRecordList = await growthGetService(currentBaby.relationInfo.BabyId);
    getGrowthRecordList = growthRecordList;

    // print(getGrowthRecordList);
    return getGrowthRecordList;
  }

  Future<void> loadLastLifeRecord() async{
    List<dynamic> datas = await lifeGetService(currentBaby.relationInfo.BabyId);
    List<DateTime> map = [DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now()];
    for(int i=0; i<datas.length;i++){
      var content = datas[i]['content'];
      // content = jsonDecode(content);
      // print(content['type']);
    }
  }

  Future<void> loadMyBabyMedicalInfo() async{
    myBabyVaccineList =  [
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
    myBabyMedicalCheckList = [
      MedicalCheckUp(0, '1차 건강검진',[1, 14, 35]),
      MedicalCheckUp(1, '2차 건강검진',[0, 4, 6]),
      MedicalCheckUp(2, '3차 건강검진',[0, 9, 12]),
      MedicalCheckUp(3, '4차 건강검진',[0, 18, 24]),
      MedicalCheckUp(4, '1차 구강검진',[0, 18, 24]),
      MedicalCheckUp(5, '5차 건강검진',[0, 30, 36]),
      MedicalCheckUp(6, '2차 구강검진',[0, 30, 41]),
      MedicalCheckUp(7, '6차 건강검진',[0, 42, 48]),
      MedicalCheckUp(8, '3차 구강검진',[0, 42, 53]),
      MedicalCheckUp(9, '7차 건강검진',[0, 54, 60]),
      MedicalCheckUp(10, '4차 구강검진',[0, 54, 65]),
      MedicalCheckUp(11, '8차 건강검진',[0, 66, 71])
    ];  // loading
    for(int i=0; i< myBabyMedicalCheckList.length; i++){
      myBabyMedicalCheckList[i].setCheckPeriod(currentBaby.birth);
    }
    int nextMedicalDate = 50;
    int nextVaccineDate = 0;
    List<dynamic> data = await vaccineCheckByIdService(currentBaby.relationInfo.BabyId); // 임시로 - 같이 사용
    for(int i=0; i<data.length; i++){
      int mode = data[i]['mode'];
      // 예외 처리
      if(mode<50) {
        //print('vaccin : + ' + nextVaccineDate.toString());
        myBabyVaccineList[mode].isInoculation = true;
        myBabyVaccineList[mode].inoculationDate= DateTime.parse(data[i]['date']);
        nextVaccineDate += 1;
      }
      else{
        //print('medical : + ' + nextMedicalDate.toString());
        myBabyMedicalCheckList[mode-50].isInoculation = true;
        myBabyMedicalCheckList[mode-50].checkUpDate = DateTime.parse(data[i]['date']);
        nextMedicalDate += 1;
      }
    }
    setState(() {
      if((nextMedicalDate-50) < myBabyMedicalCheckList.length)
        nextMedicalCheckDate = myBabyMedicalCheckList[nextMedicalDate-50].title;
      else
        nextMedicalCheckDate = 'finish'.tr;

      if(nextVaccineDate < myBabyVaccineList.length)
        nextVaccineCheckDate = myBabyVaccineList[nextVaccineDate].title;
      else
        nextVaccineCheckDate = 'finish'.tr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: label("BoB", "bold", 20, 'base100'),
        backgroundColor: const Color(0xffffccbf),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Color(0xff512F22)),
      ),
      drawer: Drawer(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  label('babyList'.tr, 'extra-bold', 20, 'base100'),
                  const SizedBox(height: 8),
                  label('babyListC'.tr, 'bold', 12, 'base100'),
                  const SizedBox(height: 29),
                  Expanded(
                    child: ListView(
                      children: [
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              title: label('relation0'.tr, 'extra-bold', 15, 'base100'),
                              children: getDrawerDatas(0, context, const Color(0xfffa625f))
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              title: label('relation1'.tr, 'extra-bold', 15, 'base100'),
                              children: getDrawerDatas(1, context, Colors.blueAccent)
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(
                              initiallyExpanded: true,
                              title: label('relation2'.tr, 'extra-bold', 15, 'base100'),
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
              height: 180,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffffccbf), Color(0xffffe1c7)]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(88, 70, 57, 30),
                      blurRadius: 4.0,
                      spreadRadius: 3,
                    )
                  ]),
              child: Center(
                child: drawBaby(currentBaby.name, currentBaby.birth, currentBaby.gender),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        label('life_record'.tr, 'bold', 15, 'base100'),
                        IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.only(right: 8),
                            onPressed: () {
                              setState(() {
                                if(last_feeding != null){
                                  _feeding = getlifeRecordPharse(DateTime.now().difference(last_feeding!));
                                }if(last_feedingBottle != null){
                                  _feedingBottle = getlifeRecordPharse(DateTime.now().difference(last_feedingBottle!));
                                }if(last_babyfood != null){
                                  _babyfood = getlifeRecordPharse(DateTime.now().difference(last_babyfood!));
                                }if(last_diaper != null){
                                  _diaper = getlifeRecordPharse(DateTime.now().difference(last_diaper!));
                                }if(last_sleep != null){
                                  _sleep = getlifeRecordPharse(DateTime.now().difference(last_sleep!));
                                }
                              });
                            },
                            icon: const Icon(Icons.refresh_outlined, size: 21, color: Color(0xff512F22))
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label('life0'.tr, 'bold', 13, 'base80'),
                            label(_feeding, 'bold', 13, 'base80')
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label('life1'.tr, 'bold', 13, 'base80'),
                            label(_feedingBottle, 'bold', 13, 'base80')
                          ],
                        ),)
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label('life3'.tr, 'bold', 13, 'base80'),
                            label(_diaper, 'bold', 13, 'base80')
                          ],
                        )),
                        const SizedBox(width: 30),
                        Expanded(flex:1,child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label('life4'.tr, 'bold', 13, 'base80'),
                            label(_sleep, 'bold', 13, 'base80')
                          ],
                        )),
                        const SizedBox(height: 20),
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
                      onTap: () async{
                        List<dynamic> growthRecordList = await growthGetService(currentBaby.relationInfo.BabyId);
                        if(growthRecordList.isEmpty){
                          Get.snackbar('데이터 오류', '먼저 키, 몸무게를 입력해 주세요', backgroundColor: const Color(0xa3ffffff), snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      topLeft: Radius.circular(25)
                                  )
                              ),
                              backgroundColor: const Color(0xffF9F8F8),
                              isScrollControlled: true,
                              context: context,
                              builder: ( BuildContext context ) {
                                return GrowthRecordBottomSheet(currentBaby.relationInfo.BabyId);
                              }
                          );
                        }else {
                          Get.to(()=>BabyGrowthStatistics(currentBaby, myBabyGrowthRecordList));
                          await getMyGrowthInfo();
                        }
                      },
                      child: Container(
                        height: 215,
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
                                label('grow_record'.tr, 'bold', 15, 'base100'),
                                IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.only(right: 8),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft: Radius.circular(25)
                                              )
                                          ),
                                          backgroundColor: const Color(0xffF9F8F8),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ( BuildContext context ) {
                                            return GrowthRecordBottomSheet(currentBaby.relationInfo.BabyId);
                                          }
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle_outline, size: 21, color: Color(0xff512F22))
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if(getGrowthRecordList.isEmpty)
                              label('first_growth_record'.tr, 'normal', 11, 'grey'),
                            if(getGrowthRecordList.isNotEmpty)
                              label('${getGrowthRecordList.last['date'].toString()} ${'new_update'.tr}', 'noraml', 12, 'grey'),
                            const SizedBox(height: 23),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                label('height'.tr, 'bold', 14, 'base80'),
                                const SizedBox(height: 5),
                                if(getGrowthRecordList.isEmpty)
                                  Center(child: label('0cm', 'normal', 15, 'base80')),
                                if(getGrowthRecordList.isNotEmpty)
                                  Center(child: label('${getGrowthRecordList.last['height'].toString()}cm', 'normal', 15, 'base80')),
                                const SizedBox(height: 28),
                                label('weight'.tr, 'bold', 14, 'base80'),
                                const SizedBox(height: 5),
                                if(getGrowthRecordList.isEmpty)
                                  Center(child: label('0kg', 'normal', 15, 'base80')),
                                if(getGrowthRecordList.isNotEmpty)
                                Center(child: label('${getGrowthRecordList.last['weight'].toString()}kg', 'normal', 15, 'base80')),
                                 ],
                            )
                          ],
                        ),
                      ),
                    )
                ),
                //성장기록 box
                Expanded(
                    flex:1,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                        child: Column(
                          children: [
                            //예방 접종 페이지 이동
                            GestureDetector(
                                onTap: () async{
                                  await Get.to(() => BabyVaccination(currentBaby, myBabyVaccineList));
                                  await loadMyBabyMedicalInfo();
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(13, 15, 13, 13),
                                  height: 100,
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
                                        label('vaccination'.tr, 'bold', 15, 'base100'),
                                        const SizedBox(height: 10),
                                        label('next_vaccination'.tr, 'bold', 10, 'base80'),
                                        const SizedBox(height: 16),
                                        Center(
                                            child: label(nextVaccineCheckDate, 'extra-bold', 12, 'primary80')
                                        )
                                      ]
                                  ),
                                )
                            ),
                            const SizedBox(height: 15),
                            //건강 검진 페이지 이동
                            GestureDetector(
                                onTap: () async{
                                  await Get.to(()=>BabyMedicalCheckup(currentBaby, myBabyMedicalCheckList));
                                  await loadMyBabyMedicalInfo();
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(13, 15, 13, 13),
                                  height: 100,
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
                                        label('medical_checkup'.tr, 'bold', 15, 'base100'),
                                        const SizedBox(height: 10),
                                        label('next_medical_checkup'.tr, 'bold', 10, 'base80'),
                                        const SizedBox(height: 16),
                                        Center(
                                          child: label(nextMedicalCheckDate, 'extra-bold', 14, 'primary80')
                                        )
                                      ]
                                  ),
                                )
                            )
                          ],
                        )
                    )
                )
                //예방 접종, 건강 검진 box 구현
              ],
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                margin: const EdgeInsets.only(left: 10, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: label('timer_explanation'.tr, 'bold', 11, 'grey'),
                    ),
                  ],
                )
            ),
            // 버튼을 길게 누르면 타이머가 작동합니다.
            Offstage(
              offstage: !timerClosed,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    drawRecordButton(context, 'life0'.tr, 'assets/icon/feeding_icon.svg', Colors.redAccent, const Color(0xffFFC8C8), 0),
                    drawRecordButton(context, 'life1'.tr, 'assets/icon/feedingbottle_icon.svg', Colors.orange, const Color(0xffFFD9C8), 1),
                    drawRecordButton(context, 'life2'.tr, 'assets/icon/babyfood_icon.svg', const Color(0xfffab300), const Color(0xffFFF0C8), 2),
                    drawRecordButton(context, 'life3'.tr, 'assets/icon/diaper_icon.svg', Colors.green, const Color(0xffE0FFC8), 3),
                    drawRecordButton(context, 'life4'.tr, 'assets/icon/sleep_icon.svg', Colors.blueAccent, const Color(0xffC8F7FF), 4)
                  ],
                ),
              ),
            ),
            // 생활 기록 입력 버튼
            Offstage(
                offstage: timerClosed,
                child: stopWatchWidget
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
                    loadMyBabyMedicalInfo();
                    getMyGrowthInfo();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: 36,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
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
                        label(b.name, 'extra-bold', 13, 'base100'),
                        Row(
                          children: [
                            label(b.getGenderString()=='F' ? 'genderF'.tr : 'genderM'.tr, 'bold', 12, 'base63'),
                            const SizedBox(width: 6),
                            label(DateFormat('yyyy-MM-dd').format(b.birth), 'bold', 12, 'base100')
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

  // 생활 기록 버튼 롱 클릭 시
  InkWell drawRecordButton(BuildContext rootContext, String type, String iconData, Color background, Color color, int tapMode){
    return InkWell(
        onTap: () => record_with_ModalBottomSheet(rootContext, tapMode),
        onLongPress: (){
          if(tapMode==3){
            DateTime now = DateTime.now();
            // 1. 시간 저장
            // 2. dialog - 대/소변
            Get.dialog(
                AlertDialog(
                    backgroundColor: const Color(0xffF4FFEC),
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
                            child: label('life3_0'.tr, 'bold', 16, 'base100'),
                        ),
                        const Divider(thickness: 0.3, color: Color(0xff512F22)),
                        TextButton(
                          onPressed: () async{
                            var content = {"type": 1, "startTime": now, "endTime": now, "memo": null};
                            var result = await lifesetService(currentBaby.relationInfo.BabyId, 3, content.toString());
                            print(result);
                            Get.back();
                          },
                          child: label('life3_1'.tr, 'bold', 16, 'base100'),
                        ),
                      ],
                    )
                )
            );
          }
          else{
            timerType = tapMode;
            // timerBackgroundColor = timerBackgroundColor;
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
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(88, 70, 57, 30).withOpacity(0.2),
                blurRadius:5,
                spreadRadius: 1
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(iconData, color: background), // <-- Icon
              const SizedBox(height: 3),
              Text(type, style: TextStyle(fontSize: 12, color: background, fontFamily: 'NanumSquareRound', fontWeight: FontWeight.bold)), // <-- Text
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
        backgroundColor: const Color(0xffF9F8F8),
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
    if(type == 0){          // 모유
      Get.bottomSheet(
          SizedBox(
              child: FeedingStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else if(type == 1) {    // 젖병
      Get.bottomSheet(
          SizedBox(
              child: FeedingBottleStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else if(type == 2) {    // 이유식
      Get.bottomSheet(
          SizedBox(
              child: BabyFoodStopwatchBottomSheet(
                  currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord)
          ),
          isScrollControlled: true
      );
    }
    else{                   // 수면
      Get.bottomSheet(
          SizedBox(
            child: SleepStopwatchBottomSheet(
                currentBaby.relationInfo.BabyId, startTime, endTime, changeRecord: addLifeRecord),
          ),
          isScrollControlled: true
      );
    }
  }
}

// 홈 아기 정보 표시
Widget drawBaby(String name, DateTime birth, int gender){
  final now = DateTime.now();
  return Container(
      padding: const EdgeInsets.only(left: 22),
      child: Column(
          children:[
            Row(
              children: [
                if(gender == 0)
                  Image.asset('assets/image/baby4.png',scale: 3.0,),
                if(gender == 1)
                  Image.asset('assets/image/baby1.png',scale: 3.0,),
                const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label(name, 'extra-bold', 32, 'base100'),
                    const SizedBox(height: 8),
                    label('${birth.year}.${birth.month}.${birth.day}', 'bold', 15, 'base100'),
                    const SizedBox(height: 5),
                    label('D+ ${DateTime(now.year, now.month, now.day).difference(birth).inDays+2}', 'bold', 15, 'base100'),
                  ],
                )
              ],
            )
          ]
      )
  );
}