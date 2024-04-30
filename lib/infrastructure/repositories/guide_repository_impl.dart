import 'package:image_picker/image_picker.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class GuideRepositoryImpl extends GuideRepository {
  final GuideDataSource dataSource;

  GuideRepositoryImpl({GuideDataSource? dataSource})
      : dataSource = dataSource ?? GuideDataSourceImpl();

  @override
  Future<List<Guide>> getAllGuides() {
    return dataSource.getAllGuides();
  }

  @override
  Future<Guide> getGuide(int id) {
    return dataSource.getGuide(id);
  }

  @override
  Future<List<Guide>> getAllGuidesByCategoryId(int categoryId) {
    return dataSource.getAllGuidesByCategoryId(categoryId);
  }

  @override
  Future<Guide> addGuide(
      int categoryId, String name, String type, String description) {
    return dataSource.addGuide(categoryId, name, type, description);
  }

  @override
  Future<Guide> updateGuide(
      int id, int categoryId, String name, String type, String description) {
    return dataSource.updateGuide(id, categoryId, name, type, description);
  }

  @override
  Future<void> removeGuide(int id, int categoryId) {
    return dataSource.removeGuide(id, categoryId);
  }

  @override
  Future<void> uploadArchive(XFile file, int id, String type) {
    return dataSource.uploadArchive(file, id, type);
  }
}
