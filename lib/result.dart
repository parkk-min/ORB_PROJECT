import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late String result;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    result = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("멋진 게임이었습니다.", style: TextStyle(fontSize: 20),),
                  Text("게임의 결과는?",style: TextStyle(fontSize: 20),),
                  Icon(result=="승리"?Icons.celebration:Icons.face_unlock_rounded,
                    size: 30,
                  ),
                  Text(result,style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil( // ✅ 스택 전체 제거
                          context,
                          "/",
                              (route) => false,
                        );
                      },
                      child: Text("홈으로"))
                ),
                SizedBox(width: 30,),
                Container(
                    child: ElevatedButton(
                        onPressed:(){
                          Navigator.pushReplacementNamed(context, "/gamePage");
                        },
                        child: Text("다시하기"))
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
