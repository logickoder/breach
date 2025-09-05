import '../../../app/data/model/category.dart';

class Interest {
  final int id;
  final Category category;

  const Interest({required this.id, required this.category});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      category: Category.fromJson(json['category']),
    );
  }
}
