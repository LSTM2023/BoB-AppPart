import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database.dart';
import '../database/diaryDB.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart'
    hide StringTranslateExtension;

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

class MainDiary extends StatefulWidget {
  const MainDiary({super.key});

  @override
  State<MainDiary> createState() => MainDiaryState();
}

class MainDiaryState extends State<MainDiary> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text('BoB '.tr,
                    style: const TextStyle(
                        color: Color(0xFFFB8665), fontSize: 20)),
                Text('Calendar'.tr,
                    style: const TextStyle(
                        color: Color(0xFF512F22), fontSize: 20)),
              ],
            ),
          ),
        ),
        drawer: Drawer(
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Text('babyList'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
                    // Text('babyListC'.tr, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ))),
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

  diaryList() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              // 선택된 날짜의 상태를 갱신합니다.
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
                DatabaseHelper.instance.isDiary(selectedDay);
              });
            },
            selectedDayPredicate: (DateTime day) {
              // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
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
              weekendDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<Diary>(
            future: DatabaseHelper.instance.getDiary(selectedDay),
            builder: (BuildContext context, AsyncSnapshot<Diary> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return SizedBox(
                  child: FutureBuilder<bool>(
                    future: DatabaseHelper.instance.isDiary(selectedDay),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        return const SizedBox(height: 0);
                      }
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
                                    child: AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: writeDiary(selectedDay),
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
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return SizedBox(
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
                                Text(snapshot.data!.title,
                                    style: const TextStyle(
                                        color: Color(0xFF512F22),
                                        fontSize: 16)),
                                Expanded(
                                  child: Text(
                                    snapshot.data!.date,
                                    style: const TextStyle(
                                        color: Color(0x99512F22), fontSize: 14),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: snapshot.data!.image == null
                                  ? const SizedBox(
                                      height: 10,
                                      width: double.infinity,
                                    )
                                  : Image.file(
                                      File(snapshot.data!.image ?? 'default'),
                                      width: MediaQuery.of(context).size.width /
                                          2),
                            ),
                            const SizedBox(
                              height: 10,
                              width: double.infinity,
                            ),
                            Text(snapshot.data!.content,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF512F22),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: (() async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return SingleChildScrollView(
                                              child: AlertDialog(
                                                content: Form(
                                                  key: _formKey,
                                                  child: updateDiary(
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
                                    child: Text('modify'.tr,
                                        style: const TextStyle(
                                            color: Color(0xffdf8570)))),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                content: Text('q_delete'.tr),
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
                                                      child: Text('cancel'.tr,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffdf8570)))),
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
                                                        setState(() {
                                                          DatabaseHelper
                                                              .instance
                                                              .remove(
                                                                  selectedDay);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                      child: Text('delete'.tr,
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xffdf8570)))),
                                                ],
                                              ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xffdf8570),
                                          width: 0.5,
                                        )),
                                    child: Text('delete'.tr,
                                        style: const TextStyle(
                                            color: Color(0xffdf8570)))),
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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  updateDiary(DateTime selectedDay, Diary? diary) {
    String title = diary!.title;
    String content = diary.content;
    String? image = diary.image;
    String selDay = DateFormat('yyyy.MM.dd').format(selectedDay);
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
          TextFormField(
            cursorColor: Color(0xffdf8570),
            initialValue: diary.title,
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
          TextFormField(
            cursorColor: Color(0xffdf8570),
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            initialValue: diary.content,
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
              ElevatedButton(
                  onPressed: (() async {
                    final XFile? _image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = _image!.path;
                    });
                  }),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffdf8570),
                        width: 0.5,
                      )),
                  child: Text(
                      image != null ? 'change_image'.tr : 'put_image'.tr,
                      style: TextStyle(color: Color(0xffdf8570)))),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DatabaseHelper.instance.update(Diary(
                          date: selDay,
                          title: title,
                          content: content,
                          image: image));
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('modified'.tr)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffdf8570),
                        width: 0.5,
                      )),
                  child: Text('modify'.tr,
                      style: const TextStyle(color: Color(0xffdf8570)))),
            ],
          ),
        ]);
  }

  writeDiary(DateTime selectedDay) {
    String title = '';
    String content = '';
    String? image;
    String selDay = DateFormat('yyyy.MM.dd').format(selectedDay);
    final ImagePicker picker = ImagePicker();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: const Icon(Icons.clear, color: Color(0xFFFB8665)),
            onPressed: () {
              _formKey.currentState?.reset();
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: 5.0,
          ),
          TextFormField(
            cursorColor: const Color(0xFFFB8665),
            controller: _titleController,
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
              floatingLabelStyle: const TextStyle(color: Color(0xFFFB8665)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Color(0xFFFB8665))),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(
            height: 16.0,
            width: 5000,
          ),
          TextFormField(
            cursorColor: const Color(0xFFFB8665),
            maxLines: 15,
            keyboardType: TextInputType.multiline,
            controller: _contentController,
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
              floatingLabelStyle: const TextStyle(color: Color(0xFFFB8665)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5, color: Color(0xFFFB8665))),
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
              ElevatedButton(
                  onPressed: (() async {
                    final XFile? _image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = _image!.path;
                    });
                  }),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFFB8665),
                        width: 0.5,
                      )),
                  child: Text(
                      image != null ? 'change_image'.tr : 'put_image'.tr,
                      style: const TextStyle(color: Color(0xFFFB8665)))),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DatabaseHelper.instance.add(Diary(
                          date: selDay,
                          title: title,
                          content: content,
                          image: image));
                      _formKey.currentState?.reset();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('uploaded'.tr)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB8665),
                  ),
                  child: Text('upload'.tr,
                      style: const TextStyle(color: Colors.white))),
              if (image != null)
                Expanded(
                  child: Image.file(File(image!)),
                ),
            ],
          ),
        ]);
  }
}
