import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../infrastructure/infrastructure.dart';

//! 3 - StateNotifierProvider - consume afuera
final guideAddImageVideoProvider = StateNotifierProvider.autoDispose<
    GuideAddImageVideoNotifier, GuideAddImageVideoState>((ref) {
  final guideRepository = GuideRepositoryImpl();

  return GuideAddImageVideoNotifier(guideRepository: guideRepository);
});

//! 2 - Como implementamos un notifier
class GuideAddImageVideoNotifier
    extends StateNotifier<GuideAddImageVideoState> {
  final GuideRepositoryImpl guideRepository;

  GuideAddImageVideoNotifier({
    required this.guideRepository,
  }) : super(GuideAddImageVideoState());

  onImageVideoChanged(XFile file) {
    final newImageVideo = ImageVideo.dirty(file);

    if (!mounted) {
      return;
    }

    state = state.copyWith(
        file: newImageVideo, isValid: Formz.validate([newImageVideo]));
  }

  setImageVideoError(String? error) {
    state = state.copyWith(error: error);
  }

  setImageVideoType(String type) {
    state = state.copyWith(type: type);
  }

  Future<bool> onFormSubmit(int id, String type) async {
    _touchEveryField();

    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);

    await guideRepository.uploadArchive(state.file.value, id, type);

    if (!mounted) {
      return false;
    }

    state = state.copyWith(isPosting: false);

    return true;
  }

  _touchEveryField() {
    final file = ImageVideo.dirty(state.file.value);

    state = state.copyWith(
        isFormPosted: true, file: file, isValid: Formz.validate([file]));
  }
}

//! 1 - State del provider
class GuideAddImageVideoState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final ImageVideo file;
  final String error;
  final String type;

  GuideAddImageVideoState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    ImageVideo? file,
    this.error = '',
    this.type = '',
  }) : file = file ?? ImageVideo.pure(XFile(''));

  GuideAddImageVideoState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    ImageVideo? file,
    String? error,
    String? type,
  }) =>
      GuideAddImageVideoState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        file: file ?? this.file,
        error: error ?? this.error,
        type: type ?? this.type,
      );

  @override
  String toString() {
    return '''
  GuideAddImageVideoState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    file: $file
    error: $error
    type: $type
''';
  }
}
