class ResponseOption {
  const ResponseOption({
    required this.id,
    required this.label,
    required this.hours,
    this.description,
  });

  factory ResponseOption.fromJson(Map<String, dynamic> json) {
    return ResponseOption(
      id: json['_id'] as String,
      label: json['label'] as String? ?? '',
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );
  }

  final String id;
  final String label;
  final int hours;
  final String? description;
}

