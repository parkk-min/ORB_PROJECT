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
  UserInfo? currentUser= null;

  String? username = null;
  String? password = null;

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
        this.currentUser = UserInfo.fromJson(decoded);
        provider.user=currentUser!;

        return true;
      } else if(response.statusCode==401){
        final msg = json.decode(utf8.decode(response.bodyBytes));
        showSnackBar(context, msg['result']);
      } else{
        showSnackBar(context, "Error:${response.statusCode}");
      }
    }catch (e) {
      print("Error:${e}");
    }
    return false;
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
                          Navigator.pop(context, {
                            'loginFlag': true,
                            'user': currentUser,
                          });
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
