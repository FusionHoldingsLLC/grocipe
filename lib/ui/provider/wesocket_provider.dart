// ignore_for_file: avoid_print, await_only_futures, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/models/websocket_response.dart';
import 'package:grocipe/helper/third_party/cloudinary.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends StateNotifier<List<WebSocketResponse>> {
  WebSocketChannel? _channel;
  String? _accessToken;
  List<WebSocketResponse> messages = [];
  bool isLoading = false;
  int dailyUsage = 20;
  int dailyUsageRemain = 0;

  WebSocketService() : super([]);

  void connect(String token) {
    _accessToken = token;
    _channel = IOWebSocketChannel.connect(
        'wss://www.grocipe.app/api/v1/chat/ws?token=$_accessToken');

    _channel?.stream.listen((message) {
      isLoading = false;
      final decodedMessage = jsonDecode(message);
      final webSocketMessage = WebSocketResponse.fromJson(decodedMessage);
      // Update usage data
      if (webSocketMessage.dailyUsage != null) {
        dailyUsage = webSocketMessage.dailyUsage!;
      }
      if (webSocketMessage.dailyUsageRemain != null) {
        dailyUsageRemain = webSocketMessage.dailyUsageRemain!;
      }
      messages.add(webSocketMessage);
      state = List.from(messages);
    }, onError: (error) {
      isLoading = false;
      print('Connection error: $error');
    }, onDone: () {
      isLoading = false;
      print('Disconnected from WebSocket');
    });
  }

  List<File> unsentImages = [];
  Future<void> sendMessage(String message) async {
    if (_channel != null) {
      List<File> copiedImages = List.from(unsentImages);
      messages.add(WebSocketResponse(
          preMessage: message, type: 'sent', images: copiedImages));
      state = await List.from(messages);
      unsentImages.clear();
      isLoading = true;
      List<Map<String, String>> images = [];

      for (File imageFile in unsentImages) {
        if (imageFile != null) {
          String? imageUrl = await CloudinaryDev.uploadPicture(
            path: imageFile.path,
            folder: "your_folder",
            fileName: "your_file_name",
          );
          if (imageUrl != null) {
            images.add({"url": imageUrl});
          }
        }
      }

      Map<String, dynamic> data = {"text": message, "images": images};
      String jsonString = jsonEncode(data);

      _channel?.sink.add(jsonString);
      print("The total number of images are ${unsentImages.length}");

      // isLoading = false;
    } else {
      print('WebSocket not connected');
    }
  }

  void setImage({File? imageFile}) {
    if (unsentImages.length < 2 && imageFile != null) {
      unsentImages.add(imageFile);
      state = List.from(messages);
    }
  }

  void removeUnsentImage(File imageFile) {
    unsentImages.remove(imageFile);
    state = List.from(messages);
  }

  void disconnect() {
    _channel?.sink.close();
  }
}

final webSocketServiceProvider =
    StateNotifierProvider<WebSocketService, List<WebSocketResponse>>(
        (ref) => WebSocketService());
