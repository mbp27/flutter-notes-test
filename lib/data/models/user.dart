import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

enum Gender { male, female }

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? password;
  final String? profilePicture;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.password,
    this.profilePicture,
  });

  /// Empty user which represents an unauthenticated user.
  static const User empty = User(id: 0);

  String get fullname => '$firstName $lastName';

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? dateOfBirth,
    Gender? gender,
    String? password,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(
        dateOfBirth ?? DateTime(1999, 1, 1),
      ),
      'gender': gender?.name.toUpperCase(),
      'password': password,
      'profilePicture': profilePicture,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id']?.toInt(),
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'])
          : null,
      gender: map['gender'] != null
          ? Gender.values.singleWhereOrNull(
              (element) => element.name.toUpperCase() == map['gender'])
          : null,
      password: map['password'],
      profilePicture: map['profilePicture'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, email: $email, dateOfBirth: $dateOfBirth, gender: $gender, password: $password, profilePicture: $profilePicture)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.password == password &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        password.hashCode ^
        profilePicture.hashCode;
  }
}
