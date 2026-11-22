import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/exam_select_screen.dart';
import 'screens/login_screen.dart';
import 'screens/shell_screen.dart';
import 'state/institute_store.dart';
import 'supabase_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AagaazApp());
}

class AagaazApp extends StatefulWidget {
  const AagaazApp({super.key});

  @override
  State<AagaazApp> createState() => _AagaazAppState();
}

class _AagaazAppState extends State<AagaazApp> {
  InstituteStore? _store;
  String? _errorText;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SupabaseService.initialize();
      if (!mounted) return;
      setState(() {
        _store = InstituteStore();
        _ready = true;
      });
    } catch (e, st) {
      if (!mounted) return;
      setState(() {
        _errorText = '$e\n\n$st';
        _ready = true;
      });
    }
  }

  @override
  void dispose() {
    _store?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_errorText != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text('App Debug Log')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ),
      );
    }

    final store = _store!;
    return InstituteScope(
      store: store,
      child: Builder(
        builder: (context) {
          final currentStore = InstituteScope.of(context);
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
            themeMode: currentStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
