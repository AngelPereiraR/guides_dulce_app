import '../domain.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category> getCategory(int id);
  Future<Category> addCategory(String name);
  Future<Category> updateCategory(int id, String name);
  Future<void> removeCategory(int id);
}
