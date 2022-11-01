part of '../fields.dart';

class EmailField extends FormzInput<String?, String> {
  final bool? isRequired;
  final bool? isServerError;

  const EmailField.pure({this.isRequired = true, this.isServerError})
      : super.pure(null);
  const EmailField.dirty(
      {this.isRequired = true, this.isServerError, String? value})
      : super.dirty(value);

  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  String? validator(String? value) {
    if (value?.isEmpty ?? true) {
      if (isRequired!) {
        return FieldValidationError.empty.description;
      }
    } else {
      if (!_emailRegex.hasMatch(value!)) {
        return FieldValidationError.invalid.description;
      } else {
        if (isServerError ?? false) {
          return 'Email telah digunakan';
        }
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailField &&
        other.value == value &&
        other.pure == pure &&
        other.isRequired == isRequired &&
        other.isServerError == isServerError;
  }

  @override
  int get hashCode =>
      value.hashCode ^
      pure.hashCode ^
      isRequired.hashCode ^
      isServerError.hashCode;

  @override
  String toString() =>
      '$runtimeType(value: $value, pure: $pure, isRequired: $isRequired, isServerError: $isServerError)';
}
