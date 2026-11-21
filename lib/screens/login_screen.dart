import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../utils/phone.dart';
import '../widgets/aagaaz_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _otpFocus = FocusNode();
  var _otpStep = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  String get _digits => digitsOnly(_phoneController.text);

  void _continue() {
    if (!isIndianMobile(_digits)) return;
    setState(() => _otpStep = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocus.requestFocus();
    });
  }

  void _verify() {
    if (_otpController.text.trim().length != 6) return;
    InstituteScope.of(context).signIn(_digits);
  }

  @override
  Widget build(BuildContext context) {
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
                        child: _otpStep ? _otpForm() : _phoneForm(),
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

  Widget _phoneForm() {
    final digits = _digits;
    final invalidComplete = digits.length == 10 && !isIndianMobile(digits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in with your registered mobile number to access batches, tests, and study material.',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Mobile number',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: const Text(
                '+91',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                key: const Key('phone-field'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _continue(),
                decoration: const InputDecoration(
                  hintText: '98765 43210',
                ),
              ),
            ),
          ],
        ),
        if (invalidComplete) ...[
          const SizedBox(height: 8),
          const Text(
            'Enter a valid 10-digit mobile number starting with 6, 7, 8, or 9.',
            style: TextStyle(color: AppColors.clay, fontSize: 13),
          ),
        ],
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            key: const Key('continue-button'),
            onPressed: isIndianMobile(digits) ? _continue : null,
            child: const Text(
              'Continue',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: AppColors.ink,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Enter any 6-digit verification code on the next step to continue.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _otpForm() {
    final code = _otpController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your number',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Enter the 6-digit code for +91 ${formatIndianMobile(_digits)}.',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Verification code',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('otp-field'),
          controller: _otpController,
          focusNode: _otpFocus,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _verify(),
          style: const TextStyle(
            letterSpacing: 10,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          decoration: const InputDecoration(
            hintText: '••••••',
            counterText: '',
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            key: const Key('verify-button'),
            onPressed: code.length == 6 ? _verify : null,
            child: const Text(
              'Verify and sign in',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            key: const Key('change-number'),
            onPressed: () => setState(() {
              _otpStep = false;
              _otpController.clear();
            }),
            child: const Text('Change mobile number'),
          ),
        ),
      ],
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
