import '../core/api_client.dart';
import '../models/country.dart';
import '../models/cuisine.dart';
import '../models/event_type.dart';
import '../models/response_option.dart';
import '../models/travel_metadata.dart';
import '../models/retail_metadata.dart';

class MetadataService {
  MetadataService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<EventType>> fetchEventTypes() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/event-types');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results.map((e) => EventType.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Country>> fetchCountries() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/countries');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Cuisine>> fetchCuisines() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/cuisines');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results.map((e) => Cuisine.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ResponseOption>> fetchResponseOptions() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/response-options');
    final results = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
    return results.map((e) => ResponseOption.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<({
    List<TravelPurpose> purposes,
    List<AccommodationType> accommodationTypes,
    List<TravelAmenity> amenities,
  })> fetchTravelMetadata() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/travel');
    final data = response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final purposes = (data['purposes'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => TravelPurpose.fromJson(e as Map<String, dynamic>))
        .toList();
    final accommodations = (data['accommodationTypes'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => AccommodationType.fromJson(e as Map<String, dynamic>))
        .toList();
    final amenities = (data['amenities'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => TravelAmenity.fromJson(e as Map<String, dynamic>))
        .toList();

    return (purposes: purposes, accommodationTypes: accommodations, amenities: amenities);
  }

  Future<({
    List<RetailStoreType> storeTypes,
    List<RetailProductCategory> categories,
  })> fetchRetailMetadata() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/metadata/retail');
    final data = response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final storeTypes = (data['storeTypes'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => RetailStoreType.fromJson(e as Map<String, dynamic>))
        .toList();
    final categories = (data['productCategories'] as List<dynamic>? ?? <dynamic>[])
        .map((e) => RetailProductCategory.fromJson(e as Map<String, dynamic>))
        .toList();

    return (storeTypes: storeTypes, categories: categories);
  }
}

