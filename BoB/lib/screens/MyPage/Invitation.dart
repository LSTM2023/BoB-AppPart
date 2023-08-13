import 'package:bob/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:bob/models/model.dart';
import 'package:bob/widgets/text.dart';
import 'package:get/get.dart';
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
      appBar: homeAppbar('양육자/베이비시터 초대'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFB8665),
        onPressed: (){
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
              ),
              backgroundColor: const Color(0xffF9F8F8),
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return InvitationBottomSheet();
              }
          );
        },
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
              child: text('미수락 초대', 'bold', 14, const Color(0xff512F22))
            ),
            Expanded(
                child: ListView.builder(
                  scrollDirection : Axis.vertical,
                  itemCount: widget.disactivebabies.length,
                  itemBuilder: (BuildContext context, int index){
                    return drawBaby(widget.disactivebabies[index]);
                  },
                )
            )

          ],
        ),
      ),
    );
  }
  Widget drawBaby(Baby baby){
    Color col;
    if(baby.relationInfo.relation == 0){
      col = const Color(0xffFF766A);
    }
    else if(baby.relationInfo.relation == 1){
      col = Colors.blueAccent;
    }
    else{
      col = Colors.grey;
    }
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          left: BorderSide(
              color: col,
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
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextBase(baby.name, 'extra-bold', 12),
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
              onPressed: (){
              },
              child: text('수락', 'bold', 10, const Color(0xFFFB8665))
          )
        ],
      ),
    );
  }
}