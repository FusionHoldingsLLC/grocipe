// ignore_for_file: library_private_types_in_public_api, empty_catches

import 'package:flutter/material.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? channel;
  String? accessToken;

  Future<void> login(String username, String password) async {
    accessToken = HiveFunction.getUser().accessToken;
    if (accessToken != null) {
      _connectToWebSocket();
    } else {
      throw Exception('Login failed: access token not found');
    }
  }

  void _connectToWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('wss://www.grocipe.app/api/v1/chat/ws?token=$accessToken'),
    );
    channel?.stream.listen((message) {}, onError: (error) {}, onDone: () {});
  }

  void sendMessage(String message) {
    if (channel != null) {
      channel?.sink.add(jsonEncode({'text': message}));
    } else {}
  }

  void disconnect() {
    channel?.sink.close();
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginAndConnect();
  }

  Future<void> _loginAndConnect() async {
    try {
      await _webSocketService.login('your_username', 'your_password');
    } catch (e) {}
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocipe Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
