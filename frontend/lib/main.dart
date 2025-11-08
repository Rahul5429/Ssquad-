import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/api_client.dart';
import 'providers/auth_provider.dart';
import 'providers/banquet_request_provider.dart' show RequestProvider;
import 'providers/category_provider.dart';
import 'services/category_service.dart';
import 'services/request_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(apiClient: apiClient)..initialize(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(CategoryService(apiClient)),
        ),
        ChangeNotifierProvider<RequestProvider>(
          create: (_) => RequestProvider(RequestService(apiClient)),
        ),
      ],
      child: const BanquetsApp(),
    ),
  );
}
