class RetailStoreType {
  const RetailStoreType({
    required this.id,
    required this.name,
    this.description,
  });

  factory RetailStoreType.fromJson(Map<String, dynamic> json) {
    return RetailStoreType(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String? description;
}

class RetailProductCategory {
  const RetailProductCategory({
    required this.id,
    required this.name,
  });

  factory RetailProductCategory.fromJson(Map<String, dynamic> json) {
    return RetailProductCategory(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
}

