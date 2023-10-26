import 'package:bob/services/storage.dart';
import 'package:easy_localization/easy_localization.dart' hide StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/backend.dart';
import 'package:get/get.dart';
import '../../widgets/appbar.dart';
import '../../widgets/form.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppbar('vaccination'.tr),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
              getErrorPharse('vaccine_age'.tr),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: (){
                            setState(() { currentMode = 0; });
                          },
                          child: label('0~6 months'.tr, 'bold', 16, (currentMode == 0? 'black' : 'grey'))
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() { currentMode = 1; });
                          },
                          child: label('12~35 months'.tr, 'bold', 16, (currentMode == 1? 'black' : 'grey'))
                      ),
                      TextButton(
                          onPressed: (){
                            setState(() { currentMode = 2; });
                          },
                          child: label('ages 4-12'.tr, 'bold', 16, (currentMode == 2? 'black' : 'grey'))
                      )
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
                        child: label('Error: ${snapshot.error}', 'bold', 15, 'base100')
                      );
                    }
                    else {
                      drawVaccinateList();
                      return Expanded(
                          child: ListView.builder(
                              itemCount: vaccinesAll[currentMode].keys.length,
                              itemBuilder: (BuildContext ctx, int idx){
                                String myKey = vaccinesAll[currentMode].keys.toList()[idx];
                                return ExpansionTile(
                                    initiallyExpanded: true,
                                    title: label(myKey, 'extra-bold', 16, 'base100'),
                                    children: vaccinesAll[currentMode][myKey]!.toList()
                                );
                              }
                          )
                      );
                    }
                  }
              ),
              const SizedBox(height: 5),
              getErrorPharse('temperature_vac'.tr),
            ],
          ),
        )
    );
  }
  // 그리기
  drawVaccinateList(){
    vaccines1 = {
      '0M': drawMonthVaccines([0,1,2]),
      '1M': drawMonthVaccines([3]),
      '2M': drawMonthVaccines([4,5,6,7,8,9]),
      '4M': drawMonthVaccines([10,11,12,13,14,15]),
      '6M': drawMonthVaccines([16,17,18,19,20,21,22,23]),
    };
    vaccines2 = {
      '12M' : drawMonthVaccines([24, 25, 26, 27, 29,30, 31, 32, 34, 35]),
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
  List<Widget> drawMonthVaccines(List<int> month){
    List<Widget> tmp = [];
    for(int i=0; i<month.length; i++){
      tmp.add(drawVaccineOne(widget.vaccines[month[i]]));
    }
    return tmp;
  }
  Widget drawVaccineOne(Vaccine vaccine){
    Container content = Container(
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
            Image.asset('assets/image/injection_${vaccine.isInoculation?'fin':'be'}.png', width: 60),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.only(left: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label(vaccine.title, 'extra-bold', 14, 'primary'),
                        const SizedBox(height: 8),
                        label(vaccine.times, 'bold', 12, 'base80'),
                        label(
                            vaccine.isInoculation
                                ?'${'Vaccination_date'.tr}${DateFormat.yMMMd().format(vaccine.inoculationDate)}'
                                :'${'Recommended_vaccination'.tr}${vaccine.recommendationDate}'
                            , 'bold', 12, 'base80'),
                      ],
                    )
                )
            )
          ]
      ),
    );
    if(!vaccine.isInoculation){
      return InkWell(
          onTap: () => recordVaccine(vaccine),
          child: content
      );
    }
    return content;
  }

  // 작성 다이얼로그 제공
  void recordVaccine(Vaccine vaccine){
    List<bool> isSelected = [true, false];
    Get.dialog(
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                  content: SizedBox(
                      height: 320,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          label(vaccine.title, 'extra-bold', 16, 'base100'),
                          label(vaccine.times, 'bold', 16, 'base80'),
                          label(vaccine.detail, 'bold', 12, 'base80'),
                          label('${'Recommend_date'.tr}${vaccine.recommendationDate}', 'bold', 12, 'base80'),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                              child: SizedBox(
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
                                              Image.asset('assets/image/injection.png',scale: 15, color: const Color(0xFF512F22)),
                                              const SizedBox(height: 5,),
                                              label('Unvaccinated'.tr, 'bold', 12, 'base100')
                                            ],
                                          )
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/image/injection.png',scale: 15,color: const Color(0xfffb8665)),
                                              const SizedBox(height: 5,),
                                              label('Vaccinated'.tr, 'bold', 12, 'primary')
                                            ],
                                          )
                                      )
                                    ],
                                  )
                              )
                          ),
                          ElevatedButton(
                              style: btnStyleForm('white', 'primary', 5.0),
                              onPressed: () async {
                                if(isSelected[1]){
                                  setVaccineInfo(vaccine.ID,'${vaccine.title}(${vaccine.times})', 'y');
                                }
                                Get.back();
                              },
                              child: label('confirm'.tr, 'extra-bold', 16, 'white')
                          )
                        ],
                      )
                  )
              );
            }
        )
    );
  }

  /// My 접종 리스트 가져오기
  Future getMyVaccineInfo() async{
    List<dynamic> vaccineList = await vaccineCheckByIdService(widget.baby.relationInfo.BabyId);
    for(int i=0; i<vaccineList.length; i++){
      int mode = vaccineList[i]['mode'];
      if(mode>44) continue; // 예외 처리

      widget.vaccines[mode].isInoculation = true;
      widget.vaccines[mode].inoculationDate = DateTime.parse(vaccineList[i]['date']);
    }
    return true;
  }

  /// method for record vaccination (API 연결)
  setVaccineInfo(int mode, String checkName, String state) async{
    var result = await vaccineSetService(widget.baby.relationInfo.BabyId, checkName, mode, state);
    if(result['result'] == 'success'){
      Get.snackbar('Vaccination_completed'.tr, '$checkName ${'Vaccination_finish'.tr}');
      setState(() {
        getMyVaccineFuture = getMyVaccineInfo();
      });
    }
  }

}