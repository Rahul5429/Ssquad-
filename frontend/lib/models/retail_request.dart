import 'retail_metadata.dart';

class RetailRequest {
  const RetailRequest({
    required this.id,
    required this.preferredCountry,
    required this.preferredCity,
    required this.storeType,
    required this.productCategories,
    required this.floorArea,
    required this.openingTimeline,
    required this.requiresInventorySupport,
    required this.budgetAmount,
    required this.budgetCurrency,
    required this.status,
    this.additionalNotes,
    this.createdAt,
  });

  factory RetailRequest.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['productCategories'] as List<dynamic>? ?? <dynamic>[];
    return RetailRequest(
      id: json['_id'] as String,
      preferredCountry: json['preferredCountry'] as String? ?? '',
      preferredCity: json['preferredCity'] as String? ?? '',
      storeType: RetailStoreType.fromJson(json['storeType'] as Map<String, dynamic>),
      productCategories: categoriesJson
          .map((value) => RetailProductCategory.fromJson(value as Map<String, dynamic>))
          .toList(),
      floorArea: (json['floorArea'] as num?)?.toDouble() ?? 0,
      openingTimeline: json['openingTimeline'] as String? ?? '',
      requiresInventorySupport: json['requiresInventorySupport'] as bool? ?? false,
      budgetAmount: (json['budget']?['amount'] as num?)?.toDouble() ?? 0,
      budgetCurrency: json['budget']?['currency'] as String? ?? 'INR',
      status: json['status'] as String? ?? 'pending',
      additionalNotes: json['additionalNotes'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  final String id;
  final String preferredCountry;
  final String preferredCity;
  final RetailStoreType storeType;
  final List<RetailProductCategory> productCategories;
  final double floorArea;
  final String openingTimeline;
  final bool requiresInventorySupport;
  final double budgetAmount;
  final String budgetCurrency;
  final String status;
  final String? additionalNotes;
  final DateTime? createdAt;
}

