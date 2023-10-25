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
import '../models/medicalList.dart';

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
  late List<Baby> activeBabies;   // 로그인 된 계정 아기 리스트
  late Baby currentBaby;          // 현재 선택한 아기

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

  List<Vaccine> myBabyVaccineList = [];                   // 예방 접종 리스트
  late List<MedicalCheckUp> myBabyMedicalCheckList;       // 건강 검진 리스트
  late List<GrowthRecord> myBabyGrowthRecordList = [];    // 성장 기록 리스트

  void addLifeRecord(int type, String val, DateTime lastDate){  // 생활 기록 출력 함수
    setState(() {
      if(type==0){  // 모유
        _feeding = val;
        last_feeding = lastDate;
      }
      else if(type==1){   // 젖병
        _feedingBottle = val;
        last_feedingBottle = lastDate;
      }
      else if(type==2){   // 이유식
        _babyfood = val;
        last_babyfood = lastDate;
      }
      else if(type==3){   // 기저귀
        _diaper = val;
        last_diaper = lastDate;
      }
      else{   // 수면
        _sleep = val;
        last_sleep = lastDate;
      }
    });
  }

  closeOffset(){    // 타이머 숨김
    setState(() {
      timerClosed = true;
    });
  }

  int timerType = 0;    // 타이머 종류 0:모유 / 1:젖병 / 2:이유식 / 3:기저귀 / 4:수면
  late StopWatch stopWatchWidget;   // 스탑워치 위젯

  String nextVaccineCheckDate = '-';    // 다음 예방 접종 데이터
  String nextMedicalCheckDate = '-';    // 다음 건강 검진 데이터

  late Future getGrowthRecord;                    // 성장 기록 가져오기
  late List<dynamic> getGrowthRecordList = [];    // 성장 기록 리스트

  @override
  void initState() {    // 초기 호출 메서드
    // TODO: implement initState
    super.initState();
    activeBabies = widget.getBabiesFunction(true);
    currentBaby = widget.getCurrentBabyFunction();
    stopWatchWidget = StopWatch(currentBaby, key : _stopwatchKey, closeFuction: closeOffset, saveFuction: showTimerBottomSheet);

    getGrowthRecord = getMyGrowthInfo();
    loadMyBabyMedicalInfo();
    loadLastLifeRecord();
  }

  Future getMyGrowthInfo() async{     // 성장 기록 정보 불러오기
    List<dynamic> growthRecordList = await growthGetService(currentBaby.relationInfo.BabyId);
    getGrowthRecordList = growthRecordList;

    // print(getGrowthRecordList);
    return getGrowthRecordList;
  }

  Future<void> loadLastLifeRecord() async{      // 생활 기록 정보 불러오기
    List<dynamic> data = await lifeGetService(currentBaby.relationInfo.BabyId);
    List<DateTime> map = [DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now(), DateTime.now()];
    for(int i=0; i<data.length;i++){
      var content = data[i]['content'];
      // content = jsonDecode(content);
      // print(content['type']);
    }
  }

  /// 현재 관리중인 아기의 건강 검진/예방접종 정보 가져오기
  Future<void> loadMyBabyMedicalInfo() async{
    // sample 가져오기
    myBabyVaccineList = vaccineCheckupsSample;
    myBabyMedicalCheckList = medicalCheckupsSample;
    // 현재 관리 중인 아기 생일에 맞춰 접종 권장시기 설정
    for(int i=0; i< myBabyMedicalCheckList.length; i++){
      myBabyMedicalCheckList[i].setCheckPeriod(currentBaby.birth);
    }
    for(int i=0; i< myBabyVaccineList.length; i++){
      myBabyVaccineList[i].setCheckPeriod(currentBaby.birth);
    }
    // 아기의 접종 현황 불러오기
    List<dynamic> data = await vaccineCheckByIdService(currentBaby.relationInfo.BabyId);
    List<bool> vaccs = List.filled(45, false);
    List<bool> meds = List.filled(12, false);
    for(int i=0; i<data.length; i++){
      int mode = data[i]['mode'];
      if(mode < 50) {
        myBabyVaccineList[mode].isInoculation = true;
        myBabyVaccineList[mode].inoculationDate= DateTime.parse(data[i]['date']);
        vaccs[mode] = true;
      }
      else{
        myBabyMedicalCheckList[mode-50].isInoculation = true;
        myBabyMedicalCheckList[mode-50].checkUpDate = DateTime.parse(data[i]['date']);
        meds[mode-50] = true;
      }
    }
    setState(() {     // 다음 백신 및 예방 접종 상태 설정
      nextMedicalCheckDate = (meds.contains(false))
          ? myBabyMedicalCheckList[meds.indexOf(false)].title
          : 'finish'.tr;

      nextVaccineCheckDate = (vaccs.contains(false))
          ? myBabyVaccineList[vaccs.indexOf(false)].title
          : 'finish'.tr;

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
                          child:ExpansionTile(    // 부모
                              initiallyExpanded: true,
                              title: label('relation0'.tr, 'extra-bold', 15, 'base100'),
                              children: getDrawerDatas(0, context, const Color(0xfffa625f))
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(    // 가족
                              initiallyExpanded: true,
                              title: label('relation1'.tr, 'extra-bold', 15, 'base100'),
                              children: getDrawerDatas(1, context, Colors.blueAccent)
                          ),
                        ),
                        SingleChildScrollView(
                          child:ExpansionTile(    // 베이비시터
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
      // 아기 목록 Drawer 구현
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
                child: drawBaby(currentBaby.name, currentBaby.birth, currentBaby.gender),   // 아기 정보 출력
              ),
            ),
            GestureDetector(    // 생활 기록 box 시작
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
                Expanded(     // 성장 기록 box 시작
                    flex:1,
                    child: GestureDetector(
                      onTap: () async{
                        List<dynamic> growthRecordList = await growthGetService(currentBaby.relationInfo.BabyId);
                        if(growthRecordList.isEmpty){     // 성장 기록 데이터가 없으면 에러 알림 출력
                          Get.snackbar('데이터 오류', '먼저 키, 몸무게를 입력해 주세요', backgroundColor: const Color(0xa3ffffff), snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
                          // ignore: use_build_context_synchronously
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
                                return GrowthRecordBottomSheet(currentBaby, currentBaby.relationInfo.BabyId);
                              }
                          );
                        }else {       // 성장 통계 페이지로 이동
                          Get.to(()=>BabyGrowthStatistics(currentBaby, myBabyGrowthRecordList));
                          await getMyGrowthInfo();
                        }
                      },
                      child: Container(
                        height: 225,
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
                                            return GrowthRecordBottomSheet(currentBaby, currentBaby.relationInfo.BabyId);    // 성장 기록 sheet
                                          }
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle_outline, size: 21, color: Color(0xff512F22))
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if(getGrowthRecordList.isEmpty)
                              label('first_growth_record'.tr, 'normal', 11, 'Grey'),
                            if(getGrowthRecordList.isNotEmpty)
                              label('${getGrowthRecordList.last['date'].toString()} ${'new_update'.tr}', 'noraml', 12, 'Grey'),
                            const SizedBox(height: 23),
                            Column(   // 아기 성장 기록 정보 출력
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
                                  height: 105,
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
                                  child: Column(  // 다음 예방 접종 출력
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        label('vaccination'.tr, 'bold', 15, 'base100'),
                                        const SizedBox(height: 10),
                                        label('next_vaccination'.tr, 'bold', 10, 'base80'),
                                        const SizedBox(height: 16),
                                        Center(
                                            child: label(nextVaccineCheckDate, 'extra-bold', 14, 'primary80')
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
                                  height: 105,
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
                                  child: Column(    // 다음 건강 검진 출력
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

  //Drawer 데이터(아기 리스트)
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
                              addLifeRecord(3, getlifeRecordPharse(const Duration(seconds: 0)), now);
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
                            addLifeRecord(3, getlifeRecordPharse(const Duration(seconds: 0)), now);
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