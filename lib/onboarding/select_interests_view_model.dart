import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../app/data/api_client.dart';
import '../app/data/message_from_error.dart';
import '../app/data/model/category.dart';
import '../auth/domain/usecase.dart';

class SelectInterestsViewModel extends ChangeNotifier {
  SelectInterestsViewModel() {
    _loadInterests();
  }

  var _loading = false;

  var _initializing = false;

  var _buttonEnabled = false;

  List<Category> _categories = [];

  final Set<int> _selectedCategoryIds = {};

  bool get loading => _loading;

  bool get initializing => _initializing;

  bool get buttonEnabled => _buttonEnabled;

  List<Category> get categories => _categories;

  bool isSelected(int categoryId) => _selectedCategoryIds.contains(categoryId);

  void toggleCategory(int categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    _buttonEnabled = _selectedCategoryIds.isNotEmpty;
    notifyListeners();
  }

  Future<String?> submit() async {
    if (_loading) return null;

    try {
      _loading = true;
      notifyListeners();

      final creds = await AuthUseCase.getCredentials();
      if (creds == null) {
        return 'User not logged in';
      }

      await apiClient.post(
        '/users/${creds.userId}/interests',
        data: {
          'interests': _selectedCategoryIds.toList(),
        },
      );

      return null;
    } catch (e, stackTrace) {
      return messageFromError(error: e, stackTrace: stackTrace);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _loadInterests() async {
    _initializing = true;
    notifyListeners();

    try {
      final response = await apiClient.get('/blog/categories');
      _categories = (response.data as List)
          .map((e) => Category.fromJson(e))
          .toList();
    } catch (error, stackTrace) {
      toastification.show(
        title: Text('Error fetching categories'),
        description: Text(
          messageFromError(error: error, stackTrace: stackTrace),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error,
      );
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }
}
