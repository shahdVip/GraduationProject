import 'bouquetViewWidget.dart' show BouquetViewWidget;

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
        imageUrl: 'http://192.168.1.9:3000${json['imageURL']}');
  }
}
