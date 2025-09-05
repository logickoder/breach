import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../app/components/loading_indicator.dart';
import '../app/theme/colors.dart';
import 'auth_view_model.dart';
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
  late final _viewModel = AuthViewModel(widget.type);
  final _form = GlobalKey<FormState>();

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _viewModel.addListener(() {
      if (mounted) setState(() {});
    });

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

  Widget _buildForm() {
    final type = widget.type;
    final colors = AppColors.of(context);
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
          controller: _viewModel.email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter email',
          ),
          validator: _viewModel.validateEmail,
        ),
        const SizedBox(height: 38),
        _buildLabel('Password'),
        TextFormField(
          controller: _viewModel.password,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
          ),
          obscureText: true,
          validator: _viewModel.validatePassword,
        ),
        const SizedBox(height: 38),
        FilledButton(
          onPressed: _viewModel.buttonEnabled ? onSubmit : null,
          style: FilledButton.styleFrom(
            backgroundColor: colors.grey900,
            foregroundColor: colors.white,
          ),
          child: AnimatedSwitcher(
            duration: Durations.medium4,
            child: _viewModel.loading
                ? LoadingIndicator(color: colors.white)
                : const Text('Continue'),
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
            textAlign: TextAlign.center,
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

  void onSubmit() async {
    if (_form.currentState?.validate() ?? false) {
      final (error, route) = await _viewModel.submit();
      final isError = error != null;
      toastification.show(
        title: Text(isError ? 'An error occurred' : 'Success'),
        description: Text(
          isError
              ? error
              : widget.type == AuthScreenType.signIn
              ? 'Signed in successfully'
              : 'Account created successfully',
        ),
        type: isError ? ToastificationType.error : ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 5),
      );
      if (route != null && mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
