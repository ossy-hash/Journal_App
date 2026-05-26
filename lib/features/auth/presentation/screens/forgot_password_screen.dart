import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).forgotPassword(
            _emailController.text.trim(),
          );
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlack,
              AppTheme.surfaceBlack,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          onPressed: () => context.go('/login'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.goldAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.goldAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          _emailSent
                              ? Icons.check_circle_outline
                              : Icons.lock_reset,
                          color: AppTheme.goldAccent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Header
                      Text(
                        _emailSent ? 'Check Your Email' : 'Reset Password',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _emailSent
                            ? 'We\'ve sent a password reset link to your email address'
                            : 'Enter your email address and we\'ll send you a reset link',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      if (!_emailSent) ...[
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppTheme.goldAccent,
                            ),
                          ),
                          style:
                              const TextStyle(color: AppTheme.textPrimary),
                           validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 32),

                        // Send Button
                        ElevatedButton(
                          onPressed: _handleForgotPassword,
                          child: const Text('Send Reset Link'),
                        ),
                      ] else ...[
                        // Resend Button
                        ElevatedButton(
                          onPressed: _handleForgotPassword,
                          child: const Text('Resend Email'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            'Back to Login',
                            style: TextStyle(color: AppTheme.goldAccent),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}