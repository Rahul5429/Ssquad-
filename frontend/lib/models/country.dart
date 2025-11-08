class City {
  const City({required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name'] as String? ?? '');
  }

  final String name;
}

class StateProvince {
  const StateProvince({
    required this.name,
    required this.cities,
  });

  factory StateProvince.fromJson(Map<String, dynamic> json) {
    final citiesJson = json['cities'] as List<dynamic>? ?? <dynamic>[];
    return StateProvince(
      name: json['name'] as String? ?? '',
      cities: citiesJson.map((city) => City.fromJson(city as Map<String, dynamic>)).toList(),
    );
  }

  final String name;
  final List<City> cities;
}

class Country {
  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.states,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final statesJson = json['states'] as List<dynamic>? ?? <dynamic>[];
    return Country(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      states:
          statesJson.map((state) => StateProvince.fromJson(state as Map<String, dynamic>)).toList(),
    );
  }

  final String id;
  final String name;
  final String code;
  final List<StateProvince> states;
}

