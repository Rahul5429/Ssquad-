class TravelPurpose {
  const TravelPurpose({
    required this.id,
    required this.name,
    this.description,
  });

  factory TravelPurpose.fromJson(Map<String, dynamic> json) {
    return TravelPurpose(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String? description;
}

class AccommodationType {
  const AccommodationType({
    required this.id,
    required this.name,
    this.description,
  });

  factory AccommodationType.fromJson(Map<String, dynamic> json) {
    return AccommodationType(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String name;
  final String? description;
}

class TravelAmenity {
  const TravelAmenity({
    required this.id,
    required this.name,
  });

  factory TravelAmenity.fromJson(Map<String, dynamic> json) {
    return TravelAmenity(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
}

