import 'package:dio/dio.dart';
import 'package:guides_dulce_app/presentation/providers/auth/auth_provider.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';
import '../../main.dart' as main;

class CategoryDataSourceImpl extends CategoryDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await dio.get('/categories');

      List<Category> categories = [];

      for (dynamic data in response.data) {
        final category = CategoryMapper.categoryJsonToEntity(data);
        categories.add(category);
      }
      return categories;
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
  Future<Category> getCategory(int id) async {
    try {
      final response = await dio.get('/categories/$id');

      final category = CategoryMapper.categoryJsonToEntity(response.data);
      return category;
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
  Future<Category> addCategory(String name) async {
    try {
      final token = await _getToken();
      if (token != "") {
        final response = await dio.post('/categories',
            data: {'name': name},
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        final category = CategoryMapper.categoryJsonToEntity(response.data);
        return category;
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
  Future<Category> updateCategory(int id, String name) async {
    try {
      final token = await _getToken();
      if (token != "") {
        final response = await dio.patch('/categories/$id',
            data: {'name': name},
            options: Options(headers: {'Authorization': 'Bearer $token'}));

        final category = CategoryMapper.categoryJsonToEntity(response.data);
        return category;
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
  Future<void> removeCategory(int id) async {
    try {
      final token = await _getToken();
      if (token != "") {
        await dio.delete('/categories/$id',
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

  Future<String> _getToken() async {
    final auth = main.container.read(authProvider.notifier);
    return await auth.getToken();
  }
}
