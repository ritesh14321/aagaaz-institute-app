import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/exam_select_screen.dart';
import 'screens/login_screen.dart';
import 'screens/shell_screen.dart';
import 'state/institute_store.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
      child: MaterialApp(
        title: 'Aagaaz Institute',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const _Gate(),
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
