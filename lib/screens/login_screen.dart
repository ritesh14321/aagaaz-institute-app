import 'package:flutter/material.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../widgets/aagaaz_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isSignUp = false;
  var _obscurePassword = true;
  String? _localError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() => _localError = 'Kripya sahi email address daalein.');
      return;
    }
    if (password.length < 6) {
      setState(() {
        _localError = 'Password kam se kam 6 characters ka hona chahiye.';
      });
      return;
    }

    setState(() => _localError = null);

    final store = InstituteScope.of(context);
    final ok = _isSignUp
        ? await store.signUpWithEmail(email: email, password: password)
        : await store.signInWithEmail(email: email, password: password);

    if (!mounted) return;

    if (ok && _isSignUp && store.email != null && !store.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account ban gaya! Email verification link check karein ya login karein.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final busy = store.isAuthBusy;
    final errorText = _localError ?? store.authError;

    return Scaffold(
      backgroundColor: AppColors.inkDeep,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3F66),
              AppColors.ink,
              AppColors.inkDeep,
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -85,
              right: -55,
              child: _SunGlow(),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: const Text(
                      'CIVIL SERVICES PORTAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AagaazMark(onDark: true),
                  const SizedBox(height: 14),
                  const Text(
                    'Aagaaz Institute',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'UPSC & MPPSC  ·  Indore & Mandsaur',
                    style: TextStyle(
                      color: Color(0xFFD5DEEA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isSignUp ? 'Create student account' : 'Welcome back',
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isSignUp
                                  ? 'Sign up with your email to save courses and progress across devices.'
                                  : 'Sign in with your email and password to access batches, tests, and study material.',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Email address',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              key: const Key('email-field'),
                              controller: _emailController,
                              enabled: !busy,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.next,
                              onChanged: (_) {
                                if (_localError != null) {
                                  setState(() => _localError = null);
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'student@example.com',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Password',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              key: const Key('password-field'),
                              controller: _passwordController,
                              enabled: !busy,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              onChanged: (_) {
                                if (_localError != null) {
                                  setState(() => _localError = null);
                                }
                              },
                              onSubmitted: (_) => busy ? null : _submit(),
                              decoration: InputDecoration(
                                hintText: 'Minimum 6 characters',
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                            ),
                            if (errorText != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                errorText,
                                style: const TextStyle(
                                  color: AppColors.clay,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: FilledButton(
                                key: const Key('auth-submit-button'),
                                onPressed: busy ? null : _submit,
                                child: busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        _isSignUp ? 'Create account' : 'Sign in',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton(
                                key: const Key('toggle-auth-mode'),
                                onPressed: busy
                                    ? null
                                    : () => setState(() {
                                          _isSignUp = !_isSignUp;
                                          _localError = null;
                                        }),
                                child: Text(
                                  _isSignUp
                                      ? 'Already have an account? Sign in'
                                      : 'New student? Create account',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunGlow extends StatelessWidget {
  const _SunGlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFFF2C14E),
            Color(0x00E39B2B),
          ],
        ),
      ),
    );
  }
}
