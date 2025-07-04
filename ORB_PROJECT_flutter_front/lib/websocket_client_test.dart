import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketTestPage extends StatefulWidget {
  final String playerId;
  final String opponentId;

  const WebSocketTestPage({super.key, required this.playerId, required this.opponentId});

  @override
  State<WebSocketTestPage> createState() => _WebSocketTestPageState();
}

class _WebSocketTestPageState extends State<WebSocketTestPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.26:8080/ws/game?playerId=${widget.playerId}'),
    );

    channel.stream.listen((data) {
      setState(() => messages.add("상대: $data"));
    });
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final msg = '{"from":"${widget.playerId}", "to":"${widget.opponentId}", "type":"answer", "data":"${_controller.text}"}';
    channel.sink.add(msg);
    setState(() => messages.add("나: ${_controller.text}"));
    _controller.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket 1:1 테스트")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: messages.map((msg) => Text(msg)).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: '메시지를 입력하세요'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
