import 'package:flutter/material.dart';

class UserOnChangedModel {
  int? id;
  Color? color;
  String? name;
  String? longitude;
  String? latitude;

  UserOnChangedModel({
    this.id,
    this.color,
    this.name,
    this.longitude,
    this.latitude,
  });

  factory UserOnChangedModel.fromJson(Map<String, dynamic> json) {
    return UserOnChangedModel(
      id: json['id'],
      color: json['color'] != null ? Color(json['color']) : null,
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  UserOnChangedModel copyWith({
    int? id,
    Color? color,
    String? name,
    String? longitude,
    String? latitude,
  }) {
    return UserOnChangedModel(
      id: id ?? this.id,
      color: color ?? this.color,
      name: name ?? this.name,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['color'] = color?.value;
    data['name'] = name;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }

  @override
  String toString() {
    return 'CustomModel{id: $id, color: $color, name: $name, longitude: $longitude, latitude: $latitude}';
  }
}
