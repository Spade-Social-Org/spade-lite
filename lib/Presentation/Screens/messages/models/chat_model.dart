class ChatsResponseModel {
  ChatsResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.devMessage,
  });

  final String? statusCode;
  final List<ChatsData> data;
  final String? message;
  final String? devMessage;

  factory ChatsResponseModel.fromJson(Map<String, dynamic>? json) {
    return ChatsResponseModel(
      statusCode: json!["statusCode"],
      data: json["data"] == null
          ? []
          : List<ChatsData>.from(
              json["data"]!.map((x) => ChatsData.fromJson(x))),
      message: json["message"],
      devMessage: json["devMessage"],
    );
  }
}

class ChatsData {
  ChatsData({
    required this.latestMessage,
    required this.name,
    required this.userId,
    required this.image,
    required this.gallery,
  });

  final String? latestMessage;
  final String? name;
  final int? userId;
  final dynamic image;
  final dynamic gallery;

  factory ChatsData.fromJson(Map<String, dynamic> json) {
    return ChatsData(
      latestMessage: json["latest_message"],
      name: json["name"],
      userId: json["user_id"],
      image: json["image"],
      gallery: json["gallery"],
    );
  }
}
