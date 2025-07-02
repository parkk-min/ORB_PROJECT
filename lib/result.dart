import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("당신의 결과는?"),
                  Text("두번째 줄")
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                      onPressed:(){
                        
                      },
                      child: Text("홈으로"))
                ),
                SizedBox(width: 30,),
                Container(
                    child: ElevatedButton(
                        onPressed:(){
                          
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
