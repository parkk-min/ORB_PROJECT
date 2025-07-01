import 'package:flutter/material.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();



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
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 아이디
                    TextFormField(
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
                          contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                    SizedBox(height: 10,),
                    //비밀번호
                    TextFormField(
                      key: ValueKey(2),
                      validator: (value){
                        if(value!.isEmpty){
                          return "input username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: "비밀번호",
                          contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                    SizedBox(height: 10,),
                    // 전화번호
                    TextFormField(
                      key: ValueKey(3),
                      validator: (value){
                        if(value!.isEmpty){
                          return "input username";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_circle),
                          hintText: "전화번호",
                          contentPadding: EdgeInsets.all(10)
                      ),
                    ),
                  ],
                ),
          ),
          ),
      ),
    );
  }
}
