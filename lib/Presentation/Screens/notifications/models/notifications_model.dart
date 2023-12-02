// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  String? statusCode;
  List<NotificationData>? data;
  String? message;
  String? devMessage;

  NotificationsModel({
    this.statusCode,
    this.data,
    this.message,
    this.devMessage,
  });

  NotificationsModel copyWith({
    String? statusCode,
    List<NotificationData>? data,
    String? message,
    String? devMessage,
  }) =>
      NotificationsModel(
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
        message: message ?? this.message,
        devMessage: devMessage ?? this.devMessage,
      );

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x))),
        message: json["message"],
        devMessage: json["devMessage"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "devMessage": devMessage,
      };
}

class NotificationData {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? type;
  bool? isRead;
  int? userId;
  List<ENotification>? messageNotifications;
  List<ENotification>? likeNotifications;

  NotificationData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.isRead,
    this.userId,
    this.messageNotifications,
    this.likeNotifications,
  });

  NotificationData copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    bool? isRead,
    int? userId,
    List<ENotification>? messageNotifications,
    List<ENotification>? likeNotifications,
  }) =>
      NotificationData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        type: type ?? this.type,
        isRead: isRead ?? this.isRead,
        userId: userId ?? this.userId,
        messageNotifications: messageNotifications ?? this.messageNotifications,
        likeNotifications: likeNotifications ?? this.likeNotifications,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        type: json["type"],
        isRead: json["is_read"],
        userId: json["user_id"],
        messageNotifications: json["messageNotifications"] == null
            ? []
            : List<ENotification>.from(json["messageNotifications"]!
                .map((x) => ENotification.fromJson(x))),
        likeNotifications: json["likeNotifications"] == null
            ? []
            : List<ENotification>.from(json["likeNotifications"]!
                .map((x) => ENotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "type": type,
        "is_read": isRead,
        "user_id": userId,
        "messageNotifications": messageNotifications == null
            ? []
            : List<dynamic>.from(messageNotifications!.map((x) => x.toJson())),
        "likeNotifications": likeNotifications == null
            ? []
            : List<dynamic>.from(likeNotifications!.map((x) => x.toJson())),
      };
}

class ENotification {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likerId;
  int? notificationId;
  String? description;
  String? senderImageUrl;
  List<String>? sendImageGallery;
  int? senderId;
  int? messageId;

  ENotification({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.likerId,
    this.notificationId,
    this.description,
    this.senderImageUrl,
    this.sendImageGallery,
    this.senderId,
    this.messageId,
  });

  ENotification copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likerId,
    int? notificationId,
    String? description,
    String? senderImageUrl,
    List<String>? sendImageGallery,
    int? senderId,
    int? messageId,
  }) =>
      ENotification(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        likerId: likerId ?? this.likerId,
        notificationId: notificationId ?? this.notificationId,
        description: description ?? this.description,
        senderImageUrl: senderImageUrl ?? this.senderImageUrl,
        sendImageGallery: sendImageGallery ?? this.sendImageGallery,
        senderId: senderId ?? this.senderId,
        messageId: messageId ?? this.messageId,
      );

  factory ENotification.fromJson(Map<String, dynamic> json) => ENotification(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        likerId: json["liker_Id"],
        notificationId: json["notification_id"],
        description: json["description"],
        senderImageUrl: json["sender_image_url"],
        sendImageGallery: json["send_image_gallery"] == null
            ? []
            : List<String>.from(json["send_image_gallery"]!.map((x) => x)),
        senderId: json["sender_Id"],
        messageId: json["message_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "liker_Id": likerId,
        "notification_id": notificationId,
        "description": description,
        "sender_image_url": senderImageUrl,
        "send_image_gallery": sendImageGallery == null
            ? []
            : List<dynamic>.from(sendImageGallery!.map((x) => x)),
        "sender_Id": senderId,
        "message_id": messageId,
      };
}
