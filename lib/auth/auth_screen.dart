import 'package:breach/onboarding/welcome_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/assets.dart';
import '../app/theme/colors.dart';
import 'domain/auth_screen_type.dart';

class AuthScreen extends StatefulWidget {
  final AuthScreenType type;

  const AuthScreen({super.key, required this.type});

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static String route(AuthScreenType type) => '/auth/${type.name}';
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static final _emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _form = GlobalKey<FormState>();

  final _buttonEnabled = ValueNotifier(false);

  late final AnimationController _animationController;
  late final Animation<Offset> _logoSlideAnimation;
  var _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    _email.addListener(_onTextChanged);
    _password.addListener(_onTextChanged);

    _animationController = AnimationController(
      duration: Durations.medium4,
      vsync: this,
    );

    _logoSlideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -1),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideTransition(
                position: _logoSlideAnimation,
                child: SvgPicture.asset(AppAssets.logoIcon),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 0,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: _buildForm(),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text.rich(
                  TextSpan(
                    text:
                        'By signing ${switch (widget.type) {
                          AuthScreenType.signUp => 'up',
                          AuthScreenType.signIn => 'in',
                        }}, you agree to Breach’s ',
                    children: [
                      TextSpan(
                        text: 'Terms & Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          color: colors.purple600,
                        ),
                      ),
                    ],
                    style: GoogleFonts.spaceGrotesk().copyWith(
                      fontSize: 12,
                      color: colors.grey600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardCurrentlyVisible = keyboardHeight > 0;

    if (isKeyboardCurrentlyVisible != _isKeyboardVisible) {
      _isKeyboardVisible = isKeyboardCurrentlyVisible;
      if (_isKeyboardVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  Widget _buildForm() {
    final type = widget.type;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          switch (type) {
            AuthScreenType.signUp => 'Join Breach',
            AuthScreenType.signIn => 'Welcome back',
          },
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          switch (type) {
            AuthScreenType.signUp =>
              'Break through the noise and discover content that matters to you in under 3 minutes.',
            AuthScreenType.signIn =>
              'Sign in to continue to your personalized feed and stay updated with the latest content.',
          },
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 48),
        _buildLabel('Email'),
        TextFormField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter email',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!_emailRegex.hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 38),
        _buildLabel('Password'),
        TextFormField(
          controller: _password,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (type == AuthScreenType.signUp && value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 38),
        ValueListenableBuilder(
          valueListenable: _buttonEnabled,
          builder: (_, enabled, __) => FilledButton(
            onPressed: enabled ? onSubmit : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.of(context).grey900,
            ),
            child: Text('Continue'),
          ),
        ),
        const SizedBox(height: 22),
        Align(
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              text: switch (type) {
                AuthScreenType.signUp => 'Already have an account? ',
                AuthScreenType.signIn => 'Don\'t have an account? ',
              },
              children: [
                TextSpan(
                  text: switch (type) {
                    AuthScreenType.signUp => 'Sign In',
                    AuthScreenType.signIn => 'Sign Up',
                  },
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushReplacementNamed(
                      context,
                      AuthScreen.route(switch (type) {
                        AuthScreenType.signUp => AuthScreenType.signIn,
                        AuthScreenType.signIn => AuthScreenType.signUp,
                      }),
                    ),
                ),
              ],
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _onTextChanged() {
    _buttonEnabled.value =
        (_email.text.trim().isNotEmpty && _password.text.isNotEmpty);
  }

  void onSubmit() {
    if (_form.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, WelcomeScreen.route);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _buttonEnabled.dispose();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
