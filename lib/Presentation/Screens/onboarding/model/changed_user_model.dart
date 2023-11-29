// To parse this JSON data, do
//
//     final changedUserModel = changedUserModelFromJson(jsonString);

import 'dart:convert';

ChangedUserModel changedUserModelFromJson(String str) =>
    ChangedUserModel.fromJson(json.decode(str));

String changedUserModelToJson(ChangedUserModel data) =>
    json.encode(data.toJson());

class ChangedUserModel {
  String? gender;
  String? relationshipType;
  int? minAge;
  int? maxAge;
  List<String>? hobbies;
  int? radius;
  String? genderPreference;
  String? religion;
  String? bodyType;
  String? fcmToken;
  int? height;
  String? ethnicity;
  int? longitude;
  int? latitude;
  DateTime? dob;

  ChangedUserModel({
    this.gender,
    this.relationshipType,
    this.minAge,
    this.maxAge,
    this.hobbies,
    this.radius,
    this.genderPreference,
    this.religion,
    this.bodyType,
    this.fcmToken,
    this.height,
    this.ethnicity,
    this.longitude,
    this.latitude,
    this.dob,
  });

  ChangedUserModel copyWith({
    String? gender,
    String? relationshipType,
    int? minAge,
    int? maxAge,
    List<String>? hobbies,
    int? radius,
    String? genderPreference,
    String? religion,
    String? bodyType,
    String? fcmToken,
    int? height,
    String? ethnicity,
    int? longitude,
    int? latitude,
    DateTime? dob,
  }) =>
      ChangedUserModel(
        gender: gender ?? this.gender,
        relationshipType: relationshipType ?? this.relationshipType,
        minAge: minAge ?? this.minAge,
        maxAge: maxAge ?? this.maxAge,
        hobbies: hobbies ?? this.hobbies,
        radius: radius ?? this.radius,
        genderPreference: genderPreference ?? this.genderPreference,
        religion: religion ?? this.religion,
        bodyType: bodyType ?? this.bodyType,
        fcmToken: fcmToken ?? this.fcmToken,
        height: height ?? this.height,
        ethnicity: ethnicity ?? this.ethnicity,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        dob: dob ?? this.dob,
      );

  factory ChangedUserModel.fromJson(Map<String, dynamic> json) =>
      ChangedUserModel(
        gender: json["gender"],
        relationshipType: json["relationship_type"],
        minAge: json["min_age"],
        maxAge: json["max_age"],
        hobbies: json["hobbies"] == null
            ? []
            : List<String>.from(json["hobbies"]!.map((x) => x)),
        radius: json["radius"],
        genderPreference: json["gender_preference"],
        religion: json["religion"],
        bodyType: json["body_type"],
        fcmToken: json["fcm_token"],
        height: json["height"],
        ethnicity: json["ethnicity"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      );

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "relationship_type": relationshipType,
        "min_age": minAge,
        "max_age": maxAge,
        "hobbies":
            hobbies == null ? [] : List<dynamic>.from(hobbies!.map((x) => x)),
        "radius": radius,
        "gender_preference": genderPreference,
        "religion": religion,
        "body_type": bodyType,
        "fcm_token": fcmToken,
        "height": height,
        "ethnicity": ethnicity,
        "longitude": longitude,
        "latitude": latitude,
        "dob": dob?.toIso8601String(),
      };
}
