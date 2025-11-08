class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phone;

  AppUser copyWith({
    String? name,
    String? phone,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
    );
  }
}

