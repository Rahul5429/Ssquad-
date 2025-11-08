import 'travel_metadata.dart';

class TravelRequest {
  const TravelRequest({
    required this.id,
    required this.destinationCountry,
    required this.destinationCity,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.roomsNeeded,
    required this.purpose,
    required this.accommodationType,
    required this.amenities,
    required this.budgetAmount,
    required this.budgetCurrency,
    required this.status,
    this.additionalNotes,
    this.createdAt,
  });

  factory TravelRequest.fromJson(Map<String, dynamic> json) {
    final amenitiesJson = json['amenities'] as List<dynamic>? ?? <dynamic>[];
    return TravelRequest(
      id: json['_id'] as String,
      destinationCountry: json['destinationCountry'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      checkIn: DateTime.parse(json['stayTimeline']?['checkIn'] as String),
      checkOut: DateTime.parse(json['stayTimeline']?['checkOut'] as String),
      adults: json['guests']?['adults'] as int? ?? 1,
      children: json['guests']?['children'] as int? ?? 0,
      roomsNeeded: json['roomsNeeded'] as int? ?? 1,
      purpose: TravelPurpose.fromJson(json['purpose'] as Map<String, dynamic>),
      accommodationType:
          AccommodationType.fromJson(json['accommodationType'] as Map<String, dynamic>),
      amenities: amenitiesJson
          .map((value) => TravelAmenity.fromJson(value as Map<String, dynamic>))
          .toList(),
      budgetAmount: (json['budget']?['amount'] as num?)?.toDouble() ?? 0,
      budgetCurrency: json['budget']?['currency'] as String? ?? 'INR',
      status: json['status'] as String? ?? 'pending',
      additionalNotes: json['additionalNotes'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  final String id;
  final String destinationCountry;
  final String destinationCity;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int roomsNeeded;
  final TravelPurpose purpose;
  final AccommodationType accommodationType;
  final List<TravelAmenity> amenities;
  final double budgetAmount;
  final String budgetCurrency;
  final String status;
  final String? additionalNotes;
  final DateTime? createdAt;
}

