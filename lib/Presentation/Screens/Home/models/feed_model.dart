// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

FeedModel feedModelFromJson(String str) => FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  String? statusCode;
  String? message;
  List<Feed>? data;
  Meta? meta;

  FeedModel({
    this.statusCode,
    this.message,
    this.data,
    this.meta,
  });

  FeedModel copyWith({
    String? statusCode,
    String? message,
    List<Feed>? data,
    Meta? meta,
  }) =>
      FeedModel(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Feed>.from(json["data"]!.map((x) => Feed.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Feed {
  Set<String>? gallery;
  String? description;
  int? id;
  DateTime? createdAt;
  String? posterName;
  String? posterImage;
  String? numberOfLikes;
  String? bookmarked;
  String? likedPost;
  int? posterId;

  Feed({
    this.gallery,
    this.description,
    this.id,
    this.createdAt,
    this.posterName,
    this.posterImage,
    this.posterId,
    this.numberOfLikes,
    this.bookmarked,
    this.likedPost,
  });

  Feed copyWith({
    Set<String>? gallery,
    String? description,
    int? id,
    DateTime? createdAt,
    String? posterName,
    String? posterImage,
    String? numberOfLikes,
    String? bookmarked,
    String? likedPost,
    int? posterId,
  }) {
    return Feed(
      gallery: gallery ?? this.gallery,
      description: description ?? this.description,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      posterName: posterName ?? this.posterName,
      posterImage: posterImage ?? this.posterImage,
      numberOfLikes: numberOfLikes ?? this.numberOfLikes,
      bookmarked: bookmarked ?? this.bookmarked,
      likedPost: likedPost ?? this.likedPost,
      posterId: posterId ?? this.posterId,
    );
  }

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        gallery: json["gallery"] == null
            ? {}
            : Set<String>.from(json["gallery"]!.map((x) => x)),
        description: json["description"],
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        posterName: json["poster_name"],
        posterImage: json["poster_image"],
        posterId: json["poster_id"],
        numberOfLikes: json["number_of_likes"],
        bookmarked: json["bookmarked"],
        likedPost: json["liked_post"],
      );

  Map<String, dynamic> toJson() => {
        "gallery":
            gallery == null ? [] : List<dynamic>.from(gallery!.map((x) => x)),
        "description": description,
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "poster_name": posterName,
        "poster_id": posterId,
        "poster_image": posterImage,
        "number_of_likes": numberOfLikes,
        "bookmarked": bookmarked,
        "liked_post": likedPost,
      };

  @override
  bool operator ==(covariant Feed other) {
    if (identical(this, other)) return true;

    return setEquals(other.gallery, gallery) &&
        other.description == description &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.posterName == posterName &&
        other.posterImage == posterImage &&
        other.numberOfLikes == numberOfLikes &&
        other.bookmarked == bookmarked &&
        other.likedPost == likedPost;
  }

  @override
  int get hashCode {
    return gallery.hashCode ^
        description.hashCode ^
        id.hashCode ^
        createdAt.hashCode ^
        posterName.hashCode ^
        posterImage.hashCode ^
        numberOfLikes.hashCode ^
        bookmarked.hashCode ^
        likedPost.hashCode;
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? totalPages;
  String? first;
  String? last;
  String? prev;
  String? next;

  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  Meta copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? totalPages,
    String? first,
    String? last,
    String? prev,
    String? next,
  }) =>
      Meta(
        total: total ?? this.total,
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        first: first ?? this.first,
        last: last ?? this.last,
        prev: prev ?? this.prev,
        next: next ?? this.next,
      );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        perPage: json["perPage"],
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "perPage": perPage,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}
