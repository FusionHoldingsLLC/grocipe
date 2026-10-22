import 'package:grocipe/models/chat_model.dart';

class ChatFunction {
  static ChatModel convertMessageToJson(String message,
      {String? image, String? replyId}) {
    return ChatModel.fromJson({
      'isMe': false,
      'message': message,
      'image': image,
      "replyId": replyId,
    });
  }
}
