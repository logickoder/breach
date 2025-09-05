import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/assets.dart';
import '../app/theme/colors.dart';
import 'components/category_filter_chip.dart';
import 'components/post_card.dart';
import 'components/stream_card.dart';
import 'home_screen_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final HomeScreenViewModel _viewModel;
  late final AnimationController _postsAnimationController;
  late final AnimationController _streamsAnimationController;
  late final Animation<double> _postsSlideAnimation;
  late final Animation<double> _streamsSlideAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeScreenViewModel();

    _postsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _streamsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _postsSlideAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _postsAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _streamsSlideAnimation =
        Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _streamsAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _viewModel.postState.addListener(_onPostsChanged);
    _viewModel.streamState.addListener(_onStreamsChanged);

    Future.delayed(const Duration(milliseconds: 300), () {
      _postsAnimationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _streamsAnimationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.ghostWhite,
      body: RefreshIndicator(
        onRefresh: _viewModel.refresh,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: colors.ghostWhite,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: SvgPicture.asset(AppAssets.logoIcon),
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              ),
            ),

            _buildCategoryFilter(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Recommended for You',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colors.grey900,
                  ),
                ),
              ),
            ),

            _buildPosts(),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.live_tv,
                      color: colors.purple700,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Streams',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colors.grey900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  'Discover trending content from topics you care about in real time',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: colors.grey600,
                  ),
                ),
              ),
            ),

            _buildStreams(),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Bottom padding for FAB
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.purple600,
        foregroundColor: Colors.white,
        child: SvgPicture.asset(AppAssets.editIcon),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return ValueListenableBuilder(
      valueListenable: _viewModel.categoryState,
      builder: (_, state, _) {
        if (state.categories.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: state.categories.length + 1,
              // +1 for "All" option
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // "All" option
                  return CategoryFilterChip(
                    name: 'All',
                    isSelected: state.selectedCategory?.id == null,
                    onTap: () => _viewModel.selectCategory(null),
                  );
                }

                final item = state.categories[index - 1];
                return CategoryFilterChip(
                  name: item.name,
                  isSelected: state.selectedCategory?.id == item.id,
                  onTap: () => _viewModel.selectCategory(item),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPosts() {
    return ValueListenableBuilder(
      valueListenable: _viewModel.postState,
      builder: (_, state, _) {
        if (state.loading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state.posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No posts available',
                  style: TextStyle(
                    color: AppColors.of(context).grey600,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverList.builder(
          itemCount: state.posts.length,
          itemBuilder: (_, index) {
            final post = state.posts[index];

            return AnimatedBuilder(
              animation: _postsSlideAnimation,
              builder: (_, _) => Transform.translate(
                offset: Offset(
                  _postsSlideAnimation.value * 100 * (index + 1),
                  0,
                ),
                child: Opacity(
                  opacity: 1.0 - _postsSlideAnimation.value,
                  child: PostCard(key: ValueKey(post.id), post),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStreams() {
    return ValueListenableBuilder(
      valueListenable: _viewModel.streamState,
      builder: (_, state, _) {
        if (state.loading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state.posts.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No streams available',
                  style: TextStyle(
                    color: AppColors.of(context).grey600,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: AnimatedBuilder(
              animation: _streamsSlideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _streamsSlideAnimation.value * -100,
                    0,
                  ),
                  child: Opacity(
                    opacity: 1.0 - _streamsSlideAnimation.value,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      itemCount: state.posts.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder<double>(
                          key: ValueKey(state.posts[index].id),
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 400 + (index * 100)),
                          curve: Curves.easeOutBack,
                          builder: (_, value, _) => Transform.scale(
                            scale: value,
                            child: StreamCard(state.posts[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onPostsChanged() {
    final postState = _viewModel.postState.value;
    if (postState.posts.isNotEmpty && !postState.loading) {
      _postsAnimationController.reset();
      _postsAnimationController.forward();
    }
  }

  void _onStreamsChanged() {
    final streamState = _viewModel.streamState.value;
    if (streamState.posts.isNotEmpty && !streamState.loading) {
      _streamsAnimationController.reset();
      _streamsAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _viewModel.postState.removeListener(_onPostsChanged);
    _viewModel.streamState.removeListener(_onStreamsChanged);
    _postsAnimationController.dispose();
    _streamsAnimationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }
}
