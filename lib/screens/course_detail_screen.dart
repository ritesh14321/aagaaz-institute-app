import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final course = Catalog.byId(courseId);
    final store = InstituteScope.of(context);
    final enrolled = store.isEnrolled(course.id);
    final progress = store.progressFor(course.id);

    return Scaffold(
      appBar: AppBar(title: Text(course.trackLabel)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            course.title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${course.lengthLabel} · ${course.mode} · ${course.sessionLabel}',
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            course.summary,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'What is included',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          for (final point in course.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle, size: 18, color: AppColors.moss),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        color: AppColors.ink,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          if (enrolled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.saffronSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Enrolled · ${(progress * 100).round()}% complete',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            FilledButton(
              key: const Key('enroll-button'),
              onPressed: () => store.enroll(course.id),
              child: const Text('Enroll in this batch'),
            ),
        ],
      ),
    );
  }
}
