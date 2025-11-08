import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/banquet_request_provider.dart' show RequestProvider;
import '../banquet/banquet_form_screen.dart';
import '../banquet/request_history_screen.dart';
import '../retail/retail_form_screen.dart';
import '../travel/travel_form_screen.dart';
import '../../theme/app_colors.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final categoryProvider = context.read<CategoryProvider>();
    categoryProvider.loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final List<Category> filteredCategories =
        categoryProvider.categories.where((Category category) {
      if (_searchQuery.isEmpty) return true;
      return category.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.fadedPrimaryBackground,
      appBar: _buildAppBar(context, authProvider),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<CategoryProvider>().loadCategories(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                if (categoryProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (categoryProvider.errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(categoryProvider.errorMessage!),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => categoryProvider.loadCategories(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: filteredCategories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CategoryCard(
                              category: category,
                              onTap: () {
                                _handleCategoryTap(category.slug);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AuthProvider authProvider) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          PopupMenuButton<_AccountAction>(
            onSelected: (value) {
              if (value == _AccountAction.logout) {
                context.read<AuthProvider>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<_AccountAction>(
                value: _AccountAction.logout,
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Color(0xFFD94343), size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFD94343),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            color: Colors.white,
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Text(
                  _initials(authProvider.user?.name),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  authProvider.user?.name ?? 'Guest User',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Plan overview',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Request history',
          onPressed: () {
            final requestProvider = context.read<RequestProvider>();
            requestProvider.loadRequests();
            Navigator.of(context).pushNamed(RequestHistoryScreen.routeName);
          },
          icon: const Icon(Icons.history),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search categories',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.22),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.white),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(Icons.close, size: 18, color: Colors.white),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: BorderSide.none,
              ),
            ),
            cursorColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
    );
  }

  void _handleCategoryTap(String slug) {
    switch (slug) {
      case 'banquets-venues':
        Navigator.of(context).pushNamed(BanquetFormScreen.routeName);
        break;
      case 'travel-stay':
        Navigator.of(context).pushNamed(TravelFormScreen.routeName);
        break;
      case 'retail-stores':
        Navigator.of(context).pushNamed(RetailFormScreen.routeName);
        break;
      default:
        break;
    }
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
}

}

enum _AccountAction { logout }

const Map<String, String> _categoryAssetPaths = {
  'travel-stay': 'assets/images/travel.webp',
  'banquets-venues': 'assets/images/banquet.webp',
  'retail-stores': 'assets/images/retails.webp',
};

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    this.onTap,
  });

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (category.description != null && category.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(category.description!, style: const TextStyle(color: Colors.black54)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final assetPath = _categoryAssetPaths[category.slug];
    if (assetPath != null) {
      return Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackPlaceholder(),
      );
    }

    return _fallbackPlaceholder();
  }

  Widget _fallbackPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.08),
      child: Center(
        child: Text(
          category.title.substring(0, 1),
          style: const TextStyle(fontSize: 48, color: AppColors.primary),
        ),
      ),
    );
  }
}

