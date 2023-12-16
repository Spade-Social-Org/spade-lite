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
  List<Likenotification>? messagenotifications;
  List<Likenotification>? likenotifications;

  NotificationData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.isRead,
    this.userId,
    this.messagenotifications,
    this.likenotifications,
  });

  NotificationData copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    bool? isRead,
    int? userId,
    List<Likenotification>? messagenotifications,
    List<Likenotification>? likenotifications,
  }) =>
      NotificationData(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        type: type ?? this.type,
        isRead: isRead ?? this.isRead,
        userId: userId ?? this.userId,
        messagenotifications: messagenotifications ?? this.messagenotifications,
        likenotifications: likenotifications ?? this.likenotifications,
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
        messagenotifications: json["messagenotifications"] == null
            ? []
            : List<Likenotification>.from(json["messagenotifications"]!
                .map((x) => Likenotification.fromJson(x))),
        likenotifications: json["likenotifications"] == null
            ? []
            : List<Likenotification>.from(json["likenotifications"]!
                .map((x) => Likenotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "type": type,
        "is_read": isRead,
        "user_id": userId,
        "messagenotifications": messagenotifications == null
            ? []
            : List<dynamic>.from(messagenotifications!.map((x) => x.toJson())),
        "likenotifications": likenotifications == null
            ? []
            : List<dynamic>.from(likenotifications!.map((x) => x.toJson())),
      };
}

class Likenotification {
  int? id;
  int? likerId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? description;
  int? notificationId;
  String? senderImageUrl;
  List<String>? sendImageGallery;

  Likenotification({
    this.id,
    this.likerId,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.notificationId,
    this.senderImageUrl,
    this.sendImageGallery,
  });

  Likenotification copyWith({
    int? id,
    int? likerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    int? notificationId,
    String? senderImageUrl,
    List<String>? sendImageGallery,
  }) =>
      Likenotification(
        id: id ?? this.id,
        likerId: likerId ?? this.likerId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        description: description ?? this.description,
        notificationId: notificationId ?? this.notificationId,
        senderImageUrl: senderImageUrl ?? this.senderImageUrl,
        sendImageGallery: sendImageGallery ?? this.sendImageGallery,
      );

  factory Likenotification.fromJson(Map<String, dynamic> json) =>
      Likenotification(
        id: json["id"],
        likerId: json["liker_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        description: json["description"],
        notificationId: json["notification_id"],
        senderImageUrl: json["sender_image_url"],
        sendImageGallery: json["send_image_gallery"] == null
            ? []
            : List<String>.from(json["send_image_gallery"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "liker_id": likerId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "description": description,
        "notification_id": notificationId,
        "sender_image_url": senderImageUrl,
        "send_image_gallery": sendImageGallery == null
            ? []
            : List<dynamic>.from(sendImageGallery!.map((x) => x)),
      };
}
