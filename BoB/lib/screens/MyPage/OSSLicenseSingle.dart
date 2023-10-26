import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../oss_licenses.dart';
import '../../widgets/appbar.dart';
import '../../widgets/text.dart';

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;
  const MiscOssLicenseSingle({super.key, required this.package});

  String _bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppbar('license'.tr),
      body: Container(
          padding: const EdgeInsets.fromLTRB(15,20,15,20),
          child: ListView(children: <Widget>[
            Row(
              children: [
                label_notEclipsis(package.name, 'extra-bold', 18, 'primary'),
                const SizedBox(width: 5),
                label_notEclipsis(package.version, 'extra-bold', 18, 'base100'),
              ],
            ),
            const SizedBox(height: 20),
            if (package.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child:  label_notEclipsis(package.description, 'bold', 13, 'base100'),
              ),
            if (package.homepage != null)
              label_notEclipsis(package.homepage!, 'bold', 13, 'grey'),
            if (package.description.isNotEmpty || package.homepage != null) const Divider(),
            label_notEclipsis(_bodyText(), 'bold', 12, 'base100')
          ])),
    );
  }
}