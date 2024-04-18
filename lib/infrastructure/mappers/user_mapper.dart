import '../../domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        password: json['password'],
        token: json['token'] ?? '',
      );
}
