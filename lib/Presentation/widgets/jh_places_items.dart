import 'package:flutter/material.dart';

List<dynamic> images = [
  "assets/images/Rectangle 3381.png",
  "assets/images/Rectangle 3382.png",
  "assets/images/Rectangle 3383.png",
  "assets/images/Rectangle 3384.png",
];

// List<dynamic> placeImages = [
//   "assets/images/placeimage.png",
//   "assets/images/placeimage2.png",
//   "assets/images/placeimage2.png",
//   "assets/images/placeimage.png",
// ];
//
// List<dynamic> hotelImages = [
//   "assets/images/Hotel 1.png",
//   "assets/images/Hotel 1.png",
//   "assets/images/Hotel 2.png",
//   "assets/images/Hotel 2.png",
// ];
// List<dynamic> clubsImages = [
//   "assets/images/club3.png",
//   "assets/images/club2.png",
//   "assets/images/club3.png",
//   "assets/images/club2.png",
//
//
// ];

// List<dynamic> museumImages = [
//   "assets/images/museum1.png",
//   "assets/images/museum2.png",
//   "assets/images/museum2.png",
//   "assets/images/museum1.png",
//
//
// ];
//
// List<dynamic> restaurantImages = [
//   "assets/images/restaurant.png",
//   "assets/images/restaurant.png",
//   "assets/images/restaurant.png",
//   "assets/images/restaurant.png",
// ];

// List<dynamic> moviesImages = [
//   "assets/images/movie1.png",
//   "assets/images/movie1.png",
//   "assets/images/movie1.png",
//   "assets/images/movie1.png",
// ];

List<String> title = ["Food & Drinks", "Movies", "Activities", "Lodging"];

List<String> text = [
  "Favourite",
  "Restaurants",
  "Coffee",
];

final List<String> scheduleNotice = [
  "Available",
  "Available",
  "Available",
  "Unavailable",
  "Unavailable",
  "Available",
  "Unavailable",
];

final List<String> scheduleTime = [
  "12:00 PM",
  "10:30 AM",
  "12:00 PM",
  "9:30 Am",
  "12:00 PM",
  "1:00 PM",
  "9:30 Am",
];

List<dynamic> iconsRow = [
  Icons.favorite,
  Icons.directions_run_outlined,
  Icons.directions_run_outlined,
];

class Friend {
  final String images;
  final Color color;

  const Friend(this.images, this.color);
}

List<Friend> friend = [
  const Friend(
    "assets/images/Ellipse 368.png",
    Colors.green,
  ),
  const Friend("assets/images/Ellipse 372.png", Colors.green),
  const Friend("assets/images/Ellipse 366.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.yellow),
  const Friend("assets/images/Ellipse 368.png", Colors.yellow),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.grey),
  const Friend("assets/images/Ellipse 377.png", Colors.green),
  const Friend("assets/images/Ellipse 372 (1).png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.grey),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 377.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
  const Friend("assets/images/Ellipse 368.png", Colors.red),
  const Friend("assets/images/Ellipse 368.png", Colors.green),
];

class CardModel {
  final String title;
  final String image;
  final String placeType;

  CardModel(
      {required this.title, required this.image, required this.placeType});
}

final List<CardModel> cards = [
  CardModel(
      title: 'Food & Drinks',
      image: "assets/images/Rectangle 3381.png",
      placeType: 'restaurant'),
  CardModel(
      title: 'Movies',
      image: "assets/images/Rectangle 3382.png",
      placeType: 'movie_theater'),
  CardModel(
      title: 'Activities',
      image: "assets/images/Rectangle 3383.png",
      placeType: 'park'),
  CardModel(
      title: 'Lodging',
      image: "assets/images/Rectangle 3384.png",
      placeType: 'lodging'),
];
