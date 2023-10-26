import 'package:bob/oss_licenses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bob/widgets/appbar.dart';
import '../../widgets/text.dart';
import 'OSSLicenseSingle.dart';

class OpenSourceLicenses extends StatelessWidget{

  const OpenSourceLicenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppbar('license'.tr),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10,20,10,20),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              SingleChildScrollView(
                child:ExpansionTile(    // 부모
                    initiallyExpanded: true,
                    title: label('Backend', 'extra-bold', 16, 'base100'),
                    children: loadLicenses(0)
                ),
              ),
              SingleChildScrollView(
                child:ExpansionTile(    // 부모
                    initiallyExpanded: true,
                    title: label('AI', 'extra-bold', 16, 'base100'),
                    children: loadLicenses(1)
                ),
              ),
              SingleChildScrollView(
                child:ExpansionTile(    // 부모
                    initiallyExpanded: true,
                    title: label('App', 'extra-bold', 16, 'base100'),
                    children: loadLicenses(2)
                ),
              ),
              const SizedBox(height: 30),
            ],
          )
        )
    );
  }

  /// method for loading open sources
  loadLicenses(int mode) {
    var licenses = ossAppLicenses.toList();
    if(mode == 0){
      licenses = ossBackendLicenses.toList();
    }
    else if(mode == 1) {
      licenses = ossAiLicenses.toList();
    }
    licenses =  licenses..sort((a, b) => a.name.compareTo(b.name));

    List<ListTile> licenseWidgets = [];
    for(int i=0; i<licenses.length; i++){
      final package = licenses[i];
      licenseWidgets.add(
        ListTile(
          title: label('${package.name} ${package.version}', 'bold', 14, 'base100'),
          subtitle: package.description.isNotEmpty ? label(package.description, 'normal', 12, 'base60') : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: (){
            Get.to(()=>MiscOssLicenseSingle(package: package));
          },
          contentPadding: const EdgeInsets.fromLTRB(10,5,10,15),
        )
      );
    }
    return licenseWidgets;
  }
}