import 'dart:convert';

class User {
  late final String email;
  late String password1;
  late String name;
  late String phone;
  late int qaType;
  late String qaAnswer;

  User(this.email, this.password1, this.name, this.phone, this.qaType, this.qaAnswer);

  User.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'], password1 = json['password1'], name = json['name'], phone = json['phone'], qaType = (json['qaType']), qaAnswer = (json['qaAnswer']);

  Map<String, dynamic> toJson() => {
    "email": email,
    "password1": password1,
    "name": name,
    "phone": phone,
    "qaType" : qaType,
    "qaAnswer" : qaAnswer
  };
  modifyUserInfo(_pass, _name, _phone){
    this.password1 = _pass;
    this.name = _name;
    this.phone = _phone;
  }
}

class Login {
  final String token;
  final String refreshtoken;
  final int loginID;
  final String userEmail;
  String userPassword;
  Login(this.token, this.refreshtoken, this.loginID, this.userEmail, this.userPassword);
  changePassword(String newPass){
    this.userPassword = newPass;
  }
  Login.fromJson(Map<dynamic, dynamic> json)
      : token = json['token'],
        refreshtoken = json['refreshtoken'],
        loginID = json['loginID'],
        userEmail = json['userEmail'],
        userPassword = json['userPassword'];

  Map<String, dynamic> toJson() => {
    'token': token,
    'refreshtoken': refreshtoken,
    'loginID': loginID,
    'userEmail': userEmail,
    'userPassword': userPassword,
  };
}

class Baby_relation{
  final int BabyId;
  final int relation; // 0:부모, 1: 가족 , 2 : 베이비시터
  final int Access_week;
  final String Access_startTime;
  final String Access_endTime;
  final bool active;

  String getRelationString(){
    if(relation==0) return '부모';
    if(relation==1) return '가족';
    else return '베이비시터';
  }
  Baby_relation(this.BabyId, this.relation, this.Access_week, this.Access_startTime, this.Access_endTime, this.active);
  Baby_relation.fromJson(Map<dynamic, dynamic> json)
      : BabyId = json['baby'],
        relation = json['relation'],
        Access_week = (json['access_date']==null) ? 255 : json['access_date'],
        Access_startTime = (json['access_starttime']==null) ? "" : json['access_starttime'],
        Access_endTime = (json['access_endtime']==null) ? "" : json['access_endtime'],
        active=json['active'];

  Map<String, dynamic> toJson() => {
    'baby': BabyId,
    'relation': relation,
    'access_date': Access_week,
    'access_starttime': Access_startTime,
    'access_endtime': Access_endTime,
    'active': active,
  };

  void elif(bool bool) {}
}
class Baby {
  final String name;
  final DateTime birth;
  final int gender; // 0 : 'F', 1 : 'M'
  final Baby_relation relationInfo;

  Baby(this.name, this.birth, this.gender, this.relationInfo);

  Baby.fromJson(Map<dynamic, dynamic> json)
      : name = json['baby_name'], birth = DateTime.parse(json['birth']), gender = (json['gender']=='M'?0:1), relationInfo = Baby_relation.fromJson(json['relationInfo']);
  getGenderString(){
    if(gender==0) return 'F';
    if(gender==1) return 'M';
  }

  Map<String, dynamic> toJson() => {
    'baby_name': name,
    'birth': birth,
    'gender': gender,
    'relationInfo': relationInfo
  };
}
