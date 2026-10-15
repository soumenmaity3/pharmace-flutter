import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmace/Backend/api_service.dart';
import 'package:pharmace/Backend/model/Input/shop_owner_model.dart';
import 'package:pharmace/Frontend/screens/auth_screens/add_shop_screen.dart';
import 'package:pharmace/Frontend/theme/app_colors.dart';
import 'package:pharmace/Frontend/theme/app_theme_extension.dart';
import 'package:pharmace/Backend/auth/secure_storage_service.dart';
import 'package:pharmace/LocalDB/database.dart';
import 'package:pharmace/Provider/database_provider.dart';
import 'package:pharmace/Provider/app_view_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({
    super.key,
    required this.onSignup,
    required this.onSignIn,
  });

  final VoidCallback onSignup;
  final VoidCallback onSignIn;

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _acceptedTerms = false;
  bool _isSubmitting = false;
  final ApiService apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppDatabase db) async {
    if (_isSubmitting) return;
    FocusScope.of(context).unfocus();
    final isFormValid = _formKey.currentState!.validate();
    if (!isFormValid || !_acceptedTerms) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accept the terms and privacy policy to continue.'),
          ),
        );
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final owner = ShopOwnerModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: Role.owner,
      );

      final result = await apiService.signUpOwner(owner);
      if (!mounted) return;

      if (result.statusCode >= 200 &&
          result.statusCode < 300 &&
          result.data != null) {
        await SecureStorageService.saveToken(result.data!.token);
        // print('Sign up success');
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
        await db.ownerAuthDao.saveOwner(owner);
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
      if (mounted) _showError('Signup failed. Please try again.');
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
                      SizedBox(height: 24),
                      Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Set up secure access for your pharmacy.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 32),
                      _FieldLabel(label: 'Full name'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        autofillHints: [AutofillHints.name],
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Your full name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) {
                          if ((value?.trim().length ?? 0) < 2) {
                            return 'Enter your full name.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 18),
                      _FieldLabel(label: 'Work email address'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: [AutofillHints.email],
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
                      SizedBox(height: 18),
                      _FieldLabel(label: 'Password'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: [AutofillHints.newPassword],
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'At least 6 characters',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: _PasswordVisibilityButton(
                            isObscured: _obscurePassword,
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value?.length ?? 0) < 6) {
                            return 'Use at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 18),
                      _FieldLabel(label: 'Confirm password'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        autofillHints: [AutofillHints.newPassword],
                        obscureText: _obscureConfirmation,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) async =>
                            _submit(ref.watch(databaseProvider)),
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          suffixIcon: _PasswordVisibilityButton(
                            isObscured: _obscureConfirmation,
                            onPressed: () => setState(
                              () =>
                                  _obscureConfirmation = !_obscureConfirmation,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 6),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _acceptedTerms,
                        onChanged: (value) =>
                            setState(() => _acceptedTerms = value ?? false),
                        title: Text(
                          'I agree to the terms and privacy policy.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: appColors.textSecondary),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                _submit(ref.watch(databaseProvider));
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
                            : Text('Create account'),
                      ),
                      SizedBox(height: 20),
                      _googleSignUpButton(isDark),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: appColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: widget.onSignIn,
                            child: Text('Sign in'),
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

  SizedBox _googleSignUpButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isSubmitting ? null : _signUpWithGoogle,
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
                    'Sign up with Google',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _signUpWithGoogle() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      // Your Google Sign-Up logic here
      // _submit();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  const _PasswordVisibilityButton({
    required this.isObscured,
    required this.onPressed,
  });

  final bool isObscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isObscured ? 'Show password' : 'Hide password',
      onPressed: onPressed,
      icon: Icon(
        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
    );
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
