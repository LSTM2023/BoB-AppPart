import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:bob/models/model.dart';
import 'package:bob/services/storage.dart';
import '../fcmSetting.dart';
import 'backend.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

googleLogin() async{
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  return googleUser;
}
naverLogin() async{
  final NaverLoginResult result = await FlutterNaverLogin.logIn();

  return result;
}

getMyBabies() async{
  List<Baby> myBabies = [];
  // 아기 등록
  List<dynamic> babyList = await getMyBabiesService();
  for(int i=0; i<babyList.length; i++){
    var baby = await getBaby(babyList[i]['baby']);
    Baby_relation relation = Baby_relation.fromJson(babyList[i]);
    baby['relationInfo'] = relation.toJson();
    myBabies.add(Baby.fromJson(baby));
  }
  return myBabies;
}

// new login -> user
login(String email, String pw) async{
  // call login API
  var loginData = await loginService(email, pw);
  if(loginData != null){
    String token = loginData['access_token'];
    Map<dynamic, dynamic> payload = Jwt.parseJwt(token);
    loginData['password1'] = pw;
    print(loginData);
    User userInfo = User.fromJson(loginData);
    Login newLoginInfo = Login(token, loginData['refresh_token'], payload['user_id'], loginData['email'], pw);
    await writeLogin(newLoginInfo);

    // 2. fc token 설정
    String? fbToken = await fcmSetting();
    await updateFbToken(email, pw, fbToken!);

    // 3. baby list 가져오기
    List<Baby> myBabies = await getMyBabies();

    return {'user' : userInfo, 'babies' : myBabies};
  }{
    return null;
  }
}