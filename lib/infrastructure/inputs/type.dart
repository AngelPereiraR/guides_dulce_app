import 'package:formz/formz.dart';

// Define input validation errors
enum TypeError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Type extends FormzInput<String, TypeError> {
  // Call super.pure to represent an unmodified form input.
  const Type.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Type.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TypeError.empty) return 'El campo es requerido';
    if (displayError == TypeError.format) {
      return 'El campo no es "image" o "video"';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TypeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TypeError.empty;
    if (value != 'image' && value != 'video') return TypeError.format;

    return null;
  }
}
