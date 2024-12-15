import 'package:grad_roze/config.dart';

import '/custom/icon_button.dart';
import '/custom/theme.dart';
import '/custom/util.dart';
import 'BouquetCardWidget.dart' show BouquetCardWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
