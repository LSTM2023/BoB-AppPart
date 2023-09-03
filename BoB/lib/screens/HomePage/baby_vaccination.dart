import 'package:bob/services/storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';

import '../../widgets/appbar.dart';
import '../../widgets/pharse.dart';
import '../../widgets/text.dart';

class BabyVaccination extends StatefulWidget {
  final Baby baby;
  final List<Vaccine> vaccines;
  const BabyVaccination(this.baby, this.vaccines,{Key? key}) : super(key: key);
  @override
  State<BabyVaccination> createState() => _BabyVaccination();
}

class _BabyVaccination extends State<BabyVaccination> {
  //late List<Vaccine> vaccines;
  late Future getMyVaccineFuture;
  late int currentMode;
  late Map<String, List<Widget>> vaccines1;
  late Map<String, List<Widget>> vaccines2;
  late Map<String, List<Widget>> vaccines3;
  late List<Map<String, List<Widget>>> vaccinesAll;
  @override
  void initState() {
    getMyVaccineFuture = getMyVaccineInfo();
    // 개월 수에 따라 선택 하도록!
    int duration = (DateTime.now()).difference(widget.baby.birth).inDays ~/ 30;
    if(duration <= 6){
      currentMode = 0;
    }else if(12 <= duration && duration <= 35){
      currentMode = 1;
    }else{
      currentMode = 2;
    }
    super.initState();
  }
  DrawVaccinateList(){
    vaccines1 = {
      '0M': drawMonthVaccines([0,1,2]),
      '1M': drawMonthVaccines([2]),
      '2M': drawMonthVaccines([4,5,6,7,8,9]),
      '4M': drawMonthVaccines([10,11,12,13,14,15]),
      '6M': drawMonthVaccines([16,17,18,19,20,21,22,23]),
    };
    vaccines2 = {
      '12M' : drawMonthVaccines([24, 25, 26, 27, 29,30, 31, 32, 34,35]),
      '15M' : drawMonthVaccines([24, 25, 26, 27, 28, 29,30, 31, 32, 34,35]),
      '18M' : drawMonthVaccines([28, 29, 30, 31, 32,34,35]),
      '23M' : drawMonthVaccines([29, 30, 31, 32, 34,35,36]),
      '35M' : drawMonthVaccines([33, 34,35,37]),
    };
    vaccines3 = {
      '4세' : drawMonthVaccines([38, 40, 41]),
      '6세' : drawMonthVaccines([38, 40, 41, 42]),
      '11세': drawMonthVaccines([39]),
      '12세': drawMonthVaccines([39,43,44]),
    };
    vaccinesAll = [vaccines1, vaccines2, vaccines3];
  }
  List<Widget> drawMonthVaccines(List<int> nums){
    List<Widget> tmp = [];
    for(int i=0; i<nums.length; i++){
      tmp.add(drawVaccineOne(widget.vaccines[nums[i]]));
    }
    return tmp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppbar('예방 접종'),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
              getErrorPharse('만 12세까지 접종'),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      chooseDate('0~6개월', 0),
                      chooseDate('12~35개월', 1),
                      chooseDate('만 4~12세', 2),
                    ],
                  )
              ),
              FutureBuilder(
                  future: getMyVaccineFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if (snapshot.hasData == false) {
                      return const CircularProgressIndicator(color: Colors.pinkAccent);
                    }
                    else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    else {
                      DrawVaccinateList();
                      return Expanded(
                          child: ListView.builder(
                              itemCount: vaccinesAll[currentMode].keys.length,
                              itemBuilder: (BuildContext ctx, int idx){
                                String myKey = vaccinesAll[currentMode].keys.toList()[idx];
                                return ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(myKey, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    children: vaccinesAll[currentMode][myKey]!.toList()
                                );
                              }
                          )
                      );
                    }
                  }
              ),
              const SizedBox(height: 5),
              getErrorPharse('기준 : 질병관리청 표준 예방접종 일정표'),
            ],
          ),
        )
    );
  }
  void openDialog(Vaccine vaccine){
    List<bool> isSelected = [true, false];
    Get.dialog(
      StatefulBuilder(
          builder: (BuildContext Mcontext, StateSetter setState){
            return AlertDialog(
              content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Text(vaccine.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(vaccine.times, style: TextStyle(fontSize: 18)),
                    Text(vaccine.detail, style: TextStyle(fontSize: 14)),
                    Text('권장시기 : ${vaccine.recommendationDate}', style: TextStyle(fontSize: 14)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: Container(
                          width: double.infinity,
                          child: ToggleButtons(
                            selectedColor: const Color(0xfffa625f),
                            constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 36) / 3, maxHeight: 80),
                            direction: Axis.horizontal,
                            onPressed: (int val){
                              setState(() {
                                isSelected = [(val==0), (val==1)];
                              });
                            },
                            isSelected: isSelected,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/image/injection.png',scale: 15),
                                      const SizedBox(height: 5,),
                                      const Text('미접종', style: TextStyle(color: Colors.grey),)
                                    ],
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/image/injection.png',scale: 15,color: Color(0xfffa625f)),
                                      const SizedBox(height: 5,),
                                      const Text('접종', style: TextStyle(color: Color(0xfffa625f)))
                                    ],
                                  )
                              )
                            ],
                          )
                        )
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                            elevation: 0.5,
                            backgroundColor: const Color(0xfffa625f),
                          ),
                          onPressed: (){
                            if(isSelected[1]){
                              setVaccineInfo(vaccine.ID,'${vaccine.title}(${vaccine.times})', 'y');
                            }
                            Get.back();
                          },
                          child: const Text('확인')
                      )
                    )
                  ],
                )
              )
            );
          }
      )
    );
  }

  Widget chooseDate(String title, int mode){
    return TextButton(
        onPressed: (){
          setState(() {
            currentMode = mode;
          });
        },
        child: text(
          title, 'bold', 16, (currentMode==mode?Colors.black:Colors.grey)
        )
    );
  }

  Widget drawVaccineOne(Vaccine vaccine){
    if(vaccine.isInoculation){
      return Container(
          decoration: BoxDecoration(
              color: const Color(0xffF9F8F8),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29512F22),
                  spreadRadius: 0,
                  blurRadius: 3.0,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              //border: Border.all(width: 0.5,color: Color(0xfffa625f))
          ),
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 100,
          child: Row(
            children: [
              Image.asset('assets/image/injection_fin.png', width: 60),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 22),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(vaccine.title, 'extra-bold', 14, Color(0xffFB8665)),
                          const SizedBox(height: 8),
                          text(vaccine.times, 'bold', 12, Color(0xcc512f22)),
                          text('접종일 : ${DateFormat.yMMMd().format(vaccine.inoculationDate)}', 'bold', 12, Color(0xcc512f22)),
                        ],
                      )
                  )
              )
            ],
          )
      );
    }
    else{
      return InkWell(
          onTap: (){
            openDialog(vaccine);
          },
          child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF9F8F8),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29512F22),
                    spreadRadius: 0,
                    blurRadius: 3.0,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                //border: Border.all(width: 0.5,color: Color(0xfffa625f))
              ),
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  Image.asset('assets/image/injection_be.png',width: 60),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 22),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textBase(vaccine.title, 'extra-bold', 14),
                              const SizedBox(height: 8),
                              text(vaccine.times, 'bold', 12, const Color(0xcc512f22)),
                              text('접종 권장일 : ${vaccine.recommendationDate}', 'bold', 12, Color(0xcc512f22)),
                            ],
                          )
                      )
                  )
                ],
              )
          )
      );
    }
  }

  // 예방접종 set 메소드(API 연결)
  setVaccineInfo(int mode, String checkName, String state) async{
    var result = await vaccineSetService(widget.baby.relationInfo.BabyId, checkName, mode, state);
    if(result['result'] == 'success'){
      Get.snackbar('예방접종 완료', '$checkName 접종을 작성하였습니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      setState(() {
        getMyVaccineFuture = getMyVaccineInfo();
      });
    }
  }
  Future getMyVaccineInfo() async{
    // 0. 우선 전처리 하기
    List<dynamic> vaccineList = await vaccineCheckByIdService(widget.baby.relationInfo.BabyId);
    // 1. mode(=ID)를 찾아 접종된 거는 처리
    for(int i=0; i<vaccineList.length; i++){
      int mode = vaccineList[i]['mode'];
      // 예외 처리
      if(mode>44) continue;
      widget.vaccines[mode].isInoculation = true;
      widget.vaccines[mode].inoculationDate = DateTime.parse(vaccineList[i]['date']);
    }
    return true;
  }
}