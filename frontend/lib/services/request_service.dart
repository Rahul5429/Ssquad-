import '../core/api_client.dart';
import '../models/banquet_request.dart';
import '../models/request_feed_item.dart';
import '../models/travel_request.dart';
import '../models/retail_request.dart';

class RequestService {
  RequestService(this._apiClient);

  final ApiClient _apiClient;

  Future<BanquetRequest> submitBanquetRequest({
    required String eventTypeId,
    required String country,
    required String state,
    required String city,
    required List<DateTime> eventDates,
    required int adults,
    required int children,
    required List<String> cateringPreferences,
    required List<String> cuisineIds,
    required double budgetAmount,
    required String budgetCurrency,
    required String responseOptionId,
    String? additionalNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/requests/banquets',
      data: {
        'eventTypeId': eventTypeId,
        'country': country,
        'state': state,
        'city': city,
        'eventDates': eventDates.map((date) => date.toIso8601String()).toList(),
        'adults': adults,
        'children': children,
        'cateringPreferences': cateringPreferences,
        'cuisineIds': cuisineIds,
        'budget': {
          'amount': budgetAmount,
          'currency': budgetCurrency,
        },
        'responseOptionId': responseOptionId,
        'additionalNotes': additionalNotes,
      },
    );

    return BanquetRequest.fromJson(response.data?['data'] as Map<String, dynamic>);
  }

  Future<TravelRequest> submitTravelRequest({
    required String destinationCountry,
    required String destinationCity,
    required DateTime checkIn,
    required DateTime checkOut,
    required int adults,
    required int children,
    required int roomsNeeded,
    required String purposeId,
    required String accommodationTypeId,
    required List<String> amenityIds,
    required double budgetAmount,
    required String budgetCurrency,
    String? additionalNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/requests/travel',
      data: {
        'destinationCountry': destinationCountry,
        'destinationCity': destinationCity,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'adults': adults,
        'children': children,
        'roomsNeeded': roomsNeeded,
        'purposeId': purposeId,
        'accommodationTypeId': accommodationTypeId,
        'amenityIds': amenityIds,
        'budget': {
          'amount': budgetAmount,
          'currency': budgetCurrency,
        },
        'additionalNotes': additionalNotes,
      },
    );

    return TravelRequest.fromJson(response.data?['data'] as Map<String, dynamic>);
  }

  Future<RetailRequest> submitRetailRequest({
    required String preferredCountry,
    required String preferredCity,
    required String storeTypeId,
    required List<String> productCategoryIds,
    required double floorArea,
    required String openingTimeline,
    required bool requiresInventorySupport,
    required double budgetAmount,
    required String budgetCurrency,
    String? additionalNotes,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/requests/retail',
      data: {
        'preferredCountry': preferredCountry,
        'preferredCity': preferredCity,
        'storeTypeId': storeTypeId,
        'productCategoryIds': productCategoryIds,
        'floorArea': floorArea,
        'openingTimeline': openingTimeline,
        'requiresInventorySupport': requiresInventorySupport,
        'budget': {
          'amount': budgetAmount,
          'currency': budgetCurrency,
        },
        'additionalNotes': additionalNotes,
      },
    );

    return RetailRequest.fromJson(response.data?['data'] as Map<String, dynamic>);
  }

  Future<List<RequestFeedItem>> fetchMyRequests() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/requests');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results
        .map((e) => RequestFeedItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

