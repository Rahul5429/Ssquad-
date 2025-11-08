import 'package:flutter/foundation.dart';

import '../models/banquet_request.dart';
import '../models/request_feed_item.dart';
import '../models/request_type.dart';
import '../models/retail_request.dart';
import '../models/travel_request.dart';
import '../services/request_service.dart';

class RequestProvider extends ChangeNotifier {
  RequestProvider(this._requestService);

  final RequestService _requestService;

  List<RequestFeedItem> _requests = <RequestFeedItem>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<RequestFeedItem> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _requests = await _requestService.fetchMyRequests();
    } catch (error) {
      debugPrint('Failed to fetch requests: $error');
      _errorMessage = 'Unable to fetch your requests';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addBanquetRequest(BanquetRequest request) {
    _add(RequestFeedItem(type: RequestType.banquet, banquet: request, travel: null, retail: null));
  }

  void addTravelRequest(TravelRequest request) {
    _add(RequestFeedItem(type: RequestType.travel, banquet: null, travel: request, retail: null));
  }

  void addRetailRequest(RetailRequest request) {
    _add(RequestFeedItem(type: RequestType.retail, banquet: null, travel: null, retail: request));
  }

  void _add(RequestFeedItem item) {
    _requests = <RequestFeedItem>[item, ..._requests];
    notifyListeners();
  }
}
