import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    debugPrint('Login submit pressed: ${_usernameController.text.trim()}');
    if (!_formKey.currentState!.validate()) {
      debugPrint('Login submit validation failed.');
      return;
    }
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(
            phone: _usernameController.text.trim(),
            password: _passwordController.text,
          );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLoading = auth.isLoading;
    final error = auth.error;
    final buttonLoading = _isSubmitting || isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CSMS',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Welcome back. Sign in to continue.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: 'Phone number',
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        enabled: !isLoading,
                        validator: (value) =>
                            value == null || value.trim().length < 7
                            ? 'Enter your registered phone number.'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your password.';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            tooltip: _passwordVisible
                                ? 'Hide password'
                                : 'Show password',
                            onPressed: () => setState(
                              () => _passwordVisible = !_passwordVisible,
                            ),
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppTextButton(
                          label: 'Forgot password?',
                          onPressed: isLoading
                              ? null
                              : () => context.go(AppRoutes.forgotPassword),
                        ),
                      ),
                      if (error != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        AppErrorWidget(message: _messageFor(error)),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: AppPrimaryButton(
                          label: 'Sign in',
                          isLoading: buttonLoading,
                          onPressed: _submit,
                          icon: Icons.login,
                        ),
                      ),
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

  String _messageFor(Object error) => error is ApiException
      ? error.message
      : 'Unable to sign in. Please try again.';
}
