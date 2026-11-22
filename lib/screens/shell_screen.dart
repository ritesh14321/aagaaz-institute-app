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
    final isDark = InstituteScope.of(context).isDarkMode;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1C1B1A) : Colors.white,
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
              leading: Icon(Icons.quiz_outlined),
              title: Text('Daily practice sets available'),
              subtitle: Text('New questions ready in the Quiz tab.'),
            ),
          ],
        ),
      ),
    );
  }

  void _openDownloads(BuildContext context) {
    final isDark = InstituteScope.of(context).isDarkMode;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1C1B1A) : Colors.white,
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.download_done_outlined),
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
    final isDark = store.isDarkMode;
    final barBg = isDark ? const Color(0xFF141312) : AppColors.cream;
    final cardBg = isDark ? const Color(0xFF1E1D1B) : Colors.white;
    final borderCol = isDark ? const Color(0xFF322F2C) : AppColors.line;
    final primaryText = isDark ? const Color(0xFFF5F2EE) : AppColors.ink;
    final secondaryText = isDark ? const Color(0xFFB5AEA6) : AppColors.muted;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: barBg,
      drawer: Drawer(
        backgroundColor: barBg,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderCol),
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
                              Text(
                                'Aagaaz Institute',
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (store.phone != null)
                                Text(
                                  maskIndianMobile(store.phone!),
                                  style: TextStyle(
                                    color: secondaryText,
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
                        color: barBg,
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
                leading: Icon(Icons.person_outline, color: primaryText),
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
                leading: Icon(Icons.swap_horiz_rounded, color: primaryText),
                title: const Text('Switch UPSC / MPPSC'),
                onTap: () {
                  Navigator.pop(context);
                  store.selectExam(exam == 'UPSC' ? 'MPPSC' : 'UPSC');
                },
              ),
              SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                  color: primaryText,
                ),
                title: const Text('Night mode'),
                subtitle: Text(
                  isDark ? 'On' : 'Off',
                  style: TextStyle(color: secondaryText, fontSize: 12),
                ),
                value: isDark,
                activeThumbColor: AppColors.clay,
                onChanged: (val) => store.toggleDarkMode(val),
              ),
              ListTile(
                leading: Icon(Icons.notifications_none, color: primaryText),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pop(context);
                  _openNotifications(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.download_outlined, color: primaryText),
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
        backgroundColor: barBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Menu',
          icon: Icon(Icons.menu, color: primaryText),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            Text(
              'Aagaaz',
              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: borderCol),
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
            icon: Icon(Icons.notifications_outlined, color: primaryText),
            onPressed: () => _openNotifications(context),
          ),
          IconButton(
            tooltip: 'Downloads',
            icon: Icon(Icons.download_outlined, color: primaryText),
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
        backgroundColor: barBg,
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
