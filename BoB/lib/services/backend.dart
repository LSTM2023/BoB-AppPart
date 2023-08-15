import 'package:dio/dio.dart';
import 'package:bob/services/storage.dart';
const String PATH = 'http://54.180.92.227:8000';
final dio = Dio();    // 서버와 통신을 하기 위해 필요한 패키지

loginService(id, pass) async{
  try{
    Response response = await dio.post('$PATH/api/user/login/', data: {'email' : id, 'password': pass});
    return response.data;
  }on DioException{
    return null;
  }
}

// 회원가입 서비스
registerService(email, pass, name, phone, qaType, qaAnswer) async{
  print({"email": email, "password1": pass, "password2": pass, "name": name, "phone": phone, "qaType" : qaType, "qaAnswer": qaAnswer});
  Response response = await dio.post('$PATH/api/user/registration/',
      data: {"email": email, "password1": pass, "password2": pass, "name": name, "phone": phone, "qaType" : qaType, "qaAnswer": qaAnswer}
  );
  return response.statusCode;
}
// 추가 양육자 초대
invitationService(data) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/connect/',data: data);
    return response.data;
  }on DioException{
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/connect/',data: data);
    return response.data;
  }
}
// 초대 수락 API
acceptInvitationService(int babyId) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/activate/',data: {"babyid": babyId});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/activate/',data: {"babyid": babyId});
    return response.data;
  }
}
getMyBabies() async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/lists/');
    if(response.statusCode == 200){
      return response.data as List<dynamic>;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/lists/');
    if(response.statusCode == 200){
      return response.data as List<dynamic>;
    }
  }
}
getBaby(int id) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/${id}/get/');
    if(response.statusCode == 200){
      return response.data;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/${id}/get/');
    if(response.statusCode == 200){
      return response.data;
    }
  }

}
setBabyService(data) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/baby/set/', data: data);
    if(response.statusCode == 200){
      return response.data;
    }
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/baby/set/', data: data);
    return response.data;
  }
}
// 토큰 갱신
refresh() async{
  var refreshDio = Dio();   // 토큰 갱신 요청을 담당할 dio 객체
  refreshDio.options.headers['Authorization'] = await getToken();
  String refresh = await getRefreshToken();
  final refreshResponse = await refreshDio.post('${PATH}/api/user/token/refresh/', data: {"refresh":refresh});
  // 갱신된 AccessToken과 RefreshToken 파싱
  final newAccessToken = refreshResponse.data["access"];
  // login storage - update
  await updateTokenInfo(newAccessToken);
  return "Bearer ${newAccessToken}";
}
// 중복 검사 서비스
emailOverlapService(id) async{
  try{
    Response response = await dio.post('${PATH}/api/user/exist/', data: {'email' : id});
    return response.data;
  }catch(e){
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/user/exist/', data: {'email' : id});
    return response.data;
  }
}
/*    HOME PAGE   */
//// 1. home page
lifesetService(int babyId, int mode, String content) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/life/set/',data: {"babyid": babyId, "mode" : mode, "content":content});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/life/set/',data: {"babyid": babyId});
    return response.data;
  }
}
// 성장기록
growthService(int babyId, double height, double weight, String date) async{
  try{
    dio.options.headers['Authorization'] = await getToken();
    Response response = await dio.post('${PATH}/api/growth/set/',data: {"baby": babyId, "height" : height, "weight":weight, "date":date});
    return response.data;
  }on DioError catch (e) {
    dio.options.headers['Authorization'] = await refresh();
    Response response = await dio.post('${PATH}/api/growth/set/',data: {"baby": babyId, "height" : height, "weight":weight, "date":date});
    return response.data;
  }
}
