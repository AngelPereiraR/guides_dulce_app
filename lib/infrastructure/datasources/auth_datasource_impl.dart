import 'package:dio/dio.dart';

import '../../config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
