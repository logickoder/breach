import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/assets.dart';
import '../app/theme/colors.dart';
import '../home/home_screen.dart';
import 'empty_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/home';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  var _currentIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  final List<Widget> _screens = const [
    HomeScreen(),
    EmptyDashboardScreen(icon: AppAssets.dashboardIcon, title: 'Dashboard'),
    EmptyDashboardScreen(
      icon: AppAssets.publicationsIcon,
      title: 'Publications',
    ),
  ];

  final _navItems = const [
    (icon: AppAssets.homeIcon, label: 'Home'),
    (icon: AppAssets.dashboardIcon, label: 'Dashboard'),
    (icon: AppAssets.publicationsIcon, label: 'Publications'),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _animationController.forward();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (_, _) => Transform.scale(
                scale: _scaleAnimation.value,
                child: IndexedStack(
                  index: _currentIndex,
                  children: _screens,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.white,
              boxShadow: [
                BoxShadow(
                  color: colors.grey200,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              8 + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == _currentIndex;

                return TweenAnimationBuilder<double>(
                  tween: Tween(
                    begin: 0.0,
                    end: isActive ? 1.0 : 0.0,
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  builder: (_, value, _) {
                    final color =
                        Color.lerp(colors.grey500, colors.purple600, value) ??
                        colors.grey500;
                    return GestureDetector(
                      onTap: () => _onTabTapped(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            Colors.transparent,
                            colors.magnolia,
                            value,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              item.icon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                color,
                                BlendMode.srcIn,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: value * 8,
                            ),
                            if (value > 0.5) ...{
                              AnimatedOpacity(
                                opacity: (value - 0.5) * 2,
                                duration: const Duration(milliseconds: 100),
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
