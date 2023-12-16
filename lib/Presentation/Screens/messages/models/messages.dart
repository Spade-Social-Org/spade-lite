class Messages {
  Messages({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.devMessage,
  });

  final String? statusCode;
  final List<MessageData> data;
  final String? message;
  final String? devMessage;

  factory Messages.fromJson(Map<String, dynamic>? json) {
    return Messages(
      statusCode: json!["statusCode"],
      data: json["data"] == null
          ? []
          : List<MessageData>.from(
              json["data"]!.map((x) => MessageData.fromJson(x))),
      message: json["message"],
      devMessage: json["devMessage"],
    );
  }
}

class MessageData {
  MessageData({
    required this.content,
    required this.createdAt,
    required this.name,
    required this.userId,
    required this.image,
    required this.gallery,
  });

  final String? content;
  final DateTime? createdAt;
  final String? name;
  final int? userId;
  final dynamic image;
  final dynamic gallery;

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      content: json["content"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      name: json["name"],
      userId: json["user_id"],
      image: json["image"],
      gallery: json["gallery"],
    );
  }
}
