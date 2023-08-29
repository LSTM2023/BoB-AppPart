import 'package:flutter/material.dart';
import 'package:bob/widgets/pharse.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/model.dart';
import '../../services/backend.dart';

class BabyMedicalCheckup extends StatefulWidget {
  final Baby baby;
  final List<MedicalCheckUp> medicalCheckUps;
  const BabyMedicalCheckup(this.baby, this.medicalCheckUps, {Key? key}) : super(key: key);

  @override
  State<BabyMedicalCheckup> createState() => _BabyMedicalCheckup();
}

class _BabyMedicalCheckup extends State<BabyMedicalCheckup> {
  late int finishCheck;
  late Future getCheckUpFuture;
  @override
  void initState() {
    super.initState();
    getCheckUpFuture = getMyCheckUpInfo();
  }
  Future getMyCheckUpInfo() async{
    finishCheck = 0;
    // 0. 우선 전처리 하기
    List<dynamic> medicalCheckList = await vaccineCheckByIdService(widget.baby.relationInfo.BabyId); // 임시로 - 같이 사용

    for(int i=0; i<medicalCheckList.length; i++){
      int mode = medicalCheckList[i]['mode'];
      // 예외 처리
      if(mode<50) continue;
      setState(() {
        finishCheck +=1;
      });
      widget.medicalCheckUps[mode-50].isInoculation = true;
      widget.medicalCheckUps[mode-50].checkUpDate = DateTime.parse(medicalCheckList[i]['date']);
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffc8c7),
        elevation: 0.0,
        iconTheme : const IconThemeData(color: Colors.black),
        title: const Text('건강검진', style: TextStyle(color: Colors.black,fontSize: 20, fontFamily: 'NanumSquareRound')),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: const Color(0xffffaaa8),
                    value: (finishCheck/12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('전체 $finishCheck/12', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'NanumSquareRound')),
                      Text('${((finishCheck/12)*100).round()}% 완료', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'NanumSquareRound'))
                    ]
                )
              ),
              FutureBuilder(
                future: getCheckUpFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.hasData == false) {
                    return const CircularProgressIndicator(color: Color(0xfffa625f));
                  }
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 15, fontFamily: 'NanumSquareRound'),
                      ),
                    );
                  }
                  else {
                    //DrawCheckUpList();
                    return Expanded(
                        child: ListView(
                          children: [
                            drawDate(widget.medicalCheckUps[0].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[0]),
                            drawDate(widget.medicalCheckUps[1].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[1]),
                            drawDate(widget.medicalCheckUps[2].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[2]),
                            drawDate(widget.medicalCheckUps[3].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[3]),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[4]),
                            drawDate(widget.medicalCheckUps[5].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[5]),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[6]),
                            drawDate(widget.medicalCheckUps[7].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[7]),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[8]),
                            drawDate(widget.medicalCheckUps[9].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[9]),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[10]),
                            drawDate(widget.medicalCheckUps[11].drawDateString()),
                            drawMedicalCheckUpOne(widget.medicalCheckUps[11]),
                            const SizedBox(height: 30),
                          ],
                        )
                    );
                  }
                }
              ),
              getErrorPharse('생후 71개월전까지 검진'),
              getErrorPharse('기준 : 국민건강보험 영유아건강검진')
            ],
          )
      ),
    );
  }
  Padding drawDate(String date){
    return Padding(
      padding: const EdgeInsets.only(top:30),
      child: Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'NanumSquareRound')),
    );
  }
  Widget drawMedicalCheckUpOne(MedicalCheckUp medicalCheckUp){
    String iconPath;
    if(medicalCheckUp.ID == 4 || medicalCheckUp.ID == 6 || medicalCheckUp.ID == 8 || medicalCheckUp.ID == 10){
      iconPath = 'assets/image/tooth.png';
    }else{
      iconPath = 'assets/image/medicalHeart.png';
    }
    if(medicalCheckUp.isInoculation){
      return Container(
        decoration: BoxDecoration(
            color: Color(0xffffeeee),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.5,color: Color(0xfffa625f))
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(25),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(medicalCheckUp.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xfffa625f), fontFamily: 'NanumSquareRound')),
                        const SizedBox(width: 10),
                        Text(medicalCheckUp.checkTimingToString(), style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'NanumSquareRound'))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('검진 완료일 : ${DateFormat('yyyy.MM.dd').format(medicalCheckUp.checkUpDate)}', style: const TextStyle(fontSize: 14, fontFamily: 'NanumSquareRound'))
                  ],
                )
            ),
            Column(
              children: [
                Image.asset(iconPath, scale: 15, color: const Color(0xfffa625f)),
                const SizedBox(height: 5),
                const Text('검진 완료', style: TextStyle(color: Color(0xfffa625f), fontFamily: 'NanumSquareRound')),
              ],
            ),
          ],
        ),
      );
    }
    else{
      return InkWell(
        onTap: () => openDialog(medicalCheckUp, iconPath),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 0.5,color: Colors.grey)
          ),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(25),
          width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(medicalCheckUp.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'NanumSquareRound')),
                                const SizedBox(width: 10),
                                Text(medicalCheckUp.checkTimingToString(), style: const TextStyle(color: Colors.grey,fontSize: 14, fontFamily: 'NanumSquareRound'))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text('검진기간 : ${medicalCheckUp.checkPeriod}', style: const TextStyle(fontSize: 14, fontFamily: 'NanumSquareRound'))
                          ],
                        )
                    )
                ),
                Column(
                  children: [
                    Image.asset(iconPath, scale: 15),
                    const SizedBox(height: 5),
                    const Text('미검진'),
                  ],
                ),
              ],
            )
        ),
      );

    }
  }
  void openDialog(MedicalCheckUp checkUp, String iconPath){
    List<bool> isSelected = [true, false];
    Get.dialog(
        StatefulBuilder(
            builder: (BuildContext Mcontext, StateSetter setState){
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(checkUp.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: 'NanumSquareRound')),
                    IconButton(onPressed: () {Get.back();}, icon: Icon(Icons.close)),
                  ],
                ),
                  content: SizedBox(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Container(
                                  width: double.infinity,
                                  child: ToggleButtons(
                                    selectedBorderColor: Color(0xfffa625f),
                                    selectedColor: Colors.black,
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
                                              Image.asset(iconPath,scale: 15),
                                              const SizedBox(height: 5,),
                                              const Text('미검진', style: TextStyle(color: Colors.grey, fontFamily: 'NanumSquareRound'),)
                                            ],
                                          )
                                      ),
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(iconPath,scale: 15,color: const Color(0xfffa625f)),
                                              const SizedBox(height: 5,),
                                              const Text('검진', style: TextStyle(color: Color(0xfffa625f), fontFamily: 'NanumSquareRound'))
                                            ],
                                          )
                                      )
                                    ],
                                  )
                              )
                          ),
                          const SizedBox(height: 10),
                          Text('검진시기 : ${checkUp.checkTimingToString()}', style: TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound')),
                          Text('권장기간 : ${checkUp.checkPeriod}', style: TextStyle(fontSize: 18, fontFamily: 'NanumSquareRound')),
                          const SizedBox(height: 20,),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xffffc8c7),
                                  ),
                                  onPressed: (){
                                    if(isSelected[1]){
                                      setMedicalCheckInfo(checkUp.ID,checkUp.title, 'y');
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
  setMedicalCheckInfo(int tmpMode, String checkName, String state) async{
    var result = await vaccineSetService(widget.baby.relationInfo.BabyId, checkName, 50+tmpMode, state);
    if(result['result'] == 'success'){
      print('HI');
      Get.snackbar('건강검진 완료', '$checkName 검진을 완료하였습니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      setState(() {
        getCheckUpFuture = getMyCheckUpInfo();
      });
    }
  }
}