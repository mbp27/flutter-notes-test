part of '../fields.dart';

class DropdownField<T extends Object> extends FormzInput<T?, String> {
  final bool isRequired;

  const DropdownField.pure({this.isRequired = true}) : super.pure(null);
  const DropdownField.dirty({this.isRequired = true, T? value})
      : super.dirty(value);

  @override
  String? validator(T? value) {
    if (value == null || (value is int && value <= 0)) {
      if (isRequired) {
        return FieldValidationError.empty.description;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DropdownField<T> &&
        other.value == value &&
        other.pure == pure &&
        other.isRequired == isRequired;
  }

  @override
  int get hashCode => value.hashCode ^ pure.hashCode ^ isRequired.hashCode;

  @override
  String toString() =>
      '$runtimeType(value: $value, pure: $pure, isRequired: $isRequired)';
}
