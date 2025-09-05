import '../../app/data/model/category.dart';

class CategoryState {
  final List<Category> categories;
  final Category? selectedCategory;

  const CategoryState({this.categories = const [], this.selectedCategory});
}
