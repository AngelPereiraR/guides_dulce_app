import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../infrastructure/infrastructure.dart';

//! 3 - StateNotifierProvider - consume afuera
final guideEditFormProvider = StateNotifierProvider.autoDispose<
    GuideEditFormNotifier, GuideEditFormState>((ref) {
  final guideRepository = GuideRepositoryImpl();

  return GuideEditFormNotifier(guideRepository: guideRepository);
});

//! 2 - Como implementamos un notifier
class GuideEditFormNotifier extends StateNotifier<GuideEditFormState> {
  final GuideRepositoryImpl guideRepository;

  GuideEditFormNotifier({
    required this.guideRepository,
  }) : super(GuideEditFormState());

  onNameChanged(String value) {
    final newName = Name.dirty(value);

    if (!mounted) {
      return;
    }

    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.description, state.type]),
    );
  }

  onTypeChanged(String value) {
    final newType = Type.dirty(value);

    if (!mounted) {
      return;
    }

    state = state.copyWith(
      type: newType,
      isValid: Formz.validate([newType, state.description, state.name]),
    );
  }

  onDescriptionChanged(String value) {
    final newDescription = Description.dirty(value);

    if (!mounted) {
      return;
    }

    state = state.copyWith(
      description: newDescription,
      isValid: Formz.validate([newDescription, state.name, state.type]),
    );
  }

  Future<bool> onFormSubmit(int id, int categoryId) async {
    _touchEveryField();

    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);

    await guideRepository.updateGuide(
      id,
      categoryId,
      state.name.value,
      state.type.value,
      state.description.value,
    );

    if (!mounted) {
      return false;
    }

    state = state.copyWith(isPosting: false);

    return true;
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final type = Type.dirty(state.type.value);
    final description = Description.dirty(state.description.value);

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      type: type,
      description: description,
      isValid: Formz.validate([name, type, description]),
    );
  }
}

//! 1 - State del provider
class GuideEditFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Type type;
  final Description description;

  GuideEditFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.name = const Name.pure(),
      this.type = const Type.pure(),
      this.description = const Description.pure()});

  GuideEditFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Type? type,
    Description? description,
  }) =>
      GuideEditFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
      );

  @override
  String toString() {
    return '''
  GuideEditFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    name: $name
    type: $type
    description: $description
''';
  }
}
