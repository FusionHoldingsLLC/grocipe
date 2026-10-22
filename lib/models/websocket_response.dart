// Data models
import 'dart:io';

class ListDetail {
  final int? no;
  final String? nameOrDetails;
  final String? url;

  ListDetail({
    this.no,
    this.nameOrDetails,
    this.url,
  });

  factory ListDetail.fromJson(Map<String, dynamic> json) {
    return ListDetail(
      no: json['no'],
      nameOrDetails: json['name_or_details'],
      url: json['url'],
    );
  }
}

class SuggestedMessage {
  final String? message;

  SuggestedMessage({this.message});

  factory SuggestedMessage.fromJson(Map<String, dynamic> json) {
    return SuggestedMessage(message: json['message']);
  }
}

class WebSocketResponse {
  final String? preMessage;
  final List<ListDetail>? listDetails;
  final String? postMessage;
  final List<SuggestedMessage>? suggestedMessages;
  final int? dailyUsage;
  final int? dailyUsageRemain;
  final String? type;
  // final File? image;
  final List<File>? images;
  final bool? done;

  WebSocketResponse(
      {this.preMessage,
      this.listDetails,
      this.postMessage,
      this.suggestedMessages,
      this.dailyUsage,
      this.dailyUsageRemain,
      this.type,
      // this.image,
      this.images,
      this.done});

  factory WebSocketResponse.fromJson(Map<String, dynamic> json) {
    return WebSocketResponse(
      preMessage: json['pre_message'],
      listDetails: json['list_details'] != null
          ? List<ListDetail>.from(
              json['list_details'].map((x) => ListDetail.fromJson(x)),
            )
          : null,
      postMessage: json['post_message'],
      suggestedMessages: json['suggested_messages'] != null
          ? List<SuggestedMessage>.from(
              json['suggested_messages']
                  .map((x) => SuggestedMessage.fromJson(x)),
            )
          : null,
      dailyUsage: json['daily_usage'],
      dailyUsageRemain: json['daily_usage_remain'],
      type: json['type'],
      done: json['done'],
    );
  }
}
