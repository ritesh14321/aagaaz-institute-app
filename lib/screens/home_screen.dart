import 'dart:async';

import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/live_class.dart';
import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../widgets/course_card.dart';
import '../widgets/live_class_card.dart';
import '../widgets/section_header.dart';
import 'classroom_screen.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onBrowseCourses,
    required this.onBrowseLive,
    this.onBrowseTests,
  });

  final VoidCallback onBrowseCourses;
  final VoidCallback onBrowseLive;
  final VoidCallback? onBrowseTests;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  Timer? _autoSlideTimer;
  int _bannerIndex = 0;

  List<_PromoBanner> _bannersForExam(String exam) {
    return [
      _PromoBanner(
        badge: 'NEW BATCH LAUNCH',
        title: '$exam Foundation Batch 2026',
        subtitle:
            'Live classes, structured notes & daily practice  ·  Tap to explore',
        icon: Icons.campaign_outlined,
        accentColor: AppColors.clay,
        // Jab chaahein yahan apni image ka URL ya asset path daal sakte hain:
        // imageUrl: 'https://example.com/batch-banner.jpg',
        // assetPath: 'assets/banners/foundation_batch.png',
      ),
      _PromoBanner(
        badge: 'LIVE MENTORSHIP',
        title: 'Prelims & Mains Test Series',
        subtitle:
            'Regular evaluation & answer writing guidance in Indore & Mandsaur',
        icon: Icons.verified_outlined,
        accentColor: AppColors.ink,
      ),
      _PromoBanner(
        badge: 'DAILY PRACTICE',
        title: 'Daily Quiz & Current Affairs',
        subtitle: 'Sharpen accuracy every day with topic-wise question sets',
        icon: Icons.auto_awesome_outlined,
        accentColor: AppColors.clay,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    final totalBanners = _bannersForExam('UPSC').length;
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      final nextPage = (_bannerIndex + 1) % totalBanners;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final exam = store.selectedExam ?? 'UPSC & MPPSC';
    final banners = _bannersForExam(exam);
    final classes = Catalog.liveClasses();
    final courses = [...Catalog.courses]..sort((a, b) {
        final aRank = store.isEnrolled(a.id) ? 0 : 1;
        final bRank = store.isEnrolled(b.id) ? 0 : 1;
        return aRank.compareTo(bRank);
      });

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 154,
                  child: PageView.builder(
                    controller: _bannerController,
                    itemCount: banners.length,
                    onPageChanged: (index) {
                      setState(() => _bannerIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == banners.length - 1 ? 0 : 6,
                        ),
                        child: _BannerCard(
                          banner: banner,
                          onTap: widget.onBrowseCourses,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(banners.length, (index) {
                    final active = index == _bannerIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: active ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active ? AppColors.clay : AppColors.line,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 8, 0),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Live classes',
              actionLabel: 'Schedule',
              onAction: widget.onBrowseLive,
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
              onAction: widget.onBrowseCourses,
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

class _PromoBanner {
  const _PromoBanner({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.imageUrl,
    this.assetPath,
  });

  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String? imageUrl;
  final String? assetPath;
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.banner,
    required this.onTap,
  });

  final _PromoBanner banner;
  final VoidCallback onTap;

  Widget _buildVisual() {
    final fallbackIcon = Icon(
      banner.icon,
      color: banner.accentColor,
      size: 28,
    );

    if (banner.assetPath != null && banner.assetPath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          banner.assetPath!,
          width: 84,
          height: 84,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackIcon,
        ),
      );
    }

    if (banner.imageUrl != null && banner.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          banner.imageUrl!,
          width: 84,
          height: 84,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallbackIcon,
        ),
      );
    }

    return fallbackIcon;
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = (banner.assetPath != null && banner.assetPath!.isNotEmpty) ||
        (banner.imageUrl != null && banner.imageUrl!.isNotEmpty);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        banner.badge,
                        style: TextStyle(
                          color: banner.accentColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      banner.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      banner.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: hasImage ? 84 : 54,
                height: hasImage ? 84 : 54,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                alignment: Alignment.center,
                child: _buildVisual(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
