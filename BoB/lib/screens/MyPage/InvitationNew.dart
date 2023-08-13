import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import 'package:get/get.dart';
import '../BaseWidget.dart';
import 'package:bob/widgets/text.dart';
import 'package:bob/widgets/form.dart';

class InvitationBottomSheet extends StatefulWidget{

  @override
  State<InvitationBottomSheet> createState() => _InvitationBottomSheet();
}
class _InvitationBottomSheet extends State<InvitationBottomSheet> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  // 선택 창
  bool _getAdditionalInfo = false;
  List<String> selectedWeek = ['0','0','0','0','0','0','0'];   // 요일 택
  late TextEditingController bNameClr;
  late TextEditingController bBirthClr;
  late String startTime;
  late String endTime;

  @override
  void initState() {
    bNameClr = TextEditingController();
    bBirthClr = TextEditingController();
    startTime = "00:00";
    endTime = "23:59";
    super.initState();
  }
  List<bool> birthSelected = [true, false];
  List<bool> relationSelected = [true, false, false];

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
              TextBase('초대할 ID', 'bold', 14),
              const SizedBox(height: 10),
              makeTextFormField('id', bNameClr, TextInputType.text),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 143,
                    child: TextBase('아기 선택', 'bold', 14),
                  ),
                  TextBase('관계', 'bold', 14),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                      width: 120,
                      height: 40,
                      child: DropDownTextField(
                        textFieldDecoration: formDecoration(''),
                        //controller: clr,
                        clearOption: false,
                        validator: (value) {
                          if (value == null) {
                            return "Required field";
                          } else {
                            return null;
                          }
                        },
                        dropDownList: const [
                          DropDownValueModel(name: '다른 이메일 주소는?', value: 0),
                          DropDownValueModel(name: '나의 보물 1호는?', value: 1),
                          DropDownValueModel(name: '나의 출신 초등학교는?', value: 2),
                          DropDownValueModel(name: '나의 이상형은?', value: 3),
                          DropDownValueModel(name: '어머니 성함은?', value: 4),
                          DropDownValueModel(name: '아버지 성함은?', value: 6),
                        ],
                        dropDownItemCount: 6,
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
                        relationSelected = [idx == 0, idx == 1, idx == 2];
                        if(idx!=0){
                          _getAdditionalInfo = true;
                        }else{
                          _getAdditionalInfo = false;
                        }
                      });
                    },
                    isSelected: relationSelected,
                    children: const [
                      SizedBox(
                          width: 70,
                          child: Center(
                              child: Text('부모', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                          )
                      ),
                      SizedBox(
                          width: 70,
                          child: Center(
                              child: Text('가족', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                          )
                      ),
                      SizedBox(
                          width: 90,
                          child: Center(
                              child: Text('베이비시터', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareRound'))
                          )
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 18),
              Offstage(
                offstage: !_getAdditionalInfo,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBase('접근 요일 선택', 'bold', 14),
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: getWeek()
                    ),
                    const SizedBox(height: 18),
                    TextBase('접근 시간 선택', 'bold', 14),
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
                                  /*TimeRange result = await showTimeRangePicker(
                                    context: context,
                                    handlerColor: const Color(0xffff846d),
                                    strokeColor: const Color(0xffff846d),

                                  );
                                  setState(() {
                                    startTime = "${result.startTime.hour}:${result.startTime.minute}";
                                    endTime = "${result.endTime.hour}:${result.endTime.minute}";
                                  });*/
                                },
                                child: text('시간 선택', 'bold', 14, const Color(0xFFFB8665))
                            )
                          ],
                        )
                    ),
                  ],
                )
              ),
              const SizedBox(height: 72),
              ElevatedButton(
                  onPressed: (){},
                  style:ElevatedButton.styleFrom(
                      elevation: 0.2,
                      padding: const EdgeInsets.fromLTRB(0,17,0,11),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xfffb8665),
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                  ),
                  child: text('등록', 'extra-bold', 20, Colors.white)
              ),
              const SizedBox(height: 20),
            ],
          )
        )
    );
  }
  drawList(){
    //for(int i=0; i<ac)
  }
  getWeek(){
    List<FilterChip> wget = [];
    for(int i=0; i<7; i++){
      wget.add(
          FilterChip(
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