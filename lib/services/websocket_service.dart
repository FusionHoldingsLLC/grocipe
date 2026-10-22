import 'dart:convert';

import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/websocket_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? channel;
  String? accessToken;
  final Function(WebSocketResponse) onMessageReceived;

  WebSocketService({required this.onMessageReceived});

  Future<void> login() async {
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

    channel?.stream.listen((message) {
      print('Message received: $message');
      final response = WebSocketResponse.fromJson(jsonDecode(message));
      onMessageReceived(response);
    }, onError: (error) {
      print('Connection error: $error');
    }, onDone: () {
      print('Disconnected from WebSocket');
    });
  }

  void sendMessage(String message) {
    if (channel != null) {
      channel?.sink.add(jsonEncode({'text': message}));
      onMessageReceived(WebSocketResponse(type: 'sent', preMessage: message));
    } else {
      print('WebSocket not connected');
    }
  }

  void disconnect() {
    channel?.sink.close();
  }
}
