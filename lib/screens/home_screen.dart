import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/live_class.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../utils/phone.dart';
import '../widgets/aagaaz_mark.dart';
import '../widgets/course_card.dart';
import '../widgets/live_class_card.dart';
import '../widgets/section_header.dart';
import 'classroom_screen.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onBrowseCourses,
    required this.onBrowseLive,
  });

  final VoidCallback onBrowseCourses;
  final VoidCallback onBrowseLive;

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final classes = Catalog.liveClasses();
    final courses = [...Catalog.courses]..sort((a, b) {
        final aRank = store.isEnrolled(a.id) ? 0 : 1;
        final bRank = store.isEnrolled(b.id) ? 0 : 1;
        return aRank.compareTo(bRank);
      });
    final phone = store.phone;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const AagaazMark(size: 46),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AAGAAZ INSTITUTE',
                          style: TextStyle(
                            color: AppColors.clay,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          _greeting(),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (phone != null)
                          Text(
                            maskIndianMobile(phone),
                            style: const TextStyle(color: AppColors.muted),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 8, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Live classes',
                actionLabel: 'Schedule',
                onAction: onBrowseLive,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 286,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                itemCount: classes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = classes[index];
                  return LiveClassCard(
                    item: item,
                    onOpen: () => _openClass(context, item),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Courses',
                actionLabel: 'See all',
                onAction: onBrowseCourses,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            sliver: SliverList.separated(
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
      ),
    );
  }

  void _openClass(BuildContext context, LiveClass item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClassroomScreen(classId: item.id),
      ),
    );
  }
}

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
