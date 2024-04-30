import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

// Define input validation errors
enum ImageVideoError { empty, format }

// Extend FormzInput and provide the input type and error type.
class ImageVideo extends FormzInput<XFile, ImageVideoError> {
  // Call super.pure to represent an unmodified form input.
  ImageVideo.pure(XFile xFile) : super.pure(XFile(''));

  // Call super.dirty to represent a modified form input.
  const ImageVideo.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ImageVideoError.empty) return 'El campo es requerido';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  ImageVideoError? validator(XFile value) {
    if (value.name.isEmpty || value.name.trim().isEmpty) {
      return ImageVideoError.empty;
    }

    return null;
  }
}
