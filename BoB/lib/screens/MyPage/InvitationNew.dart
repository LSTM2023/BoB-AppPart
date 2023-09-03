import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../models/validate.dart';
import '../../services/backend.dart';
import '../../widgets/appbar.dart';
import 'package:get/get.dart';
import '../BaseWidget.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:bob/widgets/text.dart';
import 'package:bob/widgets/form.dart';

class InvitationBottomSheet extends StatefulWidget{
  final List<Baby> babies;
  const InvitationBottomSheet(this.babies, {super.key});
  @override
  State<InvitationBottomSheet> createState() => _InvitationBottomSheet();
}
class _InvitationBottomSheet extends State<InvitationBottomSheet> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  // 선택 창
  String targetID = '';
  int selectedBabyIdx=-1;
  bool _getAdditionalInfo = false;
  List<String> selectedWeek = ['0','0','0','0','0','0','0'];   // 요일 택
  late TextEditingController idClr;
  late List<DropDownValueModel> babyValueList;
  late TextEditingController bNameClr;
  late TextEditingController bBirthClr;
  late String startTime;
  late String endTime;

  @override
  void initState() {
    idClr = TextEditingController();
    bNameClr = TextEditingController();
    bBirthClr = TextEditingController();
    startTime = "00:00";
    endTime = "23:59";
    babyValueList = getBabyList();
    super.initState();
  }
  List<bool> birthSelected = [true, false];
  int relationSelected = 0;
  getBabyList(){
    List<DropDownValueModel> tmp = [];
    for(int i=0; i<widget.babies.length; i++){
      tmp.add(DropDownValueModel(name:widget.babies[i].name, value: i));
    }
    return tmp;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 17, right: 17
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              textBase('invitation2_id'.tr, 'bold', 14),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                    children: [
                      Expanded(
                        child : TextFormField(
                          controller: idClr,
                          keyboardType: TextInputType.emailAddress,
                          decoration: formDecoration('invitation2_idDeco'.tr),
                          enabled: targetID.isEmpty,
                        ),
                      ),
                      IconButton(onPressed: () => duplicateCheck(), icon: targetID.isEmpty?const Icon(Icons.search):const Icon(Icons.check, color:Colors.green))
                    ]
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 143,
                    child: textBase('selectBaby'.tr, 'bold', 14),
                  ),
                  textBase('relation'.tr, 'bold', 14),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                        width: 120,
                        child: DropDownTextField(
                          textFieldDecoration: formDecoration(''),
                          //controller: ,
                          clearOption: false,
                          onChanged: (item){
                            selectedBabyIdx = item.value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Required field";
                            } else {
                              return null;
                            }
                          },
                          textStyle: const TextStyle(fontFamily: 'NanumSquareRound', fontSize: 14, color: Color(0x99512F22)),
                          listTextStyle: const TextStyle(fontFamily: 'NanumSquareRound', fontSize: 14, color: Color(0x99512F22)),
                          dropDownList: babyValueList,
                          dropDownItemCount: babyValueList.length,
                        )
                    ),
                    const SizedBox(width: 23),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(5.0),
                      fillColor: const Color(0xFFFB8665),
                      selectedColor : Colors.white,
                      color: const Color(0x99512F22),
                      onPressed: (int idx){
                        setState(() {
                          relationSelected = idx;
                          if(idx!=0){
                            _getAdditionalInfo = true;
                          }else{
                            _getAdditionalInfo = false;
                          }
                        });
                      },
                      isSelected: [relationSelected==0,relationSelected==1,relationSelected==2],
                      children: const [
                        SizedBox(
                            width: 70,
                            child: Center(
                                child: Text('relation0'.tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                            )
                        ),
                        SizedBox(
                            width: 70,
                            child: Center(
                                child: Text('relation1'.tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                            )
                        ),
                        SizedBox(
                            width: 90,
                            child: Center(
                                child: Text('relation2'.tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Offstage(
                offstage: !_getAdditionalInfo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBase('invitation2_accY'.tr, 'bold', 14),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: getWeek()
                    ),
                    const SizedBox(height: 18),
                    textBase('invitation2_accT'.tr, 'bold', 14),
                    const SizedBox(height: 8),
                    Padding(
                        padding: const EdgeInsets.only(left: 27, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text('$startTime ~ $endTime', 'bold', 14, Color(0x99512F22)),
                            OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)
                                      )
                                  ),
                                  side: const BorderSide(width: 1.5, color: Color(0xFFFB8665)),
                                ),
                                onPressed: () async {
                                  TimeRange result = await showTimeRangePicker(
                                    context: context,
                                    handlerColor: const Color(0xffff846d),
                                    strokeColor: const Color(0xffff846d),
                                  );
                                  setState(() {
                                    startTime = "${result.startTime.hour.toString().padLeft(2,'0')}:${result.startTime.minute.toString().padLeft(2,'0')}";
                                    endTime = "${result.endTime.hour.toString().padLeft(2,'0')}:${result.endTime.minute.toString().padLeft(2,'0')}";
                                  });
                                },
                                child: text('invitation2_setT'.tr, 'bold', 12, const Color(0xFFFB8665))
                            )
                          ],
                        )
                    ),
                  ],
                )
              ),
              const SizedBox(height: 72),
              ElevatedButton(
                  onPressed: () => invitation(),
                  style:ElevatedButton.styleFrom(
                      elevation: 0.2,
                      padding: const EdgeInsets.fromLTRB(0,17,0,11),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xfffb8665),
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                  ),
                  child: text('invitation'.tr, 'extra-bold', 16, Colors.white)
              ),
              const SizedBox(height: 20),
            ],
          )
        )
    );
  }
  void invitation() async{
    //String targetemail = idClr.text.trim();
    if(targetID.isEmpty){
      Get.snackbar('', 'select_id_invi'.tr, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      return;
    }
    if(selectedBabyIdx == -1){
      Get.snackbar('', 'select_baby_invi'.tr, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      return;
    }
    Baby invitBaby = widget.babies[selectedBabyIdx];
    Baby_relation relation;
    if(relationSelected == 0){  // -> 부모
      relation = Baby_relation(invitBaby.relationInfo.BabyId, 0, 127, "00:00", "23:59", false);
    }else{    // 가족 or 베이비시터
      relation = Baby_relation(invitBaby.relationInfo.BabyId, relationSelected, int.parse(selectedWeek.join(), radix: 2), startTime, endTime, false);
    }
    var tmp = relation.toJson();
    tmp['email'] = targetID;
    var result = await invitationService(tmp);
    Get.back();
  }

  void duplicateCheck() async {
    String email = idClr.text.trim();
    // 1. validation
    if(!validateEmail(email)){
      Get.snackbar('', 'keep_id'.tr, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
      return;
    }
    // 2. check
    String responseData = await emailOverlapService(email);
    print(responseData);
    if(responseData == "True"){
      Get.snackbar('경고', 'not_exist_ids'.tr, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    }else{
      setState(() {
        targetID = email;
      });
      Get.snackbar('검색 완료', 'find_exist'.tr, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    }
  }

  getWeek(){
    List<FilterChip> wget = [];
    for(int i=0; i<7; i++){
      wget.add(FilterChip(
            shape: const CircleBorder(
              side: BorderSide(
                color: Color(0x4D512F22)
              )
            ),
            padding: const EdgeInsets.all(12),
            selectedColor: const Color(0xFFFB8665),
            backgroundColor: Colors.white,
            label: text(week[i], 'bold', 12, (selectedWeek[i]=="1"? Colors.white : const Color(0x99512F22))),
            showCheckmark: false,
            selected: selectedWeek[i]=="1",
            onSelected: (bool notSelected){
              setState(() {
                if(notSelected){
                  if(selectedWeek[i]!=1){
                    selectedWeek[i] = "1";
                  }
                }
                else{
                  selectedWeek[i] = "0";
                }
              });
            }
      ));
    }
    return wget.toList();
  }
}