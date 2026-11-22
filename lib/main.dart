import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/exam_select_screen.dart';
import 'screens/login_screen.dart';
import 'screens/shell_screen.dart';
import 'state/institute_store.dart';
import 'supabase_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SupabaseService.initialize();
  runApp(const AagaazApp());
}

class AagaazApp extends StatefulWidget {
  const AagaazApp({super.key});

  @override
  State<AagaazApp> createState() => _AagaazAppState();
}

class _AagaazAppState extends State<AagaazApp> {
  final _store = InstituteStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InstituteScope(
      store: _store,
      child: Builder(
        builder: (context) {
          final store = InstituteScope.of(context);
          return MaterialApp(
            title: 'Aagaaz Institute',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFB4532A),
                brightness: Brightness.dark,
              ),
            ),
            themeMode: store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const _Gate(),
          );
        },
      ),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final store = InstituteScope.of(context);
    if (!store.isSignedIn) return const LoginScreen();
    if (!store.hasSelectedExam) return const ExamSelectScreen();
    return const InstituteShell();
  }
}
