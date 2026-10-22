import 'package:flutter/material.dart';

import 'websocket_response.dart';

class ChatModel {
  final bool isMe;
  final String message;
  final String? image;
  final String? replyId;
  final WebSocketResponse? response;
  final String? replyMessage;
  final ValueNotifier<double> slideAnimationValue = ValueNotifier<double>(0);

  ChatModel({
    required this.isMe,
    required this.message,
    this.image,
    this.replyId,
    this.response,
    this.replyMessage,
  });

  // Factory constructor to create a ChatModel from a JSON map
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      isMe: json['isMe'],
      message: json['message'],
      image: json['image'],
      replyId: json['replyId'],
      replyMessage: json['replyMessage'],
    );
  }

  // Method to convert a ChatModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'isMe': isMe,
      'message': message,
      'image': image,
      'replyId': replyId,
      'replyMessage': replyMessage,
    };
  }
}
