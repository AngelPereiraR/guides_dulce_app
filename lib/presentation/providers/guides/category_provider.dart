import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  final categoryRepository = CategoryRepositoryImpl();

  return CategoryNotifier(
    categoryRepository: categoryRepository,
  );
});

class CategoryNotifier extends StateNotifier<CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryNotifier({
    required this.categoryRepository,
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

  Future<bool> deleteCategory(int id) async {
    try {
      await categoryRepository.removeCategory(id);
      return true;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<Category> getCategory(int id) async {
    try {
      final category = await categoryRepository.getCategory(id);
      return category;
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
