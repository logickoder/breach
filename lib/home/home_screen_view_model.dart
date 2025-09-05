import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app/data/api_client.dart';
import '../app/data/message_from_error.dart';
import '../app/data/model/category.dart';
import '../app/logger.dart';
import '../auth/domain/usecase.dart';
import '../onboarding/domain/usecase.dart';
import 'data/model/blog_post.dart';
import 'domain/category_state.dart';
import 'domain/post_state.dart';

class HomeScreenViewModel {
  HomeScreenViewModel() {
    _loadInitialData();
    _connectToWebSocket();
  }

  final postState = ValueNotifier(const PostState());
  final streamState = ValueNotifier(const PostState());
  final categoryState = ValueNotifier(const CategoryState());

  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;

  void _loadInitialData() async {
    await _loadUserInterests();
    await loadBlogPosts();
  }

  Future<void> _loadUserInterests() async {
    final interests = await OnboardingUseCase.getSavedInterests();
    List<Category> categories = [];
    for (final interest in interests) {
      final category = interest.category;
      if (categories.any((c) => c.id == category.id)) {
        continue;
      }
      categories.add(category);
    }
    categoryState.value = CategoryState(categories: categories);
  }

  void selectCategory(Category? category) {
    final selectedCategory = categoryState.value.selectedCategory;
    if (selectedCategory != category) {
      categoryState.value = CategoryState(
        categories: categoryState.value.categories,
        selectedCategory: category,
      );
      loadBlogPosts();
    }
  }

  Future<void> loadBlogPosts() async {
    postState.value = const PostState(loading: true);

    try {
      String endpoint = '/blog/posts';
      final selectedCategory = categoryState.value.selectedCategory;
      if (selectedCategory != null) {
        endpoint += '?categoryId=${selectedCategory.id}';
      }

      final response = await apiClient.get(endpoint);
      final posts = (response.data as List)
          .map((e) => BlogPost.fromJson(e))
          .toList();
      postState.value = PostState(posts: posts);
    } catch (error, stackTrace) {
      toastification.show(
        title: Text('Error loading posts'),
        description: Text(
          messageFromError(error: error, stackTrace: stackTrace),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error,
      );
    } finally {
      postState.value = postState.value.copyWith(loading: false);
    }
  }

  void _connectToWebSocket() async {
    try {
      streamState.value = const PostState(loading: true);

      final creds = await AuthUseCase.getCredentials();
      _webSocketChannel = WebSocketChannel.connect(
        Uri.parse('wss://breach-api-ws.qa.mvm-tech.xyz?token=${creds?.token}'),
      );

      _webSocketSubscription = _webSocketChannel!.stream.listen(
        _handleWebSocketMessage,
        onError: _handleWebSocketError,
        onDone: _handleWebSocketClosed,
      );
    } catch (error, stackTrace) {
      logger.e(
        'WebSocket connection error',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      streamState.value = streamState.value.copyWith(loading: false);
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final model = BlogPost.fromJson(data);

      final streams = List<BlogPost>.from(streamState.value.posts);
      final index = streams.indexWhere((s) => s.id == model.id);
      if (index != -1) {
        streams[index] = model;
      } else {
        streams.add(model);
      }

      streamState.value = PostState(posts: streams);
    } catch (error, stackTrace) {
      logger.e(
        'Error processing WebSocket message',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleWebSocketError(dynamic error) {
    debugPrint('WebSocket error: $error');

    logger.e(
      'WebSocket error',
      error: error,
      stackTrace: StackTrace.current,
    );
    _reconnectWebSocket();
  }

  void _handleWebSocketClosed() {
    logger.d('WebSocket connection closed');
    _reconnectWebSocket();
  }

  void _reconnectWebSocket() {
    Timer(const Duration(seconds: 5), () {
      if (_webSocketChannel?.closeCode != null) {
        _connectToWebSocket();
      }
    });
  }

  Future<void> refresh() {
    streamState.value = const PostState();
    return loadBlogPosts();
  }

  void dispose() {
    postState.dispose();
    streamState.dispose();
    categoryState.dispose();
    _webSocketSubscription?.cancel();
    _webSocketChannel?.sink.close();
  }
}
