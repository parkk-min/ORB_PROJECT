import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ouroboros/signup.dart';

void main() {
  runApp(const MyApp());
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
              Container(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: (){

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


