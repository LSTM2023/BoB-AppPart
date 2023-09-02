import 'package:flutter/material.dart';
import 'package:bob/widgets/pharse.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/model.dart';
import '../../services/backend.dart';
import '../../widgets/appbar.dart';
import '../../widgets/text.dart';

class BabyMedicalCheckup extends StatefulWidget {
  final Baby baby;
  final List<MedicalCheckUp> medicalCheckUps;
  const BabyMedicalCheckup(this.baby, this.medicalCheckUps, {Key? key}) : super(key: key);

  @override
  State<BabyMedicalCheckup> createState() => _BabyMedicalCheckup();
}

class _BabyMedicalCheckup extends State<BabyMedicalCheckup> {
  late Future _loadingFuture;
  late int finishCheck;

  @override
  void initState() {
    super.initState();
    _loadingFuture = reload();
  }

  Future reload() async {
    finishCheck = 0;
    for(int i=0; i<widget.medicalCheckUps.length; i++){
      if(widget.medicalCheckUps[i].isInoculation){
        setState(() {
          finishCheck +=1;
        });
      }
    }
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar('건강검진'),
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
              // 1. progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textBase('전체 $finishCheck/12', 'bold', 14),
                      textBase('${((finishCheck/12)*100).round()}% 완료', 'bold', 14)
                    ]
                )
              ),
              // 2. content
              Expanded(
                child: FutureBuilder(
                  future: _loadingFuture,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData == false){
                      return text('-', 'extra-bold', 15, const Color(0xccfb8665));
                    }
                    else if(snapshot.hasError){
                      return text('-', 'extra-bold', 15, const Color(0xccfb8665));
                    }
                    else{
                      return ListView(
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
                      );
                    }
                  },

                )
              ),
              // 3. explain comments
              getErrorPharse('생후 71개월전까지 검진'),
              getErrorPharse('기준 : 국민건강보험 영유아건강검진')
            ],
          )
      ),
    );
  }
  Padding drawDate(String date){
    return Padding(
        padding: const EdgeInsets.only(top:30, bottom: 5),
        child: text(date, 'extra-bold', 14, Colors.grey)
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
            color: const Color(0xffffeeee),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 0.5, color: Color(0xccFB8665))
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
                        text(medicalCheckUp.title, 'bold', 16, const Color(0xffFB8665)),
                        const SizedBox(width: 10),
                        text(medicalCheckUp.checkTimingToString(), 'regular', 12, Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 10),
                    text('검진 완료일 : ${DateFormat('yyyy.MM.dd').format(medicalCheckUp.checkUpDate)}', 'bold', 12, const Color(0xffFB8665)),
                  ],
                )
            ),
            Column(
              children: [
                Image.asset(iconPath, scale: 15, color: const Color(0xffFB8665)),
                const SizedBox(height: 5),
                text('검진 완료', 'bold', 12, const Color(0xffFB8665)),
              ],
            ),
          ],
        ),
      );
    }
    else{
      return InkWell(
        onTap: (){
          if(widget.medicalCheckUps[finishCheck].title == medicalCheckUp.title){
            openDialog(medicalCheckUp, iconPath);
          }else{
            Get.snackbar('주의', '이전 검진을 먼저 완료해주세요', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
          }
        },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            textBase(medicalCheckUp.title, 'bold', 16),
                            const SizedBox(width: 10),
                            text(medicalCheckUp.checkTimingToString(), 'regular', 12, Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 10),
                        textBase('검진기간 : ${medicalCheckUp.checkPeriod}', 'bold', 12),
                      ],
                    )
                ),
                Column(
                  children: [
                    Image.asset(iconPath, scale: 15, color: const Color(0xff512F22)),
                    const SizedBox(height: 5),
                    textBase('미검진', 'bold', 12),
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
                    textBase(checkUp.title, 'bold', 18),
                    IconButton(onPressed: () {Get.back();}, icon: const Icon(Icons.close, size: 18,)),
                  ],
                ),
                  content: SizedBox(
                    width: double.infinity,
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: ToggleButtons(
                                selectedBorderColor: Color(0xfffa625f),
                                selectedColor : Colors.white,
                                fillColor: const Color(0xffffdad1),
                                color: Colors.grey,
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
                                          Image.asset(iconPath,scale: 15, color: const Color(0xFF512F22)),
                                          const SizedBox(height: 5),
                                          textBase('미검진', 'bold', 12)
                                        ],
                                      )
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(iconPath, scale: 15, color: const Color(0xfffb8665)),
                                          const SizedBox(height: 5),
                                          text('검진', 'bold', 12, const Color(0xfffb8665))
                                        ],
                                      )
                                  )
                                ],
                              )
                          ),
                          const SizedBox(height: 10),
                          textBase('검진시기 : ${checkUp.checkTimingToString()}', 'bold', 14),
                          textBase('권장기간 : ${checkUp.checkPeriod}', 'bold', 14),
                          const SizedBox(height: 20),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(10),
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xfffb8665),
                                  ),
                                  onPressed: (){
                                    if(isSelected[1]){
                                      setMedicalCheckInfo(checkUp);
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
  setMedicalCheckInfo(MedicalCheckUp checkUp) async{
    var result = await vaccineSetService(widget.baby.relationInfo.BabyId, checkUp.title, 50 + checkUp.ID, 'y');
    if(result['result'] == 'success'){
      Get.snackbar('건강검진 완료', '${checkUp.title} 검진을 완료하였습니다', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 2));
      checkUp.isInoculation = true;
      checkUp.checkUpDate = DateTime.now();
      _loadingFuture = reload();
      /*setState(() {
        finishCheck += 1;

        //getCheckUpFuture = getMyCheckUpInfo();
      });*/
    }
  }
}