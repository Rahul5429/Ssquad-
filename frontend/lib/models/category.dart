class Category {
  const Category({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.imageUrl,
    this.highlightedText,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      highlightedText: json['highlightedText'] as String?,
    );
  }

  final String id;
  final String title;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? highlightedText;
}

