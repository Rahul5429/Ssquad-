import 'cuisine.dart';
import 'event_type.dart';
import 'response_option.dart';

class BanquetRequest {
  const BanquetRequest({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.eventDates,
    required this.adults,
    required this.children,
    required this.cateringPreferences,
    required this.budgetAmount,
    required this.budgetCurrency,
    required this.eventType,
    required this.cuisines,
    required this.responseOption,
    required this.status,
    this.additionalNotes,
    this.createdAt,
  });

  factory BanquetRequest.fromJson(Map<String, dynamic> json) {
    final eventDatesJson = json['eventDates'] as List<dynamic>? ?? <dynamic>[];
    final catering =
        (json['cateringPreferences'] as List<dynamic>? ?? <dynamic>[]).cast<String>();
    final cuisinesJson = json['cuisines'] as List<dynamic>? ?? <dynamic>[];

    return BanquetRequest(
      id: json['_id'] as String,
      country: json['country'] as String? ?? '',
      state: json['state'] as String? ?? '',
      city: json['city'] as String? ?? '',
      eventDates: eventDatesJson.map((date) => DateTime.parse(date as String)).toList(),
      adults: json['guests']?['adults'] as int? ?? 0,
      children: json['guests']?['children'] as int? ?? 0,
      cateringPreferences: catering,
      budgetAmount: (json['budget']?['amount'] as num?)?.toDouble() ?? 0,
      budgetCurrency: json['budget']?['currency'] as String? ?? 'INR',
      eventType: EventType.fromJson(json['eventType'] as Map<String, dynamic>),
      cuisines: cuisinesJson
          .map((cuisine) => Cuisine.fromJson(cuisine as Map<String, dynamic>))
          .toList(),
      responseOption:
          ResponseOption.fromJson(json['responseOption'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'pending',
      additionalNotes: json['additionalNotes'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  final String id;
  final String country;
  final String state;
  final String city;
  final List<DateTime> eventDates;
  final int adults;
  final int children;
  final List<String> cateringPreferences;
  final double budgetAmount;
  final String budgetCurrency;
  final EventType eventType;
  final List<Cuisine> cuisines;
  final ResponseOption responseOption;
  final String status;
  final String? additionalNotes;
  final DateTime? createdAt;
}

