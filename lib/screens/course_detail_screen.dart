import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/course.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  static const _tabs = ['All', 'Prelims', 'Mains', 'Demo Class'];
  var _selectedTab = 0;

  Course? _findCourse() {
    for (final item in Catalog.courses) {
      if (item.id == widget.courseId) return item;
    }
    return Catalog.courses.isNotEmpty ? Catalog.courses.first : null;
  }

  String _sectionNote(String tab, String courseTitle) {
    switch (tab) {
      case 'Prelims':
        return 'Prelims focus for $courseTitle: objective practice, core concepts & revision.';
      case 'Mains':
        return 'Mains focus for $courseTitle: answer writing, structured notes & evaluation.';
      case 'Demo Class':
        return 'Free demo session available for $courseTitle. Tap to preview or enroll.';
      default:
        return 'Complete coverage for $courseTitle across Prelims, Mains & Demo Class.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final course = _findCourse();
    final isDark = store.isDarkMode;

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: const Center(child: Text('Course not found.')),
      );
    }

    final enrolled = store.isEnrolled(course.id);
    final activeTab = _tabs[_selectedTab];
    final pageBg = isDark ? const Color(0xFF141312) : AppColors.cream;
    final cardBg = isDark ? const Color(0xFF1E1D1B) : Colors.white;
    final chipBg = isDark ? const Color(0xFF282623) : AppColors.cream;
    final borderCol = isDark ? const Color(0xFF322F2C) : AppColors.line;
    final primaryText = isDark ? const Color(0xFFF5F2EE) : AppColors.ink;
    final secondaryText = isDark ? const Color(0xFFB5AEA6) : AppColors.muted;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        title: Text(
          course.title,
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final label = _tabs[index];
                  final selected = _selectedTab == index;
                  return ChoiceChip(
                    label: Text(label),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedTab = index),
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
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderCol),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activeTab,
                    style: const TextStyle(
                      color: AppColors.clay,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _sectionNote(activeTab, course.title),
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.clay,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (!enrolled) {
                          store.enroll(course.id);
                        }
                      },
                      child: Text(
                        enrolled ? 'Enrolled' : 'Enroll Now',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
