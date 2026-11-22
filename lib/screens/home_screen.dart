import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/live_class.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../utils/phone.dart';
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
    final exam = store.selectedExam ?? 'UPSC & MPPSC';
    final classes = Catalog.liveClasses();
    final courses = [...Catalog.courses]..sort((a, b) {
        final aRank = store.isEnrolled(a.id) ? 0 : 1;
        final bRank = store.isEnrolled(b.id) ? 0 : 1;
        return aRank.compareTo(bRank);
      });
    final phone = store.phone;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(),
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (phone != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      maskIndianMobile(phone),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          size: 16,
                          color: AppColors.ink,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$exam Track  ·  Indore & Mandsaur',
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
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
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 0),
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
