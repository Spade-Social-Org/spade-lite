class Place {
  final String id;
  final String name;
  final String address;
  final List<String> imageURL;
  final List<String> reviews;
  final String openingHours;
  Place( {
    required this.id,
    required this.name,
    required this.address,
    required this.imageURL,
    required this.reviews,
    required this.openingHours,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Place &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              address == other.address &&
              imageURL == other.imageURL &&
              reviews == other.reviews &&

              openingHours == other.openingHours;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      imageURL.hashCode ^
      reviews.hashCode ^
      openingHours.hashCode;
}
