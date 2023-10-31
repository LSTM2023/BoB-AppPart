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
  final String myEmail;
  final List<Baby> babies;
  const InvitationBottomSheet(this.myEmail, this.babies, {super.key});
  @override
  State<InvitationBottomSheet> createState() => _InvitationBottomSheet();
}
class _InvitationBottomSheet extends State<InvitationBottomSheet> {

  late TextEditingController targetIdClr;   // 초대할 사람의 ID 입력
  late int selectedBabyIdx;                   // 대상 아기 선택
  late int selectedRel;                     // 관계(0:부모, 1:가족, 2:베이비시터)
  late List<DropDownValueModel> babyValueList;
  late List<int> allowedWeek;               // 요일 택
  late List<int> allowedTime;               // [시작 시간, 종료 시간]

  bool additionalInfoFlag = false;          // Offstage flag
  bool selectedTargetID = false;

  final List<String> week = ['week0'.tr[0], 'week1'.tr[0], 'week2'.tr[0], 'week3'.tr[0], 'week4'.tr[0], 'week5'.tr[0], 'week6'.tr[0]];

  @override
  void initState() {
    targetIdClr = TextEditingController();
    selectedBabyIdx = -1;
    selectedRel = 0;
    allowedWeek = [0, 0, 0, 0, 0, 0, 0];
    allowedTime = [12,0,20,0];
    babyValueList = getBabyList();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    targetIdClr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: bottomSheetPadding(context, 17.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              label('invitation2_id'.tr, 'bold', 14, 'base100'),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Row(
                    children: [
                      Expanded(
                        child : TextFormField(
                          controller: targetIdClr,
                          keyboardType: TextInputType.emailAddress,
                          decoration: formDecoration('invitation2_idDeco'.tr),
                          enabled: !selectedTargetID,
                        ),
                      ),
                      IconButton(   // 중복 체크 버튼
                        onPressed: () => duplicateCheck(targetIdClr.text.trim()),
                        icon: selectedTargetID ? const Icon(Icons.check, color:Colors.green) : const Icon(Icons.search)
                      )
                    ]
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 143,
                    child: label('selectBaby'.tr, 'bold', 14, 'base100'),
                  ),
                  label('relation'.tr, 'bold', 14, 'base100'),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                        width: 100,
                        child: DropDownTextField(
                          textFieldDecoration: formDecoration(''),
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
                    const SizedBox(width: 20),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(5.0),
                      fillColor: const Color(0xFFFB8665),
                      selectedColor : Colors.white,
                      onPressed: (int idx){
                        setState(() {
                          selectedRel = idx;
                          additionalInfoFlag = (idx!=0) ? true : false;
                        });
                      },
                      isSelected: [selectedRel==0,selectedRel==1,selectedRel==2],
                      children: [
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 120)/5,
                            child: Center(
                                child: label('relation0'.tr, 'bold', 12, (selectedRel==0)?'white':'base100')
                            )
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 120)/4,
                            child: Center(
                                child: label('relation1'.tr, 'bold', 12, (selectedRel==1)?'white':'base100')
                            )
                        ),
                        SizedBox(
                            width: (MediaQuery.of(context).size.width - 120)/3,
                            child: Center(
                                child: label('relation2'.tr, 'bold', 12, (selectedRel==2)?'white':'base100')
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Offstage(
                offstage: !additionalInfoFlag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 접근 요일
                    label('invitation2_accY'.tr, 'bold', 14, 'base100'),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: getWeek()
                    ),
                    const SizedBox(height: 18),
                    // 접근 시간
                    label('invitation2_accT'.tr, 'bold', 14, 'base100'),
                    const SizedBox(height: 8),
                    Padding(
                        padding: const EdgeInsets.only(left: 27, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label(
                                "${allowedTime[0].toString().padLeft(2,'0')}:${allowedTime[1].toString().padLeft(2,'0')} ~ ${allowedTime[2].toString().padLeft(2,'0')}:${allowedTime[1].toString().padLeft(2,'0')}",
                                'bold', 14, 'base60'
                            ),
                            OutlinedButton(
                              style: outlineButtonForm(12, 7, const Color(0xFFFB8665)),
                              onPressed: () async {
                                  TimeRange result = await showTimeRangePicker(
                                    labelStyle: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'NanumSquareRound',
                                      fontSize: 10,

                                    ),
                                    context: context,
                                    start: TimeOfDay(hour: allowedTime[0], minute: allowedTime[1]),
                                    end: TimeOfDay(hour: allowedTime[2], minute: allowedTime[3]),
                                    handlerColor: const Color(0xffff846d),
                                    strokeColor: const Color(0xffff846d),
                                      use24HourFormat:false
                                  );
                                  setState(() {
                                    allowedTime[0] = result.startTime.hour;
                                    allowedTime[1] = result.startTime.minute;
                                    allowedTime[2] = result.endTime.hour;
                                    allowedTime[3] = result.endTime.minute;
                                  });
                              },
                                child: label('invitation2_setT'.tr, 'bold', 12, 'primary')
                            )
                          ],
                        )
                    ),
                  ],
                )
              ),
              const SizedBox(height: 72),
              ElevatedButton(
                  style: btnStyleForm('white', 'primary', 25),
                  onPressed: () => invitation(),
                  child: label('invitation_invTitle'.tr, 'extra-bold', 16, 'white')
              ),
              const SizedBox(height: 20),
            ],
          )
        )
    );
  }

  getBabyList(){
    List<DropDownValueModel> tmp = [];
    for(int i=0; i<widget.babies.length; i++){
      tmp.add(
          DropDownValueModel(name:widget.babies[i].name, value: i)
      );
    }
    return tmp;
  }
  // 접근 요일 선택을 위한 폼 작성
  getWeek(){
    List<FilterChip> chips = [];
    for(int i=0; i<7; i++){
      chips.add(
          FilterChip(
              label: label(week[i], 'bold', 12, (allowedWeek[i] == 1? 'white' : 'base60')),
              shape: const CircleBorder(
                  side: BorderSide(color: Color(0x4D512F22))
              ),
              padding: const EdgeInsets.all(8),
              selectedColor: const Color(0xFFFB8665),
              backgroundColor: Colors.white,
              selected: allowedWeek[i] == 1,
              showCheckmark: false,
              onSelected: (bool notSelection){
                setState(() {
                  if(notSelection){
                    if(allowedWeek[i] == 0){
                      allowedWeek[i] = 1;
                    }
                  }
                  else{
                    allowedWeek[i] = 0;
                  }
                });
              }
          )
      );
    }
    return chips.toList();
  }

  /// METHOD - 중복 체크 메소드
  void duplicateCheck(String email) async {
    // [0] validate
    if(!validateEmail(email)){
      Get.snackbar('warning'.tr, 'keep_id'.tr, snackPosition: SnackPosition.BOTTOM);
      return;
    }
    // duplicate ID baby API
    String responseData = await emailOverlapService(email);
    if(responseData == "True"){
      Get.snackbar('warning'.tr, 'not_exist_ids'.tr, snackPosition: SnackPosition.BOTTOM);
    }else{
      setState(() {
        selectedTargetID = true;
      });
      Get.snackbar('search_completed'.tr, 'find_exist'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }
  /// METHOD - new 추가 양육자 초대 메소드
  void invitation() async{
    // [0] validate
    if(!selectedTargetID || targetIdClr.text.trim() == widget.myEmail){
      Get.snackbar('warning'.tr, 'select_id_invi'.tr);
      return;
    }
    if(selectedBabyIdx < 0 || selectedBabyIdx >= widget.babies.length){
      Get.snackbar('warning'.tr, 'select_baby_invi'.tr);
      return;
    }
    if(selectedRel < 0 || selectedRel > 3){
      Get.snackbar('warning'.tr, 'vaild_select_baby'.tr);
      return;
    }
    int allowedW = int.parse(allowedWeek.join(), radix: 2);
    if(!validateWeek(allowedW)){
      Get.snackbar('warning'.tr, 'vaild_week'.tr);
      return;
    }
    if(!validateTimeRange(allowedTime)){
      Get.snackbar('warning'.tr, 'vaild_time_range'.tr);
      return;
    }

    Baby invitBaby = widget.babies[selectedBabyIdx];
    Baby_relation relation = (selectedRel == 0)
          ? Baby_relation(invitBaby.relationInfo.BabyId, 0, 127, "00:00", "23:59", false)
          : Baby_relation(invitBaby.relationInfo.BabyId, selectedRel, allowedW, '${allowedTime[0].toString().padLeft(2,'0')}:${allowedTime[1].toString().padLeft(2,'0')}', '${allowedTime[2].toString().padLeft(2,'0')}:${allowedTime[3].toString().padLeft(2,'0')}', false);

    var relationJson = relation.toJson();
    relationJson['email'] = targetIdClr.text.trim();
    var result = await invitationService(relationJson);
    if(result['result'] == 'success'){
      Get.back();
    }
  }
}