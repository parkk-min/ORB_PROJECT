import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './countdownTimer.dart';

class Gamepage extends StatefulWidget {
  const Gamepage({super.key});

  @override
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage> {
  String currentWord = "로딩 중...";
  final TextEditingController _controller = TextEditingController();
  int turnCount = 0; // 타이머를 재시작할 수 있게 만드는 값
  bool gameOver = false; // 타이머 종료 시 게임 종료 여부 체크

  List<String> validWords = [];
  List<String> usedWords = []; // 사용된 단어
  bool isGameOver = false; // 게임 종료
  String botStatus = ""; // 봇의 텍스트 입력

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("끝말잇기")),
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Center(
          child: Column(
            children: [
              CountdownTimer(
                key: ValueKey(turnCount), // 이 값이 바뀌면 타이머 재시작됨
                seconds: 20,
                onTimeUp: () {
                  if (!gameOver && !isGameOver) { // 중복 실행 방지
                    setState(() {
                      gameOver = true;
                      isGameOver = true;
                    });
                    showGameOverDialog(context);
                    print("패배! 시간 초과됨");
                  }
                },
              ),
              Image.asset("images/bot.png", width: 200, height: 100),
              SizedBox(height: 5),
              if (botStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    botStatus,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              Text(
                "봇 단어",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 400,
                  height: 80,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[150],
                    border: Border.all(color: Colors.brown, width: 3),
                  ),
                  child: Text(
                    currentWord,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(35),
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
                    onPressed: () async {
                      if (gameOver || isGameOver) {
                        showToast("게임이 종료되었습니다.");
                        return;
                      }

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

                      // 단어 리스트 불러와서 유효성 검사
                      List<String> validWords = await fetchValidWords();
                      if (!validWords.contains(input)) {
                        showToast("유효하지 않은 단어입니다.");
                        return;
                      }

                      // ✅ 유효한 단어일 경우 → 타이머 재시작
                      setState(() {
                        turnCount++; // 타이머 재시작
                        currentWord = input;
                        usedWords.add(input);
                        _controller.clear();
                      });

                      await submitWord(input);
                    },
                    child: Text("제출"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 토스트 메세지
  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.brown[200],
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }

  // 데이터베이스 단어 불러오는 함수
  Future<List<String>> fetchValidWords() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/word/play"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception("없는 단어 입니다");
    }
  }

  Future<String> fetchRandomWord() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/word/random"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['word'];
    } else {
      throw Exception("제시어를 불러오지 못했습니다.");
    }
  }

  // 제시어 초기화
  Future<void> initializeGame() async {
    try {
      final radomWord = await fetchRandomWord(); // 제시어 초기화
      final words = await fetchValidWords(); // 유효 단어 불러오기

      setState(() {
        currentWord = radomWord;
        validWords = words;
        _controller.clear(); // 입력창 초기화
      });
    } catch (e) {
      print("Error : ${e}");
    }
  }

  // 봇
  Future<void> submitWord(String word) async {
    if (isGameOver || gameOver) return;

    // 사용자 입력 처리
    setState(() {
      currentWord = word;
      usedWords.add(word);
      _controller.clear();
      botStatus = "🤖 봇이 단어를 생각 중이에요...";
    });

    final url = Uri.parse('http://10.0.2.2:8080/game/play');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": "aaa", // ← 여기는 실제 존재하는 유저로
          "word": word,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final nextWordData = data["nextWord"];
        final botWord = nextWordData?["word"]; // null-safe 접근
        final gameOver = data["gameOver"] ?? false;

        // 봇 응답 딜레이
        await Future.delayed(Duration(milliseconds: 1300));

        setState(() {
          if (botWord != null) {
            currentWord = botWord;
            usedWords.add(botWord);
            turnCount++; // 봇이 단어를 제시했을 때도 타이머 재시작
          } else {
            botStatus = "😵 봇이 더 이상 단어를 찾지 못했어요!";
            isGameOver = true;
          }

          if (gameOver) {
            isGameOver = true;
            this.gameOver = true;
          }

          if (!isGameOver && !this.gameOver) {
            botStatus = "";
          }
        });

        if (gameOver || botWord == null) {
          showVictoryDialog(context);
        }

      } else {
        showToast("서버 응답 오류: ${response.statusCode}");
        setState(() {
          botStatus = "";
        });
      }
    } catch (e) {
      showToast("오류 발생: $e");
      setState(() {
        botStatus = "";
      });
    }
  }

  // 끝말잇기 졌을떄
  void showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("게임 오버 😢"),
          content: Text("시간 초과로 패배했습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/result", arguments: "패배").then((result) {
                  if (result == "reset") {
                    resetGame();
                  }
                });
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  // 끝말잇기 이겼을때
  void showVictoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("승리 🎉"),
          content: Text("봇이 단어를 찾지 못했습니다.\n당신이 이겼어요!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 100), () {
                  Navigator.pushNamed(context, "/result", arguments: "승리").then((result) {
                    if (result == "reset") {
                      resetGame();
                    }
                  });
                });
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() async {
    setState(() {
      gameOver = false;
      isGameOver = false;
      usedWords.clear();
      botStatus = "";
      turnCount++; // 타이머 재시작을 위해 증가
    });
    await initializeGame();
  }
}