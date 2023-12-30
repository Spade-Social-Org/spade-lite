class Friend {
  final int userId;
  final String name;
  final List<String> image;

  Friend({
    required this.userId,
    required this.name,
    required this.image,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['user_id'],
      name: json['name'],
      image: List<String>.from(json['image']),
    );
  }
}
