import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/components/app_buttons.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/forms/app_text_field.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../controllers/forgot_password_controller.dart';

enum _RecoveryStep { phone, otp, password }

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  _RecoveryStep _step = _RecoveryStep.phone;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    switch (_step) {
      case _RecoveryStep.phone:
        await controller.requestOtp(_phoneController.text.trim());
        break;
      case _RecoveryStep.otp:
        await controller.verifyOtp(phone: _phoneController.text.trim(), otp: _otpController.text.trim());
        break;
      case _RecoveryStep.password:
        await controller.resetPassword(
          phone: _phoneController.text.trim(),
          otp: _otpController.text.trim(),
          newPassword: _passwordController.text,
        );
        break;
    }
    if (!ref.read(forgotPasswordControllerProvider).hasError) {
      if (_step == _RecoveryStep.password) {
        if (mounted) context.go(AppRoutes.login);
      } else {
        setState(() => _step = _RecoveryStep.values[_step.index + 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recovery = ref.watch(forgotPasswordControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(_description),
                    const SizedBox(height: AppSpacing.lg),
                    _buildFields(recovery.isLoading),
                    if (recovery.hasError) ...[
                      const SizedBox(height: AppSpacing.md),
                      const AppErrorWidget(message: 'Password recovery is not available until the backend API is configured.'),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Row(children: [
                      if (_step != _RecoveryStep.phone) ...[
                        AppSecondaryButton(label: 'Back', onPressed: recovery.isLoading ? null : () => setState(() => _step = _RecoveryStep.values[_step.index - 1])),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(child: AppPrimaryButton(label: _buttonLabel, isLoading: recovery.isLoading, onPressed: _continue, icon: Icons.arrow_forward)),
                    ]),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextButton(label: 'Back to sign in', onPressed: recovery.isLoading ? null : () => context.go(AppRoutes.login)),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFields(bool isLoading) => switch (_step) {
    _RecoveryStep.phone => AppTextField(
      label: 'Phone number', controller: _phoneController, enabled: !isLoading, keyboardType: TextInputType.phone,
      validator: (value) => value == null || value.trim().isEmpty ? 'Enter your registered phone number.' : null,
    ),
    _RecoveryStep.otp => AppTextField(
      label: 'Verification code', controller: _otpController, enabled: !isLoading, keyboardType: TextInputType.number,
      validator: (value) => value == null || value.trim().length < 4 ? 'Enter the verification code.' : null,
    ),
    _RecoveryStep.password => Column(children: [
      AppTextField(label: 'New password', controller: _passwordController, enabled: !isLoading, obscureText: !_passwordVisible,
        validator: (value) => value == null || value.length < 8 ? 'Password must be at least 8 characters.' : null),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(label: 'Confirm new password', controller: _confirmPasswordController, enabled: !isLoading, obscureText: !_passwordVisible,
        validator: (value) => value != _passwordController.text ? 'Passwords do not match.' : null),
      Align(alignment: Alignment.centerRight, child: AppTextButton(label: _passwordVisible ? 'Hide passwords' : 'Show passwords', onPressed: () => setState(() => _passwordVisible = !_passwordVisible))),
    ]),
  };

  String get _title => switch (_step) {
    _RecoveryStep.phone => 'Reset your password',
    _RecoveryStep.otp => 'Verify your code',
    _RecoveryStep.password => 'Choose a new password',
  };

  String get _description => switch (_step) {
    _RecoveryStep.phone => 'Enter the phone number registered to your account.',
    _RecoveryStep.otp => 'Enter the verification code sent to your phone.',
    _RecoveryStep.password => 'Create a secure new password for your account.',
  };

  String get _buttonLabel => switch (_step) {
    _RecoveryStep.phone => 'Send code',
    _RecoveryStep.otp => 'Verify code',
    _RecoveryStep.password => 'Reset password',
  };
}
