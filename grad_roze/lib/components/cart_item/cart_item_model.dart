import '../../config.dart';

class CartItemModel {
  final String id;
  final String name;
  final double price;
  final String businessName;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.businessName,
    required this.imageUrl,
  });

  // Factory method to parse from a database JSON response
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(), // Ensure double type
      businessName: json['business'] as String,
      imageUrl: '$url${json['imageURL']}',
    );
  }

  // Override toString method for better logging
  @override
  String toString() {
    return 'CartItemModel(id: $id, name: $name, price: $price, businessName: $businessName, imageUrl: $imageUrl)';
  }
}
