import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage.dart';
import '../../services/backend.dart';
import '../../widgets/text.dart';
import '../Login/initPage.dart';

class WithdrawBottomSheet extends StatefulWidget{
  const WithdrawBottomSheet({super.key});
  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheet();
}
class _WithdrawBottomSheet extends State<WithdrawBottomSheet> {
  bool _isCheked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: text('서비스 탈퇴', 'bold', 20, Color(0xffFB8665)),
          ),
          const SizedBox(height: 52),
          textBase('회원탈퇴 안내', 'bold', 14),
          const SizedBox(height: 10),
          text('지금까지 BoB 서비스를 이용해주셔서 감사합니다.\n 회원을 탈퇴하려면 BoB 서비스 내 나의 계정 정보 및 근무기록 내역이 삭제되고 복구 할 수 없습니다.', 'bold', 14, Color(0x99512F22)),
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                activeColor: const Color(0xffFB8665),
                value: _isCheked,
                onChanged: (val){
                  setState(() {_isCheked = val!;});
                },
              ),
              text('위 내용을 숙지하였으며, 동의합니다.', 'bold', 14, Color(0x99512F22)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              style:ElevatedButton.styleFrom(
                  elevation: 0.2,
                  foregroundColor: Colors.white,
                  backgroundColor: (_isCheked?const Color(0xfffb8665):Color(0xffC1C1C1)),
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
              ),
              onPressed: () => serviceWithdraw(),
              child: Text('탈퇴하기')
          )
        ],
      ),
    );
  }
  serviceWithdraw() async{
    // 1. 삭제 - dio 사용
    if(await deleteUserService() == 204){
      await storage.delete(key: 'login');    // 2. 로컬 DB & secureStorage 삭제
      Get.offAll(LoginInit());            // 2. initPage로 이동
    }
  }
}