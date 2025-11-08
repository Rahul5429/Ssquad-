import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/api_client.dart';
import '../../models/country.dart';
import '../../models/cuisine.dart';
import '../../models/event_type.dart';
import '../../models/response_option.dart';
import '../../providers/banquet_request_provider.dart' show RequestProvider;
import '../../services/metadata_service.dart';
import '../../services/request_service.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';
import 'request_success_screen.dart';

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({super.key});

  static const routeName = '/banquet-form';

  @override
  State<BanquetFormScreen> createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('d MMM yyyy');

  late final Future<_MetadataBundle> _metadataFuture;

  String? _selectedEventTypeId;
  Country? _selectedCountry;
  StateProvince? _selectedState;
  City? _selectedCity;
  final List<DateTime> _eventDates = <DateTime>[];
  int _adults = 0;
  int _children = 0;
  final Set<String> _cateringPreferences = <String>{};
  final Set<String> _selectedCuisineIds = <String>{};
  String _budgetCurrency = 'INR';
  double? _budgetAmount;
  String? _selectedResponseOptionId;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<ApiClient>();
    _metadataFuture = _loadMetadata(apiClient);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<_MetadataBundle> _loadMetadata(ApiClient apiClient) async {
    final metadataService = MetadataService(apiClient);
    final results = await Future.wait([
      metadataService.fetchEventTypes(),
      metadataService.fetchCountries(),
      metadataService.fetchCuisines(),
      metadataService.fetchResponseOptions(),
    ]);

    final eventTypes = results[0] as List<EventType>;
    final countries = results[1] as List<Country>;
    final cuisines = results[2] as List<Cuisine>;
    final responseOptions = results[3] as List<ResponseOption>;

    _selectedEventTypeId = null;
    _selectedCountry = null;
    _selectedState = null;
    _selectedCity = null;
    _selectedResponseOptionId = null;

    return _MetadataBundle(
      eventTypes: eventTypes,
      countries: countries,
      cuisines: cuisines,
      responseOptions: responseOptions,
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
          'Banquets & Venues',
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
          child: FutureBuilder<_MetadataBundle>(
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
                    const Text('Unable to load required data.'),
                    const SizedBox(height: 8),
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

  Widget _buildForm(_MetadataBundle metadata) {
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
                      'Tell Us Your Venue Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17223B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Share a few details so we can match you with the perfect venue options.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F7A8E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEventTypeSection(metadata.eventTypes),
                    const SizedBox(height: 16),
                    _buildLocationSection(metadata.countries),
                    const SizedBox(height: 16),
                    _buildEventDatesSection(),
                    const SizedBox(height: 16),
                    _buildGuestsSection(),
                    const SizedBox(height: 16),
                    _buildCateringSection(),
                    const SizedBox(height: 16),
                    _buildCuisineSection(metadata.cuisines),
                    const SizedBox(height: 16),
                    _buildBudgetSection(),
                    const SizedBox(height: 16),
                    _buildResponseSection(metadata.responseOptions),
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

  Widget _buildEventTypeSection(List<EventType> eventTypes) {
    return DropdownButtonFormField<String>(
      value: _selectedEventTypeId,
      items: eventTypes
          .map(
            (type) => DropdownMenuItem(
              value: type.id,
              child: Text(type.name),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedEventTypeId = value),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
      decoration: _inputDecoration('Event Type'),
      hint: const Text('Select event type', style: TextStyle(color: Color(0xFF8A96AA))),
      validator: (value) => value == null ? 'Please select an event type' : null,
    );
  }

  Widget _buildLocationSection(List<Country> countries) {
    final states = _selectedCountry?.states ?? <StateProvince>[];
    final cities = _selectedState?.cities ?? <City>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<Country>(
          value: _selectedCountry,
          items: countries
              .map(
                (country) => DropdownMenuItem(
                  value: country,
                  child: Text(country.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedState = value?.states.isNotEmpty == true ? value!.states.first : null;
              _selectedCity = _selectedState?.cities.isNotEmpty == true ? _selectedState!.cities.first : null;
            });
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('Country'),
          hint: const Text('Select country', style: TextStyle(color: Color(0xFF8A96AA))),
          validator: (value) => value == null ? 'Please select a country' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<StateProvince>(
          value: _selectedState,
          items: states
              .map(
                (state) => DropdownMenuItem(
                  value: state,
                  child: Text(state.name),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedState = value;
              _selectedCity = value?.cities.isNotEmpty == true ? value!.cities.first : null;
            });
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('State'),
          hint: const Text('Select state', style: TextStyle(color: Color(0xFF8A96AA))),
          validator: (value) => value == null ? 'Please select a state' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<City>(
          value: _selectedCity,
          items: cities
              .map(
                (city) => DropdownMenuItem(
                  value: city,
                  child: Text(city.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('City'),
          hint: const Text('Select city', style: TextStyle(color: Color(0xFF8A96AA))),
          validator: (value) => value == null ? 'Please select a city' : null,
        ),
      ],
    );
  }

  Widget _buildEventDatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Dates',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._eventDates.map(
              (date) => Chip(
                label: Text(_dateFormat.format(date)),
                onDeleted: () => setState(() => _eventDates.remove(date)),
              ),
            ),
            ActionChip(
              label: const Text('+ add date'),
              onPressed: _addDate,
            ),
          ],
        ),
        if (_eventDates.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Please add at least one event date.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Adults',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Number of adults'),
                onChanged: (value) {
                  final parsed = int.tryParse(value) ?? 0;
                  setState(() => _adults = parsed);
                },
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter adults';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Children (optional)'),
                onChanged: (value) {
                  final parsed = int.tryParse(value) ?? 0;
                  setState(() => _children = parsed);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCateringSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catering Preference',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PreferenceTag(
                label: 'Vegetarian',
                color: const Color(0xFF2E7D32),
                isSelected: _cateringPreferences.contains('Veg'),
                onTap: () {
                  setState(() {
                    if (_cateringPreferences.contains('Veg')) {
                      _cateringPreferences.remove('Veg');
                    } else {
                      _cateringPreferences.add('Veg');
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PreferenceTag(
                label: 'Non-vegetarian',
                color: const Color(0xFFD32F2F),
                isSelected: _cateringPreferences.contains('Non-veg'),
                onTap: () {
                  setState(() {
                    if (_cateringPreferences.contains('Non-veg')) {
                      _cateringPreferences.remove('Non-veg');
                    } else {
                      _cateringPreferences.add('Non-veg');
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCuisineSection(List<Cuisine> cuisines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please select your Cuisines',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Column(
          children: cuisines
              .map(
                (cuisine) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildCuisineImage(cuisine),
                    ),
                    title: Text(
                      cuisine.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Transform.scale(
                      scale: 1.1,
                      child: Checkbox(
                        value: _selectedCuisineIds.contains(cuisine.id),
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedCuisineIds.add(cuisine.id);
                            } else {
                              _selectedCuisineIds.remove(cuisine.id);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (_selectedCuisineIds.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Select at least one cuisine.',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCuisineImage(Cuisine cuisine) {
    Widget fallback() => Container(
          width: 66,
          height: 56,
          color: const Color(0xFFF1F5FF),
        );

    final normalized = cuisine.name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    final assetPath = _cuisineAssetPaths[normalized];

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        width: 66,
        height: 56,
        fit: BoxFit.cover,
      );
    }

    return fallback();
  }

  static const Map<String, String> _cuisineAssetPaths = {
    'indian': 'assets/images/cuisines/indian.jpg',
    'italian': 'assets/images/cuisines/italian.jpeg',
    'asian': 'assets/images/cuisines/asian.jpg',
    'mexican': 'assets/images/cuisines/mexican.jpeg',
  };

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

  Widget _buildBudgetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Amount'),
                onChanged: (value) {
                  _budgetAmount = double.tryParse(value);
                },
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<String>(
                value: _budgetCurrency,
                items: const [
                  DropdownMenuItem(value: 'INR', child: Text('INR')),
                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _budgetCurrency = value);
                  }
                },
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
        ),
      ],
    );
  }

  Widget _buildResponseSection(List<ResponseOption> responseOptions) {
    return DropdownButtonFormField<String>(
      value: _selectedResponseOptionId,
      items: responseOptions
          .map(
            (option) => DropdownMenuItem(
              value: option.id,
              child: Text(option.label),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedResponseOptionId = value),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
      decoration: _inputDecoration('Get offer within (optional)'),
      hint: const Text('Select response window', style: TextStyle(color: Color(0xFF8A96AA))),
      validator: (value) => value == null ? 'Select a response time' : null,
    );
  }

  Future<void> _addDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null && !_eventDates.contains(picked)) {
      setState(() => _eventDates.add(picked));
    }
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_eventDates.isEmpty) {
      setState(() {});
      return;
    }
    if (_selectedCuisineIds.isEmpty) {
      setState(() {});
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final apiClient = context.read<ApiClient>();
    final requestService = RequestService(apiClient);
    final requestProvider = context.read<RequestProvider>();

    try {
      final request = await requestService.submitBanquetRequest(
        eventTypeId: _selectedEventTypeId!,
        country: _selectedCountry!.name,
        state: _selectedState!.name,
        city: _selectedCity!.name,
        eventDates: _eventDates,
        adults: _adults,
        children: _children,
        cateringPreferences: _cateringPreferences.toList(),
        cuisineIds: _selectedCuisineIds.toList(),
        budgetAmount: _budgetAmount ?? 0,
        budgetCurrency: _budgetCurrency,
        responseOptionId: _selectedResponseOptionId!,
        additionalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      requestProvider.addBanquetRequest(request);
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
}

class _PreferenceTag extends StatelessWidget {
  const _PreferenceTag({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.14) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(isSelected ? 0.6 : 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color.darken(0.1) : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _ColorShade on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

class _MetadataBundle {
  const _MetadataBundle({
    required this.eventTypes,
    required this.countries,
    required this.cuisines,
    required this.responseOptions,
  });

  final List<EventType> eventTypes;
  final List<Country> countries;
  final List<Cuisine> cuisines;
  final List<ResponseOption> responseOptions;
}

