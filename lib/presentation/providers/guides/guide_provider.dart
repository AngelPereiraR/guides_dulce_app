import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

final guideProvider = StateNotifierProvider<GuideNotifier, GuideState>((ref) {
  final guideRepository = GuideRepositoryImpl();

  return GuideNotifier(guideRepository: guideRepository);
});

class GuideNotifier extends StateNotifier<GuideState> {
  final GuideRepository guideRepository;

  GuideNotifier({
    required this.guideRepository,
  }) : super(GuideState());

  Future<List<Guide>> getAllGuides() async {
    try {
      final categories = await guideRepository.getAllGuides();
      return categories;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Guide>> getAllGuidesByCategoryId(int categoryId) async {
    try {
      final categories =
          await guideRepository.getAllGuidesByCategoryId(categoryId);
      return categories;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteGuide(int id, int categoryId) async {
    try {
      await guideRepository.removeGuide(id, categoryId);
      return true;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<Guide> getGuide(int id) async {
    try {
      final guide = await guideRepository.getGuide(id);
      return guide;
    } on CustomError catch (e) {
      throw Exception(e.message);
    } catch (e) {
      rethrow;
    }
  }
}

class GuideState {
  final Guide? guide;
  final String errorMessage;

  GuideState({this.guide, this.errorMessage = ''});

  GuideState copyWith({
    Guide? guide,
    String? errorMessage,
  }) =>
      GuideState(
          guide: guide ?? this.guide,
          errorMessage: errorMessage ?? this.errorMessage);
}
