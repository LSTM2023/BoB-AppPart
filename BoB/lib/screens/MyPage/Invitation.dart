import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/widgets/text.dart';
import 'package:get/get.dart';
import '../../services/backend.dart';
import '../../widgets/form.dart';
import './InvitationNew.dart';

class Invitation extends StatefulWidget{
  final List<Baby> activebabies;
  final List<Baby> disactivebabies;
  const Invitation(this.activebabies, this.disactivebabies, {super.key});
  @override
  State<Invitation> createState() => _Invitation();
}

class _Invitation extends State<Invitation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar('main4_InviteBabysitter'.tr),
      floatingActionButton: FloatingActionButton(
        heroTag: 'invitation',
        backgroundColor: const Color(0xFFFB8665),
        onPressed: () => openInvitationForm(),
        child: const Icon(Icons.add)
      ),
      body: Container(
        padding: const EdgeInsets.only(top:42),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 24),
              child: label('invitation_notList'.tr, 'bold', 14, 'base100')
            ),
            Expanded(
                child: ListView.builder(
                  scrollDirection : Axis.vertical,
                  itemCount: widget.disactivebabies.length,
                  itemBuilder: (BuildContext context, int index){
                    Baby baby = widget.disactivebabies[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            left: BorderSide(
                                color: colorList[baby.relationInfo.relation],
                                width: 5.0
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 1,
                            )
                          ],
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            label(baby.name, 'extra-bold', 12, 'base100'),
                            OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)
                                      )
                                  ),
                                  side: const BorderSide(width: 1.5, color: Color(0xFFFB8665)),
                                ),
                                onPressed: () => invitationAcceptance(baby.relationInfo.BabyId),
                                child: label('accept'.tr, 'bold', 10, 'primary')
                            )
                          ]
                      )
                    );
                    //return drawBaby(widget.disactivebabies[index]);
                  },
                )
            )
          ],
        ),
      ),
    );
  }

  /// 추가 양육자 초대를 위한 bottom sheet 폼 open
  openInvitationForm(){
    showModalBottomSheet(
        shape: modalBottomSheetFormRound(),
        backgroundColor: const Color(0xffF9F8F8),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return InvitationBottomSheet(widget.activebabies);
        }
    );
  }
  /// 양육자 초대 수락
  invitationAcceptance(int babyId){
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: label('invitation_accept'.tr,'extra-bold', 16, 'primary'),
        content: label('invitation_acceptC'.tr, 'bold', 12, 'base'),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0xFFFB8665),
                  foregroundColor: Colors.white
              ),
              onPressed: () async{
                // 1. 초대 수락하는 API 보내기
                var result = await acceptInvitationService(babyId);
                Navigator.pop(context);
                Get.back();
              },
              child: label('accept'.tr,'extra-bold', 14, 'white')
          )
        ],
      ),
    );
  }
}
