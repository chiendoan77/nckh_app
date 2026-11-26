import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/auth/session.dart';
import '../../../core/network/api_error.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/hexagon_logo.dart';
import '../data/auth_provider.dart';
import 'role_picker.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          );
      if (!mounted) {
        return;
      }

      setState(() => _isLoading = false);
      var activeRole = session.activeRole;
      if (session.user.hasMultiRoles) {
        final selectedRole = await showRolePicker(context);
        if (!mounted || selectedRole == null) {
          return;
        }
        activeRole = selectedRole;
      }

      ref
          .read(sessionProvider.notifier)
          .login(session.token, session.user, activeRole);
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    } finally {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTokens.readableWidth),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: HexagonLogo(size: 64)),
                const SizedBox(height: 16),
                Text(
                  'Đăng nhập hệ thống NCKH',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('username-field'),
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                  textInputAction: TextInputAction.next,
                  validator: validateRequired,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('password-field'),
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  validator: validateRequired,
                ),
                const SizedBox(height: 20),
                AppButton(
                  key: const Key('login-submit'),
                  label: 'Đăng nhập',
                  onPressed: _isLoading ? null : _login,
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 12),
                  const Center(
                    child: SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
