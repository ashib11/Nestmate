class Property {
  final String imageUrl;
  final String location;
  final String price;
  final String availability;
  final int bedroom;
  final int bathroom;
  final int balcony;
  final int kitchen;
  final String description; // Make sure this exists
  final String userName;
  final String userImage;
  final DateTime postTime;

  Property({
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.availability,
    required this.bedroom,
    required this.bathroom,
    required this.balcony,
    required this.kitchen,
    required this.description, // Add this
    required this.userName,
    required this.userImage,
    required this.postTime,
  });
}