import 'package:bob/oss_licenses.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bob/widgets/appbar.dart';
import '../../models/model.dart';
import '../../widgets/text.dart';
import 'OSSLicenseSingle.dart';

class OpenSourceLicenses extends StatelessWidget{
  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    print('loadLicenses');
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenses = ossLicenses.toList();
    for (var key in lm.keys) {
      licenses.add(Package(
        name: key,
        description: '',
        authors: [],
        version: '',
        license: lm[key]!.join('\n\n'),
        isMarkdown: false,
        isSdk: false,
        isDirectDependency: false,
      ));
    }
    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }
  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppbar('license'.tr),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15,20,15,20),
          child: FutureBuilder<List<Package>>(
              future: _licenses,
              initialData: const [],
              builder: (context, snapshot) {
                return ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final package = snapshot.data![index];
                      return ListTile(
                          title: label('${package.name} ${package.version}', 'bold', 14, 'base100'),
                          subtitle: package.description.isNotEmpty ? label(package.description, 'normal', 12, 'base60') : null,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: (){
                            Get.to(()=>MiscOssLicenseSingle(package: package));
                          }
                      );
                    },
                    separatorBuilder: (context, index) => const Divider());
              })
        )
    );
  }
}