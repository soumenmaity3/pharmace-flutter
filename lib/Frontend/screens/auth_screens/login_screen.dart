import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/auth/secure_storage_service.dart';
import 'package:pharmace/Frontend/screens/auth_screens/add_shop_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';
import 'package:pharmace/Provider/app_view_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onCreateAccount,
  });

  final VoidCallback onLogin;
  final VoidCallback onCreateAccount;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isSubmitting = false;
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Fetch shops from API and save to local DB
  Future<void> _loadAndSaveShops(AppDatabase db) async {
    try {
      final result = await apiService.getOwnerShops();
      if (!mounted) return;

      if (result.statusCode >= 200 &&
          result.statusCode < 300 &&
          result.data != null) {
        // result.data is List<ShopReturnModel>, save to local DB
        await db.shopDao.syncShops(result.data!);
      }
    } catch (_) {
      // Shops failed to load — not critical, user can retry from dashboard
    }
  }

  Future<void> _submit(AppDatabase db) async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final Map<String, String> loginDetails = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      final result = await apiService.signInOwner(loginDetails);

      if (!mounted) return;

      if (result.statusCode >= 200 &&
          result.statusCode < 300 &&
          result.data != null) {
        await db.ownerAuthDao.deleteOwner();
        await db.inventoryMedicineDao.deleteAllData();
        await db.shopDao.deleteAllData();
        await db.billDao.deleteAllData();
        // 1. Save JWT token first
        await SecureStorageService.saveToken(result.data!.token);

        // 2. Save owner to local DB BEFORE navigating
        await db.ownerAuthDao.saveOwner(result.data!.owner);

        bool haveShop = result.data?.owner.isShopHave ?? false;
        if (!haveShop) {
          if (!mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (shopContext) => AddShopScreen(
                onCompleted: () {
                  Navigator.of(shopContext).popUntil((route) => route.isFirst);
                  ref.read(appViewProvider.notifier).state = AppView.login;
                },
              ),
            ),
          );
          return;
        }

        // 3. Load shops from API and save to local DB
        await _loadAndSaveShops(db);

        if (!mounted) return;

        // 4. Navigate to dashboard
        widget.onLogin();
      } else {
        _showError(result.message ?? _messageForStatus(result.statusCode));
      }
    } on TimeoutException {
      if (mounted) _showError('The server took too long to respond.');
    } on SocketException {
      if (mounted) _showError('Could not connect to the server.');
    } on FormatException {
      if (mounted) _showError('The server returned an invalid response.');
    } catch (_) {
      if (mounted) _showError('Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _messageForStatus(int statusCode) => switch (statusCode) {
    400 => 'Please check your details and try again.',
    409 => 'An account with this email already exists.',
    >= 500 => 'The server is unavailable. Please try again later.',
    _ => 'Signup failed. Please try again.',
  };
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppThemeExtension>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final AppDatabase db = ref.watch(databaseProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 440),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.local_pharmacy_rounded,
                            color: colors.primary,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sign in to manage your pharmacy.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 36),
                      _FieldLabel(label: 'Email address'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: [AutofillHints.username],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'you@pharmacy.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Enter your email address.';
                          if (!email.contains('@')) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _FieldLabel(label: 'Password'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: [AutofillHints.password],
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) async {
                          _submit(db);
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value?.isEmpty ?? true)) {
                            return 'Enter your password.';
                          }
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _rememberMe,
                              onChanged: (value) =>
                                  setState(() => _rememberMe = value ?? false),
                              title: Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Contact your administrator to reset your password.',
                                    ),
                                  ),
                                ),
                            child: Text('Forgot password?'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                _submit(db);
                              },
                        child: _isSubmitting
                            ? SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: isDark
                                      ? AppColors.darkBackground
                                      : Colors.white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : Text('Sign in'),
                      ),
                      SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _isSubmitting ? null : _submitOffline,
                        child: Text('Continue offline (development)'),
                      ),
                      SizedBox(height: 20),
                      _googleSignInButton(isDark),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: Divider(color: appColors.border)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'SECURE PHARMACY ACCESS',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: appColors.textTertiary,
                                    letterSpacing: 0.8,
                                  ),
                            ),
                          ),
                          Expanded(child: Divider(color: appColors.border)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'By continuing, you agree to use this system in accordance with your organisation’s policies.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: appColors.textTertiary,
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to Pharmase?',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: appColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: widget.onCreateAccount,
                            child: Text('Create account'),
                          ),
                        ],
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

  // Development-only entry point while the authentication server is unavailable.
  // Remove this button before releasing the app, or replace it with a real
  // server-backed session flow that stores and validates the returned token.
  void _submitOffline() {
    FocusScope.of(context).unfocus();
    widget.onLogin();
  }

  SizedBox _googleSignInButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isSubmitting ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? Color(0xFF1F1F1F) : Colors.white,
          foregroundColor: isDark ? Colors.white : Color(0xFF1F1F1F),
          side: BorderSide(
            color: isDark ? Colors.white24 : Color(0xFFDADCE0),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      // Your Google Sign-In logic here
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: Theme.of(context).textTheme.titleSmall);
  }
}
