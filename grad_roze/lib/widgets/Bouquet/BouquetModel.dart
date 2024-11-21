class BouquetModel {
  final String imageUrl;
  final String title;
  final String price;
  final String desc;
  final bool isAdded;

  BouquetModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.desc,
    this.isAdded = false,
  });

  // Factory method for creating a BouquetModel from JSON data
  factory BouquetModel.fromJson(Map<String, dynamic> json) {
    return BouquetModel(
      imageUrl: json['imageUrl'],
      title: json['title'],
      price: json['price'],
      desc: json['desc'],
      isAdded: json['isAdded'] ?? false,
    );
  }

  // Method to convert a BouquetModel into a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'desc': desc,
      'isAdded': isAdded,
    };
  }
}
