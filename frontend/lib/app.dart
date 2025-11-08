import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/banquet/banquet_form_screen.dart';
import 'screens/banquet/request_history_screen.dart';
import 'screens/banquet/request_success_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/retail/retail_form_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/travel/travel_form_screen.dart';
import 'theme/app_colors.dart';

class BanquetsApp extends StatelessWidget {
  const BanquetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.pageBackground,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDEE3F0)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        HomeScreen.routeName: (context) => const _GuardedPage(child: HomeScreen.routeName),
        BanquetFormScreen.routeName: (context) => const _GuardedPage(child: BanquetFormScreen.routeName),
        TravelFormScreen.routeName: (context) => const _GuardedPage(child: TravelFormScreen.routeName),
        RetailFormScreen.routeName: (context) => const _GuardedPage(child: RetailFormScreen.routeName),
        RequestSuccessScreen.routeName: (context) => const RequestSuccessScreen(),
        RequestHistoryScreen.routeName: (context) => const _GuardedPage(child: RequestHistoryScreen.routeName),
      },
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isInitialized) {
          return const SplashScreen();
        }

        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}

class _GuardedPage extends StatelessWidget {
  const _GuardedPage({required this.child});

  final String child;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    switch (child) {
      case HomeScreen.routeName:
        return const HomeScreen();
      case BanquetFormScreen.routeName:
        return const BanquetFormScreen();
      case TravelFormScreen.routeName:
        return const TravelFormScreen();
      case RetailFormScreen.routeName:
        return const RetailFormScreen();
      case RequestHistoryScreen.routeName:
        return const RequestHistoryScreen();
      default:
        return const HomeScreen();
    }
  }
}

