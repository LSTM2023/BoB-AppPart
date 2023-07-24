import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';

class AddBaby extends StatefulWidget {
  const AddBaby({super.key});
  @override
  State<AddBaby> createState() => _AddBaby();
}
class _AddBaby extends State<AddBaby>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppbar('add baby', false),
      body: Text(''),
    );
  }
}