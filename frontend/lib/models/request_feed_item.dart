import 'banquet_request.dart';
import 'request_type.dart';
import 'retail_request.dart';
import 'travel_request.dart';

class RequestFeedItem {
  const RequestFeedItem({
    required this.type,
    required this.banquet,
    required this.travel,
    required this.retail,
  });

  factory RequestFeedItem.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String? ?? 'banquet';
    final type = RequestType.values.firstWhere(
      (value) => value.name == typeString,
      orElse: () => RequestType.banquet,
    );

    final payload = json['request'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return RequestFeedItem(
      type: type,
      banquet: type == RequestType.banquet ? BanquetRequest.fromJson(payload) : null,
      travel: type == RequestType.travel ? TravelRequest.fromJson(payload) : null,
      retail: type == RequestType.retail ? RetailRequest.fromJson(payload) : null,
    );
  }

  final RequestType type;
  final BanquetRequest? banquet;
  final TravelRequest? travel;
  final RetailRequest? retail;
}

