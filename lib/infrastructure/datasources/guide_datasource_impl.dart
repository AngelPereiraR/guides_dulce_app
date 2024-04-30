import 'package:dio/dio.dart';
import 'package:guides_dulce_app/presentation/providers/auth/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';
import '../../main.dart' as main;

class GuideDataSourceImpl extends GuideDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<List<Guide>> getAllGuides() async {
    try {
      final response = await dio.get('/guides');

      List<Guide> guides = [];

      for (dynamic data in response.data) {
        final guide = GuideMapper.guideJsonToEntity(data);
        guides.add(guide);
      }
      return guides;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Guide>> getAllGuidesByCategoryId(int categoryId) async {
    try {
      final response = await dio.get('/guides/findAllByCategoryId/$categoryId');

      List<Guide> guides = [];

      for (dynamic data in response.data) {
        final guide = GuideMapper.guideJsonToEntity(data);
        guides.add(guide);
      }
      return guides;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Guide> getGuide(int id) async {
    try {
      final response = await dio.get('/guides/$id');

      final guide = GuideMapper.guideJsonToEntity(response.data);
      return guide;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Guide> addGuide(
    int categoryId,
    String name,
    String type,
    String description,
  ) async {
    try {
      final token = await _getToken();
      if (token != "") {
        final response = await dio.post('/guides/$categoryId/create',
            data: {'name': name, 'type': type, 'description': description},
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        final guide = GuideMapper.guideJsonToEntity(response.data);
        return guide;
      } else {
        throw InvalidToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Guide> updateGuide(
    int id,
    int categoryId,
    String name,
    String type,
    String description,
  ) async {
    try {
      final token = await _getToken();
      if (token != "") {
        final response = await dio.patch('/guides/$id',
            data: {'name': name, 'type': type, 'description': description},
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        final guide = GuideMapper.guideJsonToEntity(response.data);
        return guide;
      } else {
        throw InvalidToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> removeGuide(int id, int categoryId) async {
    try {
      final token = await _getToken();
      if (token != "") {
        await dio.delete('/guides/$categoryId/delete/$id',
            options: Options(headers: {'Authorization': 'Bearer $token'}));
      } else {
        throw InvalidToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> uploadArchive(XFile file, int id, String type) async {
    try {
      final token = await _getToken();
      if (token != "") {
        FormData formData = FormData();
        formData.files
            .add(MapEntry('file', MultipartFile.fromFileSync(file.path)));
        if (type == 'image') {
          await dio.post('/guides/uploadImage/$id',
              data: formData,
              options: Options(headers: {'Authorization': 'Bearer $token'}));
        } else {
          await dio.post('/guides/uploadVideo/$id',
              data: formData,
              options: Options(headers: {'Authorization': 'Bearer $token'}));
        }
      } else {
        throw InvalidToken();
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token inválido');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> _getToken() async {
    final auth = main.container.read(authProvider.notifier);
    return await auth.getToken();
  }
}
