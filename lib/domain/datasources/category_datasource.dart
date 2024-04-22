import '/domain/domain.dart';

abstract class CategoryDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category> getCategory(int id);
  Future<Category> addCategory(String name);
  Future<Category> updateCategory(int id, String name);
  Future<void> removeCategory(int id);
}
