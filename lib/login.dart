import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ouroboros/userinfo.dart';
import 'package:ouroboros/wordprovider.dart';

import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  UserInfo? currentUser;

  String? username;
  String? password;

  bool validation() {
    if (_formKey1.currentState!.validate()) {
      _formKey1.currentState!.save();
      return true;
    }
    return false;
  }

  Future <bool> loginRequest() async{
    WordProvider provider = context.read<WordProvider>();
    final url = Uri.parse("http://10.0.2.2:8080/login");
    UserInfo user =UserInfo(username: username!, password: password!);
    final body = user.toJson();

    try{
      final response= await http.post(url, body: body);
      if(response.statusCode==200){
        final token = response.headers['authorization'];
        final refresh= response.headers['set-cookie'];
        final decoded = json.decode(utf8.decode(response.bodyBytes));


        provider.refreshToken= refresh!;
        provider.accessToken= token!;
        currentUser = UserInfo.fromJson(decoded);

        final userInfo = await getUser();
        provider.user = userInfo!;

        provider.fakeUser=provider.user.username;

        provider.history = await fetchGameHistory(username!);

        provider.loginFlagTrue();

        return true;
      } else if(response.statusCode==401){
        final msg = json.decode(utf8.decode(response.bodyBytes));
        showSnackBar(context, msg['result']);
      } else{
        showSnackBar(context, "Error:${response.statusCode}");
      }
    }catch (e) {
      print("Error:$e");
    }
    return false;
  }

  Future<UserInfo?> getUser() async {
    WordProvider provider = context.read<WordProvider>();
    final url = Uri.parse('http://10.0.2.2:8080/user?username=$username');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": provider.accessToken, // Provider에서 토큰 가져오기
        }
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final UserInfo user = UserInfo.fromJson(decoded);
        return user;
      } else {
        showSnackBar(context, "사용자 정보를 가져올 수 없습니다.");
        return null;
      }
    } catch (e) {
      print("Error:$e");
      showSnackBar(context, "네트워크 오류가 발생했습니다.");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameHistory(String username) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/history'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 메시지일 경우 예외 처리
      if (data is Map && data.containsKey('message')) {
        print(data['message']);
        return [];
      }

      // UNDECIDED 제외 필터링
      final filtered = (data as List)
          .where((e) =>
      e["result"] == "WIN" || e["result"] == "LOSE")
          .cast<Map<String, dynamic>>()
          .toList();

      return filtered;
    } else {
      throw Exception("서버 에러");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          Form(
            key: _formKey1,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey(1),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "can't be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.face),
                    hintText: "username",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                TextFormField(
                  key: ValueKey(2),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "can't be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "password",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  obscureText: true,
                ),
                SizedBox(width: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center ,
                  children: [
                    ElevatedButton(onPressed: () async{
                      if(validation()){
                        final response = await loginRequest();
                        if(response){
                          showSnackBar(context, "로그인 성공");
                          Navigator.pop(context,);
                        }
                      }
                    }, child: Text("로그인")
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
        duration: Duration(seconds: 2),
      )
  );
}
