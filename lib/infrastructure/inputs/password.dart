import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordError { empty, length, format }

enum ConfirmPasswordError { empty, length, format, confirm }

// Extend FormzInput and provide the input type and error type.
class Password extends FormzInput<String, PasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );

  // Call super.pure to represent an unmodified form input.
  const Password.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Password.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordError.empty) return 'El campo es requerido';
    if (displayError == PasswordError.length) return 'Mínimo 6 caracteres';
    if (displayError == PasswordError.format) {
      return 'Debe de tener Mayúscula, letras y un número';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordError.format;

    return null;
  }
}

class ConfirmPassword extends FormzInput<String, dynamic> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );
  final String password;

  const ConfirmPassword.pure(this.password) : super.pure('');
  const ConfirmPassword.dirty(this.password, [String value = ''])
      : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ConfirmPasswordError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == ConfirmPasswordError.length) {
      return 'Mínimo 6 caracteres';
    }
    if (displayError == ConfirmPasswordError.confirm) {
      return 'Las contraseñas no coinciden';
    }
    if (displayError == ConfirmPasswordError.format) {
      return 'Debe de tener Mayúscula, letras y un número';
    }

    return null;
  }

  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return ConfirmPasswordError.empty;
    }
    if (value.length < 6) return ConfirmPasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return ConfirmPasswordError.format;
    if (value != password) return ConfirmPasswordError.confirm;

    return null;
  }
}
