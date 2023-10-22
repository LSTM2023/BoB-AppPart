import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage.dart';
import '../../services/backend.dart';
import '../../widgets/form.dart';
import '../../widgets/text.dart';
import '../Login/initPage.dart';

class WithdrawBottomSheet extends StatefulWidget{
  const WithdrawBottomSheet({super.key});
  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheet();
}

class _WithdrawBottomSheet extends State<WithdrawBottomSheet> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: bottomSheetPadding(context, 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Center(
                child: label('main4_withdrawal'.tr, 'bold', 20, 'base100')
            ),
            const SizedBox(height: 42),
            label('withdraw_title'.tr, 'bold', 16, 'base100'),
            const SizedBox(height: 10),
            label('withdraw_content'.tr, 'bold', 14, 'base60'),
            const SizedBox(height: 32),
            Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeColor: const Color(0xffFB8665),
                  value: isChecked,
                  onChanged: (val){
                    setState(() {isChecked = val!;});
                  },
                ),
                label('withdraw_checkPhrase'.tr, 'bold', 14, 'base60')
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style: btnStyleForm('white', (isChecked? 'primary': 'grey'), 25),
                onPressed: () => serviceWithdraw(),
                child: label('withdraw_btn'.tr, 'extra-bold,', 16, 'white')
            ),
            const SizedBox(height: 15),
          ],
        ),
      )
    );
  }
  /// method for delete user
  serviceWithdraw() async{
    // call DeleteUser API & delete local DB
    if(await deleteUserService() == 204){
      await storage.delete(key: 'login');
      Get.offAll(LoginInit());
    }
  }
}