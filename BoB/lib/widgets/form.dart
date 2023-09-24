import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

// color
Map<String, Color> str2color = {
  'white': const Color(0xffffffff),
  'primary' : const Color(0xffFB8665),
  'base60' : const Color(0x99512F22),
  'base63' : const Color(0xa1512f22),
  'base100' : const Color(0xff512F22),
  'rel_parent' : const Color(0xffFF766A),
  'grey': const Color(0xffC1C1C1)
};

InputDecoration formDecoration(String title){
  return InputDecoration(
    labelStyle: const TextStyle(color: Color(0x99512f22), fontSize: 14),
    hintStyle: const TextStyle(color: Color(0x99512f22), fontSize: 14),
    hintText: title,
    contentPadding: EdgeInsets.fromLTRB(10, 16.5, 9, 17.5),
    enabled: true,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xfffb8665),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(width: 1.5, color: Color(0x4D512F22))
    ),
    //border: InputBorder.none
  );
}

Text makeText(String str, Color clr, double size){
  return Text(
      str,
      style: TextStyle(color: clr, fontSize: size)
  );
}
/*      */
Map<String, String> title2hint = {
  'id':'아이디를 입력해주세요',
  'pw':'비밀번호는 8~16자를 입력해주세요.',
  'pw_check':'비밀번호 재입력.',
  'nickname':'닉네임을 입력해주세요',
  'phone':'휴대폰 번호를 입력해주세요',
  'qa_answer':'답변',
  'babyName' : '아기의 이름 또는 별명을 입력해주세요.',
  'babyBirth' : '아기의 생일을 입력해 주세요.'
};
SizedBox makeTextFormField(String title, TextEditingController controller, TextInputType kType){
  return SizedBox(
    height: 50,
    child: TextFormField(
      inputFormatters : (title == 'phone')?[MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')]:[],
      controller: controller,
      keyboardType: kType,
      decoration: formDecoration(title2hint[title]!),
    ),
  );
}
SizedBox makePWFormField(String title, TextEditingController controller, bool _visible){
  return SizedBox(
    height: 50,
    child: TextFormField(
      obscureText: _visible,
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      decoration: formDecoration(title2hint[title]!),
    ),
  );
}
// Style Form
btnStyleForm(String foreClr, String backClr){
  return ElevatedButton.styleFrom(
      elevation: 0.2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      minimumSize: const Size.fromHeight(55),
      foregroundColor: str2color[foreClr],
      backgroundColor: str2color[backClr]
  );
}

Padding divider(){
  return const Padding(
      padding: EdgeInsets.all(11.5),
      child: Divider(
        thickness: 1,
        color: Color(0xffC4C4C4),
      )
  );
}
