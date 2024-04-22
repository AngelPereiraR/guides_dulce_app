import '../../domain/domain.dart';
import '../infrastructure.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl({CategoryDataSource? dataSource})
      : dataSource = dataSource ?? CategoryDataSourceImpl();

  @override
  Future<List<Category>> getAllCategories() {
    return dataSource.getAllCategories();
  }

  @override
  Future<Category> getCategory(int id) {
    return dataSource.getCategory(id);
  }

  @override
  Future<Category> addCategory(String name) {
    return dataSource.addCategory(name);
  }

  @override
  Future<Category> updateCategory(int id, String name) {
    return dataSource.updateCategory(id, name);
  }

  @override
  Future<void> removeCategory(int id) {
    return dataSource.removeCategory(id);
  }
}
