import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/api_client.dart';
import '../../models/country.dart';
import '../../models/travel_metadata.dart';
import '../../providers/banquet_request_provider.dart' show RequestProvider;
import '../../services/metadata_service.dart';
import '../../services/request_service.dart';
import '../../theme/app_colors.dart';
import '../banquet/request_success_screen.dart';
import '../home/home_screen.dart';

class TravelFormScreen extends StatefulWidget {
  const TravelFormScreen({super.key});

  static const routeName = '/travel-form';

  @override
  State<TravelFormScreen> createState() => _TravelFormScreenState();
}

class _TravelFormScreenState extends State<TravelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('d MMM yyyy');

  late Future<_TravelFormMetadata> _metadataFuture;

  Country? _selectedCountry;
  StateProvince? _selectedState;
  City? _selectedCity;
  TravelPurpose? _selectedPurpose;
  AccommodationType? _selectedAccommodationType;
  final Set<String> _selectedAmenityIds = <String>{};
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 1;
  int _children = 0;
  int _roomsNeeded = 1;
  double? _budgetAmount;
  String _budgetCurrency = 'INR';
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

  Future<_TravelFormMetadata> _loadMetadata(ApiClient apiClient) async {
    final metadataService = MetadataService(apiClient);
    final countriesFuture = metadataService.fetchCountries();
    final travelMetadataFuture = metadataService.fetchTravelMetadata();

    final countries = await countriesFuture;
    final travelMetadata = await travelMetadataFuture;

    _selectedCountry = null;
    _selectedState = null;
    _selectedCity = null;
    _selectedPurpose = null;
    _selectedAccommodationType = null;

    return _TravelFormMetadata(
      countries: countries,
      purposes: travelMetadata.purposes,
      accommodationTypes: travelMetadata.accommodationTypes,
      amenities: travelMetadata.amenities,
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
          'Travel & Stay',
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
          child: FutureBuilder<_TravelFormMetadata>(
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
                    const Text('Unable to load travel options.'),
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

  Widget _buildForm(_TravelFormMetadata metadata) {
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
                      'Tell Us Your Stay Requirements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17223B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Share your stay preferences to receive curated travel options.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6F7A8E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDestinationSection(metadata.countries),
                    const SizedBox(height: 16),
                    _buildPurposeSection(metadata.purposes, metadata.accommodationTypes),
                    const SizedBox(height: 16),
                    _buildTimelineSection(),
                    const SizedBox(height: 16),
                    _buildGuestRoomsSection(),
                    const SizedBox(height: 16),
                    _buildAmenitiesSection(metadata.amenities),
                    const SizedBox(height: 16),
                    _buildBudgetSection(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _inputDecoration('Special requests (optional)'),
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

  Widget _buildDestinationSection(List<Country> countries) {
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
          decoration: _inputDecoration('Destination Country').copyWith(
            hintText: 'Select country',
            hintStyle: const TextStyle(color: Color(0xFF8A96AA)),
          ),
          validator: (value) => value == null ? 'Select a country' : null,
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
          decoration: _inputDecoration('State/Region').copyWith(
            hintText: 'Select state/region',
            hintStyle: const TextStyle(color: Color(0xFF8A96AA)),
          ),
          validator: (value) => value == null ? 'Select a state/region' : null,
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
          decoration: _inputDecoration('City').copyWith(
            hintText: 'Select city',
            hintStyle: const TextStyle(color: Color(0xFF8A96AA)),
          ),
          validator: (value) => value == null ? 'Select a city' : null,
        ),
      ],
    );
  }

  Widget _buildPurposeSection(
    List<TravelPurpose> purposes,
    List<AccommodationType> accommodationTypes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<TravelPurpose>(
          value: _selectedPurpose,
          items: purposes
              .map(
                (purpose) => DropdownMenuItem(
                  value: purpose,
                  child: Text(purpose.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedPurpose = value),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('Purpose of travel').copyWith(
            hintText: 'Select purpose',
            hintStyle: const TextStyle(color: Color(0xFF8A96AA)),
          ),
          validator: (value) => value == null ? 'Select a purpose' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<AccommodationType>(
          value: _selectedAccommodationType,
          items: accommodationTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedAccommodationType = value),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF5B6A86)),
          decoration: _inputDecoration('Accommodation type').copyWith(
            hintText: 'Select accommodation',
            hintStyle: const TextStyle(color: Color(0xFF8A96AA)),
          ),
          validator: (value) => value == null ? 'Select an accommodation type' : null,
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stay Dates',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _pickDate(isCheckIn: true),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: Color(0xFFE1E7F3), width: 1.2),
                  backgroundColor: const Color(0xFFF7F9FC),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _checkIn != null ? _dateFormat.format(_checkIn!) : 'Check-in date',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _pickDate(isCheckIn: false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: const BorderSide(color: Color(0xFFE1E7F3), width: 1.2),
                  backgroundColor: const Color(0xFFF7F9FC),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _checkOut != null ? _dateFormat.format(_checkOut!) : 'Check-out date',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_timelineError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _timelineError!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildGuestRoomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guests & Rooms',
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
                onChanged: (value) => setState(() => _adults = int.tryParse(value) ?? 1),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 1) {
                    return 'At least 1 adult';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: '',
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Children (optional)'),
                onChanged: (value) => setState(() => _children = int.tryParse(value) ?? 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: '',
          keyboardType: TextInputType.number,
          decoration: _inputDecoration('Rooms required'),
          onChanged: (value) => setState(() => _roomsNeeded = int.tryParse(value) ?? 1),
          validator: (value) {
            final parsed = int.tryParse(value ?? '');
            if (parsed == null || parsed < 1) {
              return 'Enter rooms';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection(List<TravelAmenity> amenities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities Needed',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: amenities
              .map(
                (amenity) => FilterChip(
                  label: Text(amenity.name),
                  selected: _selectedAmenityIds.contains(amenity.id),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenityIds.add(amenity.id);
                      } else {
                        _selectedAmenityIds.remove(amenity.id);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
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
                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
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
        ),
      ],
    );
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

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final initial = isCheckIn ? (_checkIn ?? now) : (_checkOut ?? now.add(const Duration(days: 1)));
    final firstDate = isCheckIn ? now : (_checkIn ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut != null && !_checkOut!.isAfter(_checkIn!)) {
            _checkOut = _checkIn!.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  String? get _timelineError {
    if (_checkIn == null || _checkOut == null) {
      return 'Select both check-in and check-out dates';
    }
    if (!_checkOut!.isAfter(_checkIn!)) {
      return 'Check-out must be after check-in';
    }
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    if (_timelineError != null) {
      setState(() {});
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final apiClient = context.read<ApiClient>();
    final requestService = RequestService(apiClient);
    final requestProvider = context.read<RequestProvider>();

    try {
      final request = await requestService.submitTravelRequest(
        destinationCountry: _selectedCountry!.name,
        destinationCity: _selectedCity!.name,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        adults: _adults,
        children: _children,
        roomsNeeded: _roomsNeeded,
        purposeId: _selectedPurpose!.id,
        accommodationTypeId: _selectedAccommodationType!.id,
        amenityIds: _selectedAmenityIds.toList(),
        budgetAmount: _budgetAmount ?? 0,
        budgetCurrency: _budgetCurrency,
        additionalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      requestProvider.addTravelRequest(request);

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

class _TravelFormMetadata {
  const _TravelFormMetadata({
    required this.countries,
    required this.purposes,
    required this.accommodationTypes,
    required this.amenities,
  });

  final List<Country> countries;
  final List<TravelPurpose> purposes;
  final List<AccommodationType> accommodationTypes;
  final List<TravelAmenity> amenities;
}

