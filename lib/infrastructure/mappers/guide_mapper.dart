import '../../domain/domain.dart';

class GuideMapper {
  static Guide guideJsonToEntity(Map<String, dynamic> json) => Guide(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        url: json['url'],
        description: json['description'],
      );
}
