import 'package:grad_roze/config.dart';

import 'package:grad_roze/config.dart' show url;

/// bouquet_card_model.dart
class Bouquet {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int price;

  Bouquet({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });
  factory Bouquet.fromJson(Map<String, dynamic> json) {
    return Bouquet(
      id: json['_id']?.toString() ?? 'Unknown ID', // Handle null with default
      name: json['name'] ?? 'Unnamed Bouquet', // Default for missing name
      imageUrl: '$url${json['imageURL']}',
      rating: (json['rating'] ?? 0).toDouble(), // Default rating as 0
      price: (json['price'] ?? 0)
          .toInt(), // Default price as 0, converted to String
    );
  }
}
