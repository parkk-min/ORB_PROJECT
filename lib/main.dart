import 'package:flutter/material.dart';
import 'package:ouroboros/login.dart';
import 'dart:async';

import 'package:ouroboros/signup.dart';
import 'package:ouroboros/userinfo.dart';
import 'package:ouroboros/wordprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(create: (context)=>WordProvider(),
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: MyPage(),
      initialRoute: "/",
      routes: {
        '/':(context)=> MyPage(),
        '/login':(context)=> Login(),
        '/signup':(context)=>Signup(),
      },
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}
class _MyPageState extends State<MyPage> {
  String? currentUser = null;
  bool changeBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text("OUROBOROS",
        style:TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BouncingLetter(char: "끝",delayMs: 600,),
              SizedBox(width: 20,),
              BouncingLetter(char: "말",delayMs: 1500,),
              SizedBox(width: 20,),
              BouncingLetter(char: "잇",delayMs: 2200,),
              SizedBox(width: 20,),
              BouncingLetter(char: "기",delayMs: 2900,),
              SizedBox(height: 30,)
                ],
              ),
          SizedBox(height: 40,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/rotating_ouroboros_highres_ccw.gif',
                width: 400,
                height: 400,
              ),
              // 삼항 연산자
              changeBox ? 
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){

                        },
                        child: Text("게임 시작", style: TextStyle(fontSize: 20))
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: (){
                          // 게임 내용 저장 하는 api 필요.
                          context.read<WordProvider>().reset();
                          setState(() {
                            currentUser = null;
                            changeBox = false;
                            showSnackBar(context, "로그아웃 되었습니다.");
                          });
                        },
                        child: Text("로그아웃", style: TextStyle(fontSize: 20))
                    ),
                  ],
                ),
              )
                  :
              Column(
                children: [
                  Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                            onPressed: () async {
                              final result = await Navigator.pushNamed(context, "/login");
                              if (result is Map && result['loginFlag'] == true) {
                                  showSnackBar(context, "${currentUser}님 환영합니다.");
                                setState(() {
                                  changeBox = true;
                                  currentUser = result['user'].name;
                                });
                              }
                            },
                            child: Text("로그인",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                            ),
                        ),
                      ),
                  SizedBox(width: 20,),

                  Container(
                      padding: EdgeInsets.all(0),
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text("회원가입",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          ),
                      )
                  ),
                ]
              )
            ],
          )
            ],
          ),
    );
  }
}








// 애니메이션 stateful widget
class BouncingLetter extends StatefulWidget {
  final String char; // 텍스트
  final int delayMs; // 지연시간
  const BouncingLetter({required this.char, this.delayMs = 0, Key? key}) : super(key: key);

  @override
  State<BouncingLetter> createState() => _BouncingLetterState();
}

class _BouncingLetterState extends State<BouncingLetter> {

  double _scale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), _startRepeating);
  }

  void _startRepeating() async {
    while (mounted) {
      await _animate(); // 한 번 애니메이션
      await Future.delayed(Duration(seconds: 4)); // 4초 기다림 후 반복
    }
  }

  Future<void> _animate() async {
    setState(() => _scale = 0.8);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _scale = 1.2);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _scale = 1.0);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animate,
      child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(100),
                blurRadius: 3,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Text(
            widget.char,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

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
