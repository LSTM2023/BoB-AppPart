import 'package:bob/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:io';
import 'package:bob/models/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart'
    hide StringTranslateExtension;
import '../services/backend.dart';

/// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

class MainDiary extends StatefulWidget {
  final User userinfo;
  final getMyBabyFuction;
  const MainDiary(this.userinfo, {super.key, this.getMyBabyFuction});

  @override
  State<MainDiary> createState() => MainDiaryState();
}

class MainDiaryState extends State<MainDiary> {
  final _formKey = GlobalKey<FormState>();
  late Baby baby;
  @override
  void initState() {
    super.initState();
    baby = widget.getMyBabyFuction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Appbar
        appBar: AppBar(
          backgroundColor: const Color(0xD9FFE1C7),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Color(0xFFFFCCBF), Color(0xD9FFE1C7)],
                  ))),
          elevation: 4.0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.black),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
          title: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                label('BoB'.tr, 'bold', 20, 'primary'),
                label('Calendar'.tr, 'bold', 20, 'base100'),
              ],
            ),
          ),
        ),
        /// 다이어리 주기능 출력
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              diaryList(),
            ],
          ),
        ));
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  /// 캘린더 및 다이어리 출력
  diaryList() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          /// 캘린더 파트
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              /// 선택된 날짜 상태 갱신
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (DateTime day) {
              return isSameDay(selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              this.focusedDay = focusedDay;
            },
            headerStyle: const HeaderStyle(
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonVisible: false,
              titleCentered: false,
              headerMargin: EdgeInsets.fromLTRB(15, 8, 15, 10),
              titleTextStyle: TextStyle(
                fontSize: 18,
                color: Color(0xFFFB8665),
              ),
            ),
            calendarStyle: const CalendarStyle(
              cellMargin: EdgeInsets.all(9),
              todayDecoration: BoxDecoration(
                color: Color(0xffffeeec),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFFFB8665),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          /// 선택된 날짜 일기 리스팅
          FutureBuilder<Diary>(
            future: listDiary(DateFormat('yyyy-MM-dd').format(selectedDay), baby.relationInfo.BabyId),
            builder: (BuildContext context, AsyncSnapshot<Diary> snapshot) {
              /// 선택된 날짜에 일기가 없으면 작성 버튼
              if (!snapshot.hasData || snapshot.data == null) {
                return SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width - 32,
                  child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Color(0xFFF9F8F8)),
                        elevation: MaterialStatePropertyAll(6),
                        shadowColor:
                        MaterialStatePropertyAll(Color(0x1B512F22)),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                /// 작성 페이지로 이동
                                child: AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                    child: writeDiary(selectedDay, null),
                                  ),
                                  backgroundColor: const Color(0xFFF9F8F8),
                                ),
                              );
                            });
                      },
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF512F22),
                        size: 32,
                      )
                  ),
                );
              }
              return SizedBox( /// 다이어리 내용 출력
                width: MediaQuery.of(context).size.width - 32,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(2, 14, 2, 14)),
                    backgroundColor:
                    const MaterialStatePropertyAll(Color(0xFFF9F8F8)),
                    elevation: const MaterialStatePropertyAll(6),
                    shadowColor:
                    const MaterialStatePropertyAll(Color(0x1B512F22)),
                  ),
                  onPressed: () {},
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                      scrollDirection: Axis.vertical,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                label(snapshot.data!.title, 'bold', 16, 'base100'),
                                Expanded(
                                  child: Text(snapshot.data!.writtenTime, textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0x99512F22),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'NanumSquareRound',
                                    ),),
                                ),
                              ],
                            ),
                            Center(
                              child: snapshot.data!.imagePath == null
                                  ? const SizedBox(
                                height: 10,
                                width: double.infinity,
                              )
                                  : Image.file(
                                  File(snapshot.data!.imagePath ?? 'default'),
                                  width: MediaQuery.of(context).size.width /
                                      2),
                            ),
                            const SizedBox(
                              height: 10,
                              width: double.infinity,
                            ),
                            label(snapshot.data!.content, 'bold', 14, 'base100'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                /// 다이어리 수정 버튼
                                ElevatedButton(
                                    onPressed: (() async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                              /// 수정 페이지로 이동
                                              child: AlertDialog(
                                                content: Form(
                                                  key: _formKey,
                                                  child: writeDiary(
                                                      selectedDay,
                                                      snapshot.data),
                                                ),
                                                insetPadding:
                                                const EdgeInsets.fromLTRB(
                                                    15, 30, 15, 30),
                                                backgroundColor:
                                                const Color(0xfffffdfd),
                                              ),
                                            );
                                          });
                                    }),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xffdf8570),
                                          width: 0.5,
                                        )),
                                    child: label('modify'.tr, 'bold', 14, 'calendar')
                                ),
                                const SizedBox(width: 10),
                                /// 다이어리 삭제 버튼
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              /// 다이어리 삭제 전 확인 다이얼로그
                                              AlertDialog(
                                                content: label('q_delete'.tr, 'bold', 14, 'base100'),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          backgroundColor:
                                                          Colors.white,
                                                          side:
                                                          const BorderSide(
                                                            color: Color(
                                                                0xffdf8570),
                                                            width: 0.5,
                                                          )),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: label('cancel'.tr, 'bold', 14, 'calendar')
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                          backgroundColor:
                                                          Colors.white,
                                                          side:
                                                          const BorderSide(
                                                            color: Color(
                                                                0xffdf8570),
                                                            width: 0.5,
                                                          )),
                                                      onPressed: (() async {
                                                        /// 다이얼로그 확인 후 삭제
                                                        setState(() {
                                                          deleteDiary(baby.relationInfo.BabyId, DateFormat('yyyy-MM-dd').format(selectedDay));
                                                        });
                                                        Navigator.of(context).pop();
                                                      }),
                                                      child: label('delete'.tr, 'bold', 14, 'calendar')
                                                  ),
                                                ],
                                              ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xffdf8570),
                                          width: 0.5,
                                        )),
                                    child: label('delete'.tr, 'bold', 14, 'calendar')
                                ),
                              ],
                            ),
                          ])),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 다이어리 작성 및 수정
  writeDiary(DateTime selectedDay, Diary? diary) {
    String title = diary?.title ?? '';
    String content = diary?.content ?? '';
    String? image = diary?.imagePath;
    String selDay = DateFormat('yyyy-MM-dd').format(selectedDay);
    final ImagePicker picker = ImagePicker();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: const Icon(Icons.clear, color: Color(0xffdf8570)),
            onPressed: () {
              _formKey.currentState?.reset();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: 5.0,
          ),
          /// 다이어리 - 제목 입력창
          TextFormField(
            cursorColor: const Color(0xffdf8570),
            initialValue: diary?.title,
            onSaved: (value) {
              setState(() {
                title = value as String;
              });
            },
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'enter_title'.tr;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'title'.tr,
              floatingLabelStyle: const TextStyle(color: Color(0xffdf8570)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Color(0xffdf8570))),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
            width: 5000,
          ),
          /// 다이어리 - 내용 입력창
          TextFormField(
            cursorColor: const Color(0xffdf8570),
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            initialValue: diary?.content,
            onSaved: (value) {
              setState(() {
                content = value as String;
              });
            },
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'enter_content'.tr;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'content'.tr,
              floatingLabelStyle: const TextStyle(color: Color(0xffdf8570)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Color(0xffdf8570))),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// 다이어리 - 사진 첨부 기능
              ElevatedButton(
                  onPressed: (() async {
                    final XFile? image0 =
                    await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = image0!.path;
                    });
                  }),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffdf8570),
                        width: 0.5,
                      )),
                  child: label(image != null ? 'change_image'.tr : 'put_image'.tr, 'bold', 14, 'calendar')
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      /// 다이어리 수정
                      if (diary?.title != null) {
                        updateDiary({'babyid': baby.relationInfo.BabyId, 'date': selDay, 'title': title, 'content': content, 'photo': image});
                      }
                      /// 다이어리 작성
                      else {
                        writesDiary({'babyid': baby.relationInfo.BabyId, 'date': selDay, 'title': title, 'content': content, 'photo': image});
                      }
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: label('uploaded'.tr, 'bold', 14, 'white')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffdf8570),
                        width: 0.5,
                      )),
                  child: label(diary?.title != null ? 'modify'.tr : 'upload'.tr, 'bold', 14, 'calendar')
              ),
            ],
          ),
        ]);
  }
}