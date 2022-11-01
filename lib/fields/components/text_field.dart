part of '../fields.dart';

class TextField extends FormzInput<String?, String> {
  final int min;
  final int max;
  final bool isRequired;

  const TextField.pure({
    this.min = 3,
    this.max = 100,
    this.isRequired = true,
  }) : super.pure(null);

  const TextField.dirty({
    this.min = 3,
    this.max = 100,
    this.isRequired = true,
    String? value,
  }) : super.dirty(value);

  @override
  String? validator(String? value) {
    if (value?.isEmpty ?? true) {
      if (isRequired) {
        return FieldValidationError.empty.description;
      }
    } else {
      if (value!.length < min) {
        return '${FieldValidationError.min.description} $min karakter';
      } else if (value.length > max) {
        return '${FieldValidationError.max.description} $max karakter';
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TextField &&
        other.value == value &&
        other.pure == pure &&
        other.isRequired == isRequired &&
        other.min == min &&
        other.max == max;
  }

  @override
  int get hashCode =>
      value.hashCode ^
      pure.hashCode ^
      isRequired.hashCode ^
      min.hashCode ^
      max.hashCode;

  @override
  String toString() =>
      '$runtimeType(value: $value, pure: $pure, isRequired: $isRequired, min: $min, max: $max)';
}
