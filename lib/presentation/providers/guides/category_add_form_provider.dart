import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../infrastructure/infrastructure.dart';

//! 3 - StateNotifierProvider - consume afuera
final categoryAddFormProvider = StateNotifierProvider.autoDispose<
    CategoryAddFormNotifier, CategoryAddFormState>((ref) {
  final categoryRepository = CategoryRepositoryImpl();

  return CategoryAddFormNotifier(categoryRepository: categoryRepository);
});

//! 2 - Como implementamos un notifier
class CategoryAddFormNotifier extends StateNotifier<CategoryAddFormState> {
  final CategoryRepositoryImpl categoryRepository;

  CategoryAddFormNotifier({
    required this.categoryRepository,
  }) : super(CategoryAddFormState());

  onNameChanged(String value) {
    final newName = Name.dirty(value);

    if (!mounted) {
      return;
    }

    state = state.copyWith(name: newName, isValid: Formz.validate([newName]));
  }

  Future<bool> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);

    await categoryRepository.addCategory(state.name.value);

    if (!mounted) {
      return false;
    }

    state = state.copyWith(isPosting: false);

    return true;
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);

    state = state.copyWith(
        isFormPosted: true, name: name, isValid: Formz.validate([name]));
  }
}

//! 1 - State del provider
class CategoryAddFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;

  CategoryAddFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.name = const Name.pure()});

  CategoryAddFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
  }) =>
      CategoryAddFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
      );

  @override
  String toString() {
    return '''
  CategoryAddFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    name: $name
''';
  }
}
