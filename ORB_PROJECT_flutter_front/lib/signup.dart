import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text("회원가입",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
        ),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // 아이디
                          TextFormField(
                            controller: _usernameController,
                            key: ValueKey(1),
                            validator: (value){
                              if(value!.isEmpty){
                                return "input username";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.account_circle),
                                hintText: "아이디",
                                contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blueGrey,width: 2),
                            )
                            ),
                          ),
                          SizedBox(height: 10,),
                          //비밀번호
                          TextFormField(
                            controller: _passwordController,
                            key: ValueKey(2),
                            validator: (value){
                              if(value!.isEmpty){
                                return "input password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                hintText: "비밀번호",
                                contentPadding: EdgeInsets.all(10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blueGrey,width: 2),
                              )
                            ),
                              obscureText: true, // ****** 처리
                          ),
                          SizedBox(height: 10,),
                          // 전화번호
                          TextFormField(
                            controller: _phoneController,
                            key: ValueKey(3),
                            validator: (value){
                              if(value!.isEmpty){
                                return "input phone";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.phone_android),
                                hintText: "전화번호",
                                contentPadding: EdgeInsets.all(10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blueGrey,width: 2),
                             )
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            controller: _nameController,
                            key: ValueKey(4),
                            validator: (value){
                              if(value!.isEmpty){
                                return "input name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.drive_file_rename_outline),
                                hintText: "이름",
                                contentPadding: EdgeInsets.all(10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blueGrey,width: 2),
                                )
                            ),
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: (){
                                _submitSignup();
                              },
                              child: Text("가입"))
                        ],
                      ),
                    ),
                  ),
                ],
          ),
          ),
      ),
    );
  }

  void _submitSignup() async{
    if(_formKey.currentState!.validate()){
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();

      final url = Uri.parse("http://10.0.2.2:8080/signup");

      try{
        final response = await http.post(
            url ,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username,
              "password": password,
              "phone": phone,
              "name": name
            })
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅회원가입 성공!")),
          );
          Navigator.pushNamed(context, "/");
          // 회원가입 성공 후 처리 (예: 화면 이동)
        } else if(response.statusCode == 409){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ 이미 존재하는 아이디입니다.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("회원가입 실패: ${response.body}")),
          );
        }

      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("🚨 오류 발생: $e")),
        );
      }
    }
  }
  }