import 'package:flutter/material.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';

class EbookScreen extends StatelessWidget {
  const EbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final examLabel = InstituteScope.of(context).selectedExam ?? 'UPSC & MPPSC';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        children: [
          const Text(
            'STUDY LIBRARY',
            style: TextStyle(
              color: AppColors.clay,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'E-Books & Notes',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reference material & notes for $examLabel',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 20),
          const _BookCard(
            title: 'Indian Constitution & Polity Notes',
            subtitle: 'Structured class notes & key articles summary',
            format: 'PDF',
          ),
          const SizedBox(height: 12),
          const _BookCard(
            title: 'Modern & Regional History Compendium',
            subtitle: 'Timelines, key movements & quick revision sheets',
            format: 'E-Book',
          ),
          const SizedBox(height: 12),
          const _BookCard(
            title: 'Geography, Economy & Environment',
            subtitle: 'Maps, concepts & exam-focused pointers',
            format: 'PDF',
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.title,
    required this.subtitle,
    required this.format,
  });

  final String title;
  final String subtitle;
  final String format;

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
              Icons.auto_stories_outlined,
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
                  subtitle,
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
              format,
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
