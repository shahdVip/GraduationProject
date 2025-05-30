import 'package:grad_roze/config.dart';

class BouquetViewModel {
  final String id;
  final String name;
  final double price;
  final String businessName;
  final String imageUrl;

  BouquetViewModel({
    required this.id,
    required this.name,
    required this.price,
    required this.businessName,
    required this.imageUrl,
  });

  // Create a model from JSON response
  factory BouquetViewModel.fromJson(Map<String, dynamic> json) {
    return BouquetViewModel(
        id: json['_id'],
        name: json['name'],
        price: json['price'].toDouble(),
        businessName: json['business'],
        imageUrl: '$url${json['imageURL']}');
  }
}
