import '../data/model/blog_post.dart';

class PostState {
  final bool loading;
  final List<BlogPost> posts;

  const PostState({this.loading = false, this.posts = const []});

  PostState copyWith({bool? loading, List<BlogPost>? posts}) {
    return PostState(
      loading: loading ?? this.loading,
      posts: posts ?? this.posts,
    );
  }
}
