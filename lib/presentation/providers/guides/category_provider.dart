import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final categoryRepository = CategoryRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return CategoryNotifier(
      categoryRepository: categoryRepository,
      keyValueStorageService: keyValueStorageService);
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository categoryRepository;
  final KeyValueStorageService keyValueStorageService;

  CategoryNotifier({
    required this.categoryRepository,
    required this.keyValueStorageService,
  }) : super(CategoryState());

  Future<List<Category>> getAllCategories() async {
    try {
      final categories = await categoryRepository.getAllCategories();
      return categories;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}

class CategoryState {
  final Category? category;
  final String errorMessage;

  CategoryState({this.category, this.errorMessage = ''});

  CategoryState copyWith({
    Category? category,
    String? errorMessage,
  }) =>
      CategoryState(
          category: category ?? this.category,
          errorMessage: errorMessage ?? this.errorMessage);
}
