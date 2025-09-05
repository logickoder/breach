import '../../../app/data/model/category.dart';

class BlogPost {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final Category category;
  final DateTime createdAt;
  final String author;
  final String series;

  const BlogPost({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.author,
    required this.series,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      category: Category.fromJson(json['category']),
      createdAt: DateTime.parse(json['createdAt']),
      author: json['author']['name'] ?? 'Unknown',
      series: json['series']['name'] ?? 'Unknown',
    );
  }
}
