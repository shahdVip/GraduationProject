class Bouquet {
  final String name;
  final List<String> tags;
  final String imageURL;
  final String description;
  final String business;
  final double price;

  Bouquet({
    required this.name,
    required this.tags,
    required this.imageURL,
    required this.description,
    required this.business,
    required this.price,
  });

  // Parse JSON into a Bouquet object
  factory Bouquet.fromJson(Map<String, dynamic> json) {
    return Bouquet(
      name: json['name'],
      tags: List<String>.from(json['tags']),
      imageURL: json['imageURL'],
      description: json['description'],
      business: json['business'],
      price: json['price'].toDouble(),
    );
  }
}
