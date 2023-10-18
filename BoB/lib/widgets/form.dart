import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:badges/badges.dart' as badges;

// color
List<Color> colorList = [const Color(0xffFB8665), const Color(0xff22513E), const Color(0xff222551)];

Map<String, Color> str2color = {
  'black': const Color(0xff000000),
  'white': const Color(0xffffffff),
  'primary' : const Color(0xffFB8665),
  'primary80' : const Color(0xccFB8665),
  'base60' : const Color(0x99512F22),
  'base63' : const Color(0xa1512f22),
  'base80' : const Color(0xcc512f22),
  'base100' : const Color(0xff512F22),
  'Grey' : const Color(0xff9E9E9E),
  'grey': const Color(0xffC1C1C1),
  'rel0': const Color(0xffFB8665),
  'rel1': const Color(0xff22513E),
  'rel2': const Color(0xff222551),
  'feeding' : const Color(0xffff7a7a),
  'feedingBottle' : const Color(0xffffb1a2),
  'babyFood' : const Color(0xfffF9B58),
  'diaper' : const Color(0xff50BC58),
  'sleep' : const Color(0xff5086BC),
  'calendar' : const Color(0xffdf8570),
};
//

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

/*      */
Map<String, String> title2hint = {
  'id':'아이디 또는 이메일을 입력해주세요',
  'pw':'비밀번호는 8~16자를 입력해주세요.',
  'pw_check':'비밀번호 재입력.',
  'nickname':'닉네임을 입력해주세요',
  'phone':'휴대폰 번호를 입력해주세요',
  'qa_answer':'답변',
  'babyName' : '아기의 이름 또는 별명을 입력해주세요.',
  'babyBirth' : '아기의 생일을 입력해 주세요.'
};

Map<String, TextInputType> title2keyType = {
  'id': TextInputType.emailAddress,
  'pw': TextInputType.visiblePassword,
  'pw_check': TextInputType.visiblePassword,
  'nickname': TextInputType.name,
  'phone': TextInputType.phone,
  'qa_answer': TextInputType.text,
  'babyName' : TextInputType.text,
  'babyBirth' : TextInputType.text
};

SizedBox makeTextFormField(String title, TextEditingController controller){
  return SizedBox(
    height: 50,
    child: TextFormField(
      inputFormatters : (title == 'phone')?[MultiMaskedTextInputFormatter(masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')]:[],
      controller: controller,
      keyboardType: title2keyType[title],
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
// 1. button style 1
btnStyleForm(String foreClr, String backClr, double radius){
  return ElevatedButton.styleFrom(
      elevation: 0.2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)
      ),
      minimumSize: const Size.fromHeight(55),
      foregroundColor: str2color[foreClr],
      backgroundColor: str2color[backClr]
  );
}
// bottom style 1 - round
containerStyleFormRound(){
  return BoxDecoration(
      color: const Color(0xCCFFFFFF),
      shape: BoxShape.circle,
      border: Border.all(
        color: const Color(0xffC1C1C1),
        width: 0.5,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x29000000),
          offset: Offset(0, 3),
          blurRadius: 6,
        )
      ]
  );
}
modalBottomSheetFormRound(){
  return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
      )
  );
}


