import '../../domain/domain.dart';

class CategoryMapper {
  static Category categoryJsonToEntity(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
      );
}
