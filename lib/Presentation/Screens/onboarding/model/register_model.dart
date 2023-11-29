// ignore_for_file: public_member_api_docs, sort_constructors_first
class RegisterModel {
  final String? email;
  final String? password;
  final String? name;
  final String? phoneNumber;
  final String? country;
  final String? username;
  final String? city;
  final String? state;
  final String? postalCode;
  RegisterModel({
    this.email,
    this.password,
    this.name,
    this.phoneNumber,
    this.country,
    this.username,
    this.city,
    this.state,
    this.postalCode,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "phone_number": phoneNumber,
        "username": username,
        "country": country,
        "city": city,
        "state": state,
        "postal_code": postalCode,
      };

  @override
  String toString() {
    return 'RegisterModel(email: $email, password: $password, name: $name, phoneNumber: $phoneNumber, country: $country, username: $username, city: $city, state: $state, postalCode: $postalCode)';
  }

  RegisterModel copyWith({
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    String? country,
    String? username,
    String? city,
    String? state,
    String? postalCode,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      username: username ?? this.username,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}

class RegisterResponseModel {
  RegisterResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.devMessage,
  });

  final String? statusCode;
  final RegisterData? data;
  final String? message;
  final String? devMessage;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      statusCode: json["statusCode"],
      data: json["data"] == null ? null : RegisterData.fromJson(json["data"]),
      message: json["message"],
      devMessage: json["devMessage"],
    );
  }
}

class RegisterData {
  RegisterData({
    required this.userId,
    required this.name,
    required this.email,
  });

  final int? userId;
  final String? name;
  final String? email;

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      userId: json["userId"],
      name: json["name"],
      email: json["email"],
    );
  }
}
