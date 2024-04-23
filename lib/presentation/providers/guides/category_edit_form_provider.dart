import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../infrastructure/infrastructure.dart';

//! 3 - StateNotifierProvider - consume afuera
final categoryEditFormProvider = StateNotifierProvider.autoDispose<
    CategoryEditFormNotifier, CategoryEditFormState>((ref) {
  final categoryRepository = CategoryRepositoryImpl();

  return CategoryEditFormNotifier(categoryRepository: categoryRepository);
});

//! 2 - Como implementamos un notifier
class CategoryEditFormNotifier extends StateNotifier<CategoryEditFormState> {
  final CategoryRepositoryImpl categoryRepository;

  CategoryEditFormNotifier({
    required this.categoryRepository,
  }) : super(CategoryEditFormState());

  onNameChanged(String value) {
    final newName = Name.dirty(value);

    if (!mounted) {
      return;
    }

    state = state.copyWith(name: newName, isValid: Formz.validate([newName]));
  }

  Future<bool> onFormSubmit(int id) async {
    _touchEveryField();

    if (!state.isValid) return false;

    state = state.copyWith(isPosting: true);

    await categoryRepository.updateCategory(id, state.name.value);

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
class CategoryEditFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;

  CategoryEditFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
  });

  CategoryEditFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
  }) =>
      CategoryEditFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
      );

  @override
  String toString() {
    return '''
  CategoryEditFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    name: $name
''';
  }
}
