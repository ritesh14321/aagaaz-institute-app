import 'package:flutter/material.dart';

import '../state/institute_store.dart';
import '../theme/app_colors.dart';
import '../utils/phone.dart';
import '../widgets/aagaaz_mark.dart';
import 'account_screen.dart';
import 'courses_screen.dart';
import 'ebook_screen.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import 'quiz_screen.dart';

class InstituteShell extends StatefulWidget {
  const InstituteShell({super.key});

  @override
  State<InstituteShell> createState() => _InstituteShellState();
}

class _InstituteShellState extends State<InstituteShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _index = 0;

  void _go(int index) => setState(() => _index = index);

  void _openNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Notifications',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.podcasts, color: AppColors.clay),
              title: Text('Live classes & batch updates'),
              subtitle: Text('Check the Live tab for ongoing and upcoming sessions.'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.quiz_outlined, color: AppColors.ink),
              title: Text('Daily practice sets available'),
              subtitle: Text('New questions ready in the Quiz tab.'),
            ),
          ],
        ),
      ),
    );
  }

  void _openDownloads(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Downloads',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.download_done_outlined, color: AppColors.ink),
              title: Text('Offline notes & E-Books'),
              subtitle: Text('Saved study material from E-Book will appear here.'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    final exam = store.selectedExam ?? 'UPSC & MPPSC';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cream,
      drawer: Drawer(
        backgroundColor: AppColors.cream,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AagaazMark(size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Aagaaz Institute',
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (store.phone != null)
                                Text(
                                  maskIndianMobile(store.phone!),
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12.5,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Track: $exam',
                        style: const TextStyle(
                          color: AppColors.clay,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.person_outline, color: AppColors.ink),
                title: const Text('Profile & Account'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AccountScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.ink),
                title: const Text('Switch UPSC / MPPSC'),
                onTap: () {
                  Navigator.pop(context);
                  store.selectExam(exam == 'UPSC' ? 'MPPSC' : 'UPSC');
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none, color: AppColors.ink),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  _openNotifications(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined, color: AppColors.ink),
                title: const Text('Downloads'),
                onTap: () {
                  Navigator.pop(context);
                  _openDownloads(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu, color: AppColors.ink),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            const Text(
              'Aagaaz',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                exam,
                style: const TextStyle(
                  color: AppColors.clay,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined, color: AppColors.ink),
            onPressed: () => _openNotifications(context),
          ),
          IconButton(
            tooltip: 'Downloads',
            icon: const Icon(Icons.download_outlined, color: AppColors.ink),
            onPressed: () => _openDownloads(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onBrowseCourses: () => _go(1),
            onBrowseLive: () => _go(2),
          ),
          const CoursesScreen(),
          const LiveScreen(),
          const QuizScreen(),
          const EbookScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.podcasts_outlined),
            selectedIcon: Icon(Icons.podcasts),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'E-Book',
          ),
        ],
      ),
    );
  }
}
