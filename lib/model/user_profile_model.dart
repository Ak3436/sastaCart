/// =========================
/// USER PROFILE MODEL
/// =========================
/// Maps the full DummyJSON /users/:id response to a Dart object.
/// Every field used in the UI is declared here so the rest of the
/// codebase works with typed data rather than raw Maps.

class UserProfileModel {

  // ── Basic info ──────────────────────────────────────────────────
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String username;
  final int age;
  final String gender;
  final String birthDate;   // e.g. "1990-05-17"

  // ── Extra personal info ──────────────────────────────────────────
  final String university;
  final String bloodGroup;
  final String eyeColor;

  // ── Address ──────────────────────────────────────────────────────
  final AddressModel address;

  // ── Company ──────────────────────────────────────────────────────
  final CompanyModel company;

  UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.username,
    required this.age,
    required this.gender,
    required this.birthDate,
    required this.university,
    required this.bloodGroup,
    required this.eyeColor,
    required this.address,
    required this.company,
  });

  // ── Factory constructor ──────────────────────────────────────────
  /// Parses the raw JSON map returned by the API into a typed model.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id:          json['id'],
      firstName:   json['firstName'],
      lastName:    json['lastName'],
      email:       json['email'],
      phone:       json['phone'],
      image:       json['image'],
      username:    json['username'],
      age:         json['age'],
      gender:      json['gender'],
      birthDate:   json['birthDate'] ?? '',
      university:  json['university'] ?? '',
      bloodGroup:  json['bloodGroup'] ?? '',
      eyeColor:    json['eyeColor'] ?? '',
      address:     AddressModel.fromJson(
          json['address'] as Map<String, dynamic>? ?? {}),
      company:     CompanyModel.fromJson(
          json['company'] as Map<String, dynamic>? ?? {}),
    );
  }

  /// Convenience getter: full display name.
  String get fullName => '$firstName $lastName';
}

// ════════════════════════════════════════════════════════════════════
/// ADDRESS MODEL
/// Nested inside the user JSON under the "address" key.
// ════════════════════════════════════════════════════════════════════
class AddressModel {
  final String address;   // street
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressModel({
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address:    json['address']    ?? '',
      city:       json['city']       ?? '',
      state:      json['state']      ?? '',
      postalCode: json['postalCode'] ?? '',
      country:    json['country']    ?? '',
    );
  }

  /// Returns a single-line formatted address string for display.
  String get formatted =>
      '$address, $city, $state - $postalCode, $country';
}

// ════════════════════════════════════════════════════════════════════
/// COMPANY MODEL
/// Nested inside the user JSON under the "company" key.
// ════════════════════════════════════════════════════════════════════
class CompanyModel {
  final String name;
  final String department;
  final String title;         // job title
  final AddressModel address; // company address

  CompanyModel({
    required this.name,
    required this.department,
    required this.title,
    required this.address,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name:       json['name']       ?? '',
      department: json['department'] ?? '',
      title:      json['title']      ?? '',
      address:    AddressModel.fromJson(
          json['address'] as Map<String, dynamic>? ?? {}),
    );
  }
}
