import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api_client.dart';
import '../../models/retail_metadata.dart';
import '../../providers/banquet_request_provider.dart' show RequestProvider;
import '../../services/metadata_service.dart';
import '../../services/request_service.dart';
import '../../theme/app_colors.dart';
import '../banquet/request_success_screen.dart';
import '../home/home_screen.dart';

class RetailFormScreen extends StatefulWidget {
  const RetailFormScreen({super.key});

  static const routeName = '/retail-form';

  @override
  State<RetailFormScreen> createState() => _RetailFormScreenState();
}

class _RetailFormScreenState extends State<RetailFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<_RetailFormMetadata> _metadataFuture;

  RetailStoreType? _selectedStoreType;
  final Set<String> _selectedCategoryIds = <String>{};
  String? _preferredCountry;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _floorAreaController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();
  bool _requiresInventorySupport = false;
  double? _budgetAmount;
  String _budgetCurrency = 'INR';
  bool _showCategoryError = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<ApiClient>();
    _metadataFuture = _loadMetadata(apiClient);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _floorAreaController.dispose();
    _timelineController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<_RetailFormMetadata> _loadMetadata(ApiClient apiClient) async {
    final metadataService = MetadataService(apiClient);
    final metadata = await metadataService.fetchRetailMetadata();

    _selectedStoreType = null;
    _selectedCategoryIds.clear();
    _preferredCountry = null;

    return _RetailFormMetadata(
      storeTypes: metadata.storeTypes,
      categories: metadata.categories,
      commonCountries: const ['India', 'United Arab Emirates', 'Singapore', 'USA', 'UK'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Retail Stores & Shops',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          top: false,
          child: FutureBuilder<_RetailFormMetadata>(
          future: _metadataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unable to load retail options.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        final apiClient = context.read<ApiClient>();
                        setState(() {
                          _metadataFuture = _loadMetadata(apiClient);
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

              final metadata = snapshot.data!;
              return _buildForm(metadata);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(_RetailFormMetadata metadata) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 120, 16, 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tell Us Your Retail Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17223B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Help us understand your retail vision to recommend the best spaces.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F7A8E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildLocationSection(metadata.commonCountries),
                    const SizedBox(height: 16),
                    _buildStoreTypeSection(metadata.storeTypes),
                    const SizedBox(height: 16),
                    _buildProductCategoriesSection(metadata.categories),
                    const SizedBox(height: 16),
                    _buildFloorAreaSection(),
                    const SizedBox(height: 16),
                    _buildTimelineSection(),
                    const SizedBox(height: 16),
                    _buildBudgetSection(),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Need inventory & supply chain support'),
                      value: _requiresInventorySupport,
                      onChanged: (value) => setState(() => _requiresInventorySupport = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _inputDecoration('Additional notes (optional)'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text(
                          'Submit Request',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(List<String> countries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _preferredCountry,
          items: countries
              .map(
                (country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _preferredCountry = value),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('Preferred country'),
          hint: const Text('Select country', style: TextStyle(color: Color(0xFF8A96AA))),
          validator: (value) => value == null || value.isEmpty ? 'Select a country' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _cityController,
          decoration: _inputDecoration('Preferred city'),
          validator: (value) => value == null || value.trim().isEmpty ? 'Enter a city' : null,
        ),
      ],
    );
  }

  Widget _buildStoreTypeSection(List<RetailStoreType> storeTypes) {
    return DropdownButtonFormField<RetailStoreType>(
      value: _selectedStoreType,
      items: storeTypes
          .map(
            (storeType) => DropdownMenuItem(
              value: storeType,
              child: Text(storeType.name),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedStoreType = value),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
      decoration: _inputDecoration('Store type'),
      hint: const Text('Select store type', style: TextStyle(color: Color(0xFF8A96AA))),
      validator: (value) => value == null ? 'Select a store type' : null,
    );
  }

  Widget _buildProductCategoriesSection(List<RetailProductCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product categories',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories
              .map(
                (category) => FilterChip(
                  label: Text(category.name),
                  selected: _selectedCategoryIds.contains(category.id),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategoryIds.add(category.id);
                      } else {
                        _selectedCategoryIds.remove(category.id);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
        if (_showCategoryError && _selectedCategoryIds.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Select at least one category.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFloorAreaSection() {
    return TextFormField(
      controller: _floorAreaController,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration('Floor area (in sq.ft)'),
      validator: (value) {
        final parsed = double.tryParse(value ?? '');
        if (parsed == null || parsed <= 0) {
          return 'Enter a valid floor area';
        }
        return null;
      },
    );
  }

  Widget _buildTimelineSection() {
    return TextFormField(
      controller: _timelineController,
      decoration: _inputDecoration('Target opening timeline'),
      validator: (value) => value == null || value.trim().isEmpty ? 'Enter opening timeline' : null,
    );
  }

  Widget _buildBudgetSection() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Budget amount'),
            onChanged: (value) => _budgetAmount = double.tryParse(value),
            validator: (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return 'Enter amount';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 110,
          child: DropdownButtonFormField<String>(
            value: _budgetCurrency,
            items: const [
              DropdownMenuItem(value: 'INR', child: Text('INR')),
              DropdownMenuItem(value: 'USD', child: Text('USD')),
              DropdownMenuItem(value: 'AED', child: Text('AED')),
            ],
            onChanged: (value) => setState(() => _budgetCurrency = value ?? 'INR'),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
            decoration: _inputDecoration('').copyWith(
              hintText: null,
              labelText: 'Currency',
              labelStyle: const TextStyle(fontSize: 14, color: Color(0xFF6B778C)),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            dropdownColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_selectedCategoryIds.isEmpty) {
      setState(() => _showCategoryError = true);
      return;
    }
    setState(() => _showCategoryError = false);

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final apiClient = context.read<ApiClient>();
    final requestService = RequestService(apiClient);
    final requestProvider = context.read<RequestProvider>();

    try {
      final request = await requestService.submitRetailRequest(
        preferredCountry: _preferredCountry!,
        preferredCity: _cityController.text.trim(),
        storeTypeId: _selectedStoreType!.id,
        productCategoryIds: _selectedCategoryIds.toList(),
        floorArea: double.parse(_floorAreaController.text.trim()),
        openingTimeline: _timelineController.text.trim(),
        requiresInventorySupport: _requiresInventorySupport,
        budgetAmount: _budgetAmount ?? 0,
        budgetCurrency: _budgetCurrency,
        additionalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      requestProvider.addRetailRequest(request);

      navigator.pushNamedAndRemoveUntil(
        RequestSuccessScreen.routeName,
        ModalRoute.withName(HomeScreen.routeName),
      );
    } catch (error) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to submit request. Please try again.')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF8A96AA),
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE1E7F3), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE1E7F3), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }
}

class _RetailFormMetadata {
  const _RetailFormMetadata({
    required this.storeTypes,
    required this.categories,
    required this.commonCountries,
  });

  final List<RetailStoreType> storeTypes;
  final List<RetailProductCategory> categories;
  final List<String> commonCountries;
}

