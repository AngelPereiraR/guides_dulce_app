import 'dart:io';

import '/domain/domain.dart';

abstract class GuideDataSource {
  Future<List<Guide>> getAllGuides();
  Future<List<Guide>> getAllGuidesByCategoryId(int categoryId);
  Future<Guide> getGuide(int id);
  Future<Guide> addGuide(
    int categoryId,
    String name,
    String type,
    String description,
  );
  Future<Guide> updateGuide(
    int id,
    int categoryId,
    String name,
    String type,
    String description,
  );
  Future<void> removeGuide(int id, int categoryId);
  Future<void> uploadArchive(
    File file,
    int id,
  );
}
