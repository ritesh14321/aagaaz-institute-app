import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/course.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _filters = ['All', 'Prelims', 'Mains', 'Demo Class'];
  var _selectedIndex = 0;

  bool _matchesFilter(Course course, String filter) {
    if (filter == 'All') return true;
    final haystack = '${course.id} ${course.title}'.toLowerCase();
    if (filter == 'Prelims') {
      return haystack.contains('prelims') || haystack.contains('foundation');
    }
    if (filter == 'Mains') {
      return haystack.contains('mains') || haystack.contains('foundation');
    }
    if (filter == 'Demo Class') {
      return haystack.contains('demo') ||
          haystack.contains('foundation') ||
          haystack.contains('prelims');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final isDark = store.isDarkMode;
    final selectedFilter = _filters[_selectedIndex];

    final filtered = Catalog.courses
        .where((c) => _matchesFilter(c, selectedFilter))
        .toList();

    final courses = filtered.isEmpty ? Catalog.courses : filtered;

    final chipBg = isDark ? const Color(0xFF1E1D1B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF322F2C) : AppColors.line;
    final primaryText = isDark ? const Color(0xFFF5F2EE) : AppColors.ink;

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = _filters[index];
              final selected = _selectedIndex == index;
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => setState(() => _selectedIndex = index),
                selectedColor: AppColors.clay,
                backgroundColor: chipBg,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: selected ? AppColors.clay : borderCol,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                course: course,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CourseDetailScreen(courseId: course.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
