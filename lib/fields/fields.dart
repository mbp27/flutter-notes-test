import 'package:formz/formz.dart';

part 'components/datetime_field.dart';
part 'components/dropdown_field.dart';
part 'components/email_field.dart';
part 'components/text_field.dart';

enum FieldValidationError {
  empty,
  min,
  max,
  invalid,
}

extension SelectedFieldValidationError on FieldValidationError? {
  String? get description {
    switch (this) {
      case FieldValidationError.empty:
        return 'Tidak boleh kosong';
      case FieldValidationError.min:
        return 'Tidak boleh kurang dari';
      case FieldValidationError.max:
        return 'Tidak boleh lebih dari';
      case FieldValidationError.invalid:
        return 'Tidak valid';
      default:
        return null;
    }
  }
}
