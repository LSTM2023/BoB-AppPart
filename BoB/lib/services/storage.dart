import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bob/models/model.dart';

FlutterSecureStorage storage = new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

writeLogin(loginInfo) async{
  // input : <Login>
  await storage.write(key: 'login', value: jsonEncode(loginInfo));
}
deleteLogin() async{
  await storage.delete(key: 'login');
}
getLoginStorage() async{
  var login = await storage.read(key: "login");
  return login;
}
editPasswordLoginStorage(String password) async{
  var login = await storage.read(key: "login");
  Login newLogin = Login.fromJson(jsonDecode(login!));
  newLogin.changePassword(password);
  await storage.write(key: 'login', value: jsonEncode(newLogin));
}
getToken() async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  return "Bearer ${jsonData["token"]}";
}
updateTokenInfo(String accessToken) async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  jsonData['token'] = accessToken;
  await storage.write(key: 'login', value: jsonEncode(jsonData));
}
getRefreshToken() async{
  var tmp = (await storage.read(key: "login"));
  Map<String,dynamic> jsonData = jsonDecode(tmp!);
  return jsonData["refreshtoken"];
}