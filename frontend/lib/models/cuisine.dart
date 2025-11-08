class Cuisine {
  const Cuisine({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final String? imageUrl;
}

