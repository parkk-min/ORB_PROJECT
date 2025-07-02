import 'package:flutter/material.dart';
import 'package:ouroboros/login.dart';
import 'package:ouroboros/gamepage.dart';
import 'package:ouroboros/result.dart';
import 'dart:async';
import 'package:ouroboros/signup.dart';
import 'package:ouroboros/userinfo.dart';
import 'package:ouroboros/wordprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WordProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        '/': (context) => MyPage(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/gamePage': (context) => Gamepage(),
        '/result':(context)=> Result()
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
  UserInfo? currentUser = null;

  @override
  Widget build(BuildContext context) {
    WordProvider provider = context.watch<WordProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: Text(
          "OUROBOROS",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        centerTitle: true,
      ),

      drawer: provider.loginFlag ? AccontDetailsDrawer() : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BouncingLetter(char: "끝", delayMs: 0, fontSize: 22),
              SizedBox(width: 20),
              BouncingLetter(char: "말", delayMs: 500, fontSize: 22),
              SizedBox(width: 20),
              BouncingLetter(char: "잇", delayMs: 1000, fontSize: 22),
              SizedBox(width: 20),
              BouncingLetter(char: "기", delayMs: 1500, fontSize: 22),
              SizedBox(height: 30),
            ],
          ),
          SizedBox(height: 40),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<WordProvider>(
                builder: (context, provider, child) {
                  return Image.asset(
                    provider.selectedTheme == 'snake'
                        ? 'images/rotating_ouroboros_highres_ccw.gif'
                        : 'images/bot.png',
                    width: 400,
                    height: 400,
                  );
                },
              ),
              // 삼항 연산자
              provider.loginFlag
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/gamePage");
                            },
                            child: Text(
                              "게임 시작",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // 게임 내용 저장 하는 api 필요.
                              context.read<WordProvider>().reset();
                              setState(() {
                                provider.loginFlagFalse();
                                currentUser = null;
                                showSnackBar(context, "로그아웃 되었습니다.");
                              });
                            },
                            child: Text("로그아웃", style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, "/login");
                            },
                            child: Text(
                              "로그인",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),

                        Container(
                          padding: EdgeInsets.all(0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              "회원가입",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

// 애니메이션 stateful widget
class BouncingLetter extends StatefulWidget {
  final String char; // 텍스트
  final int delayMs; // 지연시간
  final double fontSize; // 추가된 글자 크기 속성
  const BouncingLetter({
    required this.char,
    this.delayMs = 0,
    this.fontSize = 20,
    Key? key,
  }) : super(key: key);

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
              ),
            ],
          ),
          child: Text(
            widget.char,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: 2)),
  );
}

class AccontDetailsDrawer extends StatefulWidget {
  // 안바뀌는 값
  const AccontDetailsDrawer({super.key});

  final String phone = "010-1234-5678";
  final String address = "서울특별시 강남구";

  @override
  State<AccontDetailsDrawer> createState() => _AccontDetailsDrawerState();
}

class _AccontDetailsDrawerState extends State<AccontDetailsDrawer> {
  // 이 안에다가 넣어야 리렌더링 되게 값을 만들 수 있다.
  bool showDetails = false;
  late WordProvider provider;

  //설정 조정
  String selectedTheme = 'Light';
  Color bgColor = Colors.white; //기본

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.watch<WordProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // 햄버거 탭 만들기, 여러가지 들어감
        padding: EdgeInsets.zero, // 맨 위 줄 까지 채움
        children: [
          UserAccountsDrawerHeader(
            // 삼각형 조그를 제공하는 위젯
            decoration: BoxDecoration(
              color: Colors.blueGrey[400], // 윗 배경색
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            accountName: Text(
              provider.fakeUser,
              style: TextStyle(color: Colors.black87),
            ),
            accountEmail: SizedBox.shrink(),
            currentAccountPicture: CircleAvatar(
              // 사진이 먼저 나옴.
              backgroundImage: AssetImage('images/박시현.png'),
              // backgroundColor: Colors.red[200],// 서클 아바타 색
            ),
            onDetailsPressed: () {
              // 삼각형을 여기서 설정
              setState(() {
                // 이렇게 해야 재랜더링 된다. 렌더링 관련이므로 이렇게 한다.
                this.showDetails = !(this.showDetails);
              }); //
            },
          ),
          if (this.showDetails) // 바로 밑에 쓰면 조건에 따라 보여짐에 영향을 줌
            Padding(
              padding: EdgeInsets.zero,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.supervised_user_circle),
                        ),
                        Text(
                          "name : ${widget.phone}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                        Text(
                          "Phone : ${widget.phone}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.sports_kabaddi, color: Colors.grey[850]),
              title: Text("내 전적보기"),
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("15전 10승 5패"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.settings, color: Colors.grey[850]),
              title: Text("Settings"),
              children: [
                Text("테마 선택:", style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: Text('우르보르스 테마'),
                  value: 'snake',
                  groupValue: provider.selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      provider.changeTheme(value!);
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('?? 테마'),
                  value: 'fairy',
                  groupValue: provider.selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      provider.changeTheme(value!);
                    });
                  },
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.question_answer, color: Colors.grey[850]),
              title: Text("Q&A"),
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("문의 이메일: himedia @ gannam.net"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.login_outlined),
            title: Text("Log-out"),
            onTap: () {
              context.read<WordProvider>().reset();
              setState(() {
                provider.loginFlagFalse();
                showSnackBar(context, "로그아웃 되었습니다.");
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.login_outlined),
            title: Text("리절트 화면"),
            onTap: () {
              Navigator.pushNamed(context, "/result");
            },
          ),
        ],
      ),
    );
  }
}
