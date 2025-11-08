class EventType {
  const EventType({
    required this.id,
    required this.name,
    this.description,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String? description;
}

