import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Gamepage extends StatefulWidget {
  const Gamepage({super.key});

  @override
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  String currentWord = "like";
  final TextEditingController _controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("끝말잇기"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Image.asset("images/bot.png",width: 200,height: 100,),
              SizedBox(height: 5,),
              Text("제시어",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                 width: 400,
                 height: 80,
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   color: Colors.grey[150],
                   border: Border.all(color: Colors.brown , width: 3)
                 ),
                 child: Text(currentWord,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 35,
                     fontWeight: FontWeight.bold,
                     color: Colors.black,
                   ),
                 ),
                ),
              ),
               SizedBox(height: 400,),
               Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "다음 단어 입력",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          String input = _controller.text.trim();
                          if (input.isEmpty) {
                            showToast("단어를 입력하세요.");
                            return;
                          }

                          String lastChar = currentWord[currentWord.length - 1];
                          String firstChar = input[0];

                          if (firstChar != lastChar) {
                            showToast("제시어의 마지막 글자로 시작하는 단어를 입력하세요.");
                            return;
                          }

                          // 임시 단어 리스트
                          List<String> validWords = ["event", "tanks", "skill", "lavender", "rank"];

                          if (!validWords.contains(input)) {
                            showToast("유효하지 않은 단어입니다.");
                            return;
                          }

                          setState(() {
                            currentWord = input;
                            _controller.clear();
                          });
                        },
                        child: Text("제출")
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.brown[200],
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }



}
