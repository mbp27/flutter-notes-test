part of '../fields.dart';

class DateTimeField extends FormzInput<DateTime?, String> {
  final bool isRequired;

  const DateTimeField.pure({this.isRequired = true}) : super.pure(null);
  const DateTimeField.dirty({this.isRequired = true, DateTime? value})
      : super.dirty(value);

  @override
  String? validator(DateTime? value) {
    if (value == null) {
      if (isRequired) {
        return FieldValidationError.empty.description;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateTimeField &&
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
