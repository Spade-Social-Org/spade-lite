// To parse this JSON data, do
//
//     final onAddNewMessageDataModel = onAddNewMessageDataModelFromJson(jsonString);

import 'dart:convert';

OnAddNewMessageDataModel onAddNewMessageDataModelFromJson(String str) =>
    OnAddNewMessageDataModel.fromJson(json.decode(str));

String onAddNewMessageDataModelToJson(OnAddNewMessageDataModel data) =>
    json.encode(data.toJson());

class OnAddNewMessageDataModel {
  String? content;
  int? messageId;
  int? senderId;
  String? name;

  OnAddNewMessageDataModel({
    this.content,
    this.messageId,
    this.senderId,
    this.name,
  });

  OnAddNewMessageDataModel copyWith({
    String? content,
    int? messageId,
    int? senderId,
    String? name,
  }) =>
      OnAddNewMessageDataModel(
        content: content ?? this.content,
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        name: name ?? this.name,
      );

  factory OnAddNewMessageDataModel.fromJson(Map<String, dynamic> json) =>
      OnAddNewMessageDataModel(
        content: json["content"],
        messageId: json["message_id"],
        senderId: json["sender_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "message_id": messageId,
        "sender_id": senderId,
        "name": name,
      };
}
