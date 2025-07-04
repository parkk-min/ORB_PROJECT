import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ouroboros/wordprovider.dart';
import 'package:provider/provider.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late String result;
  late WordProvider provider;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    result = ModalRoute.of(context)?.settings.arguments as String;
    provider= context.read<WordProvider>();
  }


  Future<void> submitResult() async{
    final url = Uri.parse("http://10.0.2.2:8080/game/result");

    try{
      final response = await http.post(
          url ,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": provider.user.username,
            "result": result,
          })
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("게임 기록 갱신")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("게임 기록 갱신 실패: ${response.body}")),
        );
      }
    }catch(e){
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameHistory(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/game/history'),
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

        // data가 List인지 확인
        if (data is! List) {
          print("예상치 못한 데이터 형식: $data");
          return [];
        }

        // UNDECIDED 제외 필터링
        final filtered = data
            .where((e) => e is Map && (e["result"] == "WIN" || e["result"] == "LOSE"))
            .cast<Map<String, dynamic>>()
            .toList();

        print("필터링된 결과: $filtered");
        return filtered;
      } else {
        print("서버 에러: ${response.statusCode}");
        return []; // 예외 대신 빈 리스트 반환
      }
    } catch (e) {
      print("fetchGameHistory 에러: $e");
      return []; // 모든 예외 상황에서 빈 리스트 반환
    }
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: result == "WIN" ? Colors.amber.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      result == "WIN" ? "🎉" : "😵",
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  Text(result=="WIN"?"승리":"패배",
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: result=="WIN"? Colors.amber: Colors.blue,
                    ),),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                      onPressed: ()async {
                        await submitResult();
                        final newHistory = await fetchGameHistory(provider.user.username!);
                        provider.updateHistory(newHistory);
                        await Navigator.pushNamedAndRemoveUntil( // ✅ 스택 전체 제거
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
                        onPressed:() async {
                          await submitResult();
                          final newHistory = await fetchGameHistory(provider.user.username!);
                          provider.updateHistory(newHistory);
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
