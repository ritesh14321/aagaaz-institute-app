import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

enum _CourseFilter { all, upsc, mppsc, tests }

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  var _filter = _CourseFilter.all;

  @override
  Widget build(BuildContext context) {
    final courses = Catalog.courses.where((course) {
      return switch (_filter) {
        _CourseFilter.all => true,
        _CourseFilter.upsc => course.track == ExamTrack.upsc,
        _CourseFilter.mppsc => course.track == ExamTrack.mppsc,
        _CourseFilter.tests => course.track == ExamTrack.testSeries,
      };
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            'Courses',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'UPSC and MPPSC programmes, plus the test series.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip('All', _CourseFilter.all),
              _chip('UPSC', _CourseFilter.upsc),
              _chip('MPPSC', _CourseFilter.mppsc),
              _chip('Test series', _CourseFilter.tests),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < courses.length; i++) ...[
            CourseCard(
              course: courses[i],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CourseDetailScreen(courseId: courses[i].id),
                  ),
                );
              },
            ),
            if (i != courses.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, _CourseFilter filter) {
    return FilterChip(
      label: Text(label),
      selected: _filter == filter,
      onSelected: (_) => setState(() => _filter = filter),
    );
  }
}
