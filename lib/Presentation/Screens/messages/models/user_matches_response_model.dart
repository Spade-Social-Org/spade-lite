class UserMatchesResponseModel {
  UserMatchesResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.devMessage,
  });

  final String? statusCode;
  final List<UserMatchesResponseData> data;
  final String? message;
  final String? devMessage;

  factory UserMatchesResponseModel.fromJson(Map<String, dynamic> json) {
    return UserMatchesResponseModel(
      statusCode: json["statusCode"],
      data: json["data"] == null
          ? []
          : List<UserMatchesResponseData>.from(
              json["data"]!.map((x) => UserMatchesResponseData.fromJson(x))),
      message: json["message"],
      devMessage: json["devMessage"],
    );
  }
}

class UserMatchesResponseData {
  UserMatchesResponseData({
    required this.userId,
    required this.name,
    required this.image,
    required this.gallery,
  });

  final int? userId;
  final String? name;
  final dynamic image;
  final dynamic gallery;

  factory UserMatchesResponseData.fromJson(Map<String, dynamic> json) {
    return UserMatchesResponseData(
      userId: json["user_id"],
      name: json["name"],
      image: json["image"],
      gallery: json["gallery"],
    );
  }
}
