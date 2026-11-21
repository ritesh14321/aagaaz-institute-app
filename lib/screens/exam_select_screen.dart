import 'package:flutter/material.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../widgets/aagaaz_mark.dart';

class ExamSelectScreen extends StatelessWidget {
  const ExamSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AagaazMark(size: 42),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AAGAAZ INSTITUTE',
                          style: TextStyle(
                            color: AppColors.clay,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          'Choose your target exam',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Select which path you want to continue with. You can start right away in your chosen track.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              _ExamOptionCard(
                title: 'UPSC',
                subtitle: 'Civil Services Examination · GS Foundation, Prelims & Mains',
                badge: 'All India',
                icon: Icons.account_balance_outlined,
                onTap: () => store.selectExam('UPSC'),
              ),
              const SizedBox(height: 14),
              _ExamOptionCard(
                title: 'MPPSC',
                subtitle: 'Madhya Pradesh State Service · Prelims, Mains & MP Specific',
                badge: 'MP State',
                icon: Icons.school_outlined,
                onTap: () => store.selectExam('MPPSC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamOptionCard extends StatelessWidget {
  const _ExamOptionCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line),
                ),
                child: Icon(
                  icon,
                  color: AppColors.ink,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: AppColors.clay,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.ink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
