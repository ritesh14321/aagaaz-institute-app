import 'package:flutter/material.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final examLabel = InstituteScope.of(context).selectedExam ?? 'UPSC & MPPSC';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          const Text(
            'DAILY PRACTICE',
            style: TextStyle(
              color: AppColors.clay,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Quiz & Practice',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Focused practice sets for $examLabel',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 20),
          const _QuizCard(
            title: 'Polity & Governance Daily Set',
            meta: '20 Questions  ·  25 Mins',
            tag: 'GS II',
          ),
          const SizedBox(height: 12),
          const _QuizCard(
            title: 'Current Affairs & General Knowledge',
            meta: '15 Questions  ·  15 Mins',
            tag: 'Prelims',
          ),
          const SizedBox(height: 12),
          const _QuizCard(
            title: 'History & Culture Capsule',
            meta: '25 Questions  ·  30 Mins',
            tag: 'GS I',
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({
    required this.title,
    required this.meta,
    required this.tag,
  });

  final String title;
  final String meta;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: AppColors.clay,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
