import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../app/assets.dart';
import '../app/components/loading_indicator.dart';
import '../app/theme/colors.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/category_chip.dart';
import 'domain/usecase.dart';
import 'select_interests_view_model.dart';

class SelectInterestsScreen extends StatefulWidget {
  static const route = '/select-interests';

  const SelectInterestsScreen({super.key});

  @override
  State<SelectInterestsScreen> createState() => _SelectInterestsScreenState();
}

class _SelectInterestsScreenState extends State<SelectInterestsScreen>
    with TickerProviderStateMixin {
  late final _viewModel = SelectInterestsViewModel();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(AppAssets.selectInterestsImage),
              ),

              const SizedBox(height: 8),
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'What are your interests?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select your interests and I\'ll recommend some series I\'m certain you\'ll enjoy!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 24),

              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  if (_viewModel.initializing) {
                    return const Center(child: LoadingIndicator());
                  }

                  if (_viewModel.categories.isEmpty) {
                    return const Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedContainer(
                      duration: Durations.medium4,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: _viewModel.categories.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final category = entry.value;

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(
                                milliseconds: 300 + (index * 100),
                              ),
                              curve: Curves.elasticOut,
                              builder: (_, value, _) {
                                return Transform.scale(
                                  scale: value,
                                  child: CategoryChip(
                                    name: category.name,
                                    icon: category.icon,
                                    selected: _viewModel.isSelected(
                                      category.id,
                                    ),
                                    onTap: () => _viewModel.toggleCategory(
                                      category.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return FilledButton(
                    onPressed: _viewModel.buttonEnabled ? _onSubmit : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.grey900,
                      foregroundColor: colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: Durations.medium4,
                      child: _viewModel.loading
                          ? LoadingIndicator(color: colors.white)
                          : const Text('Next'),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: _onSkip,
                style: TextButton.styleFrom(foregroundColor: colors.grey700),
                child: Text('Skip for later'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onViewModelChanged() {
    if (!_viewModel.initializing && _viewModel.categories.isNotEmpty) {
      _animationController.forward();
    }
  }

  void _onSubmit() async {
    final error = await _viewModel.submit();
    final isError = error != null;
    toastification.show(
      title: Text(isError ? 'An error occurred' : 'Success'),
      description: Text(
        isError ? error : 'Your interests have been saved successfully!',
      ),
      type: isError ? ToastificationType.error : ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 5),
    );
    if (mounted) {
      Navigator.pushNamed(context, DashboardScreen.route);
    }
  }

  void _onSkip() {
    OnboardingUseCase.skipInterestSelection();
    Navigator.pushNamed(context, DashboardScreen.route);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _animationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }
}
