
class UserInfo{
  final String username;
  final String? password;
  final String? name;
  final String? phone;

  UserInfo({required this.username, this.password, this.name, this.phone});

  factory UserInfo.fromJson(Map<String, dynamic> json){
    return UserInfo(
        username: json['username'],
        password: json['password'],
        name: json['name'],
        phone: json['phone']
    );
  }
  // 서버 데이터로 맵 json으로 객체 만들기(폼 데이터 전송등에 사용)

  Map<String, dynamic> toJson(){
    return{
      "username":username,
      "password":password
    };
  }
  // api보낼 다음 단계 준비 위해 객체로 맵을 만드는 함수.
}