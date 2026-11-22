import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase_service.dart';

class InstituteStore extends ChangeNotifier {
  String? _phone;
  String? _email;
  String? _selectedExam;
  bool _isDarkMode = false;
  bool _isAuthBusy = false;
  String? _authError;
  final Set<String> _enrolled = {};
  final Map<String, double> _progress = {};
  bool _isSyncingContent = false;
  DateTime? _lastSyncedAt;

  String? get phone => _phone;
  String? get email => _email ?? SupabaseService.client.auth.currentUser?.email;
  String? get selectedExam => _selectedExam;
  bool get isDarkMode => _isDarkMode;
  bool get isAuthBusy => _isAuthBusy;
  String? get authError => _authError;
  bool get isSignedIn =>
      _phone != null || SupabaseService.client.auth.currentUser != null;
  bool get isSyncingContent => _isSyncingContent;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  bool get hasSelectedExam => _selectedExam != null;

  bool isEnrolled(String courseId) => _enrolled.contains(courseId);

  double progressFor(String courseId) => _progress[courseId] ?? 0;

  List<String> get enrolledIds => List.unmodifiable(_enrolled);

  void signIn(String phone) {
    _phone = phone;
    _authError = null;
    _selectedExam = null;
    _enrolled
      ..clear()
      ..addAll({'upsc-foundation', 'mppsc-prelims'});
    _progress
      ..clear()
      ..addAll({
        'upsc-foundation': 0.42,
        'mppsc-prelims': 0.18,
      });
    notifyListeners();
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isAuthBusy = true;
    _authError = null;
    notifyListeners();

    try {
      final res = await SupabaseService.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      _email = res.user?.email ?? email.trim();
      _selectedExam = null;
      await syncUserDataFromSupabase();
      return true;
    } on AuthException catch (e) {
      _authError = e.message;
      return false;
    } catch (_) {
      _authError = 'Login mein dikkat aayi. Kripya dobara koshish karein.';
      return false;
    } finally {
      _isAuthBusy = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _isAuthBusy = true;
    _authError = null;
    notifyListeners();

    try {
      final res = await SupabaseService.client.auth.signUp(
        email: email.trim(),
        password: password,
      );
      _email = res.user?.email ?? email.trim();
      _selectedExam = null;

      if (res.session != null && res.user != null) {
        _enrolled
          ..clear()
          ..addAll({'upsc-foundation', 'mppsc-prelims'});
        _progress
          ..clear()
          ..addAll({
            'upsc-foundation': 0.42,
            'mppsc-prelims': 0.18,
          });
        for (final courseId in _enrolled) {
          await _saveEnrollmentToSupabase(courseId);
          await _saveProgressToSupabase(courseId, _progress[courseId] ?? 0);
        }
      }
      return true;
    } on AuthException catch (e) {
      _authError = e.message;
      return false;
    } catch (_) {
      _authError = 'Account banane mein dikkat aayi. Kripya dobara koshish karein.';
      return false;
    } finally {
      _isAuthBusy = false;
      notifyListeners();
    }
  }

  Future<void> syncUserDataFromSupabase() async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) return;

    try {
      final enrollmentRows = await SupabaseService.client
          .from('enrollments')
          .select('course_id')
          .eq('user_id', user.id);

      final progressRows = await SupabaseService.client
          .from('course_progress')
          .select('course_id, progress')
          .eq('user_id', user.id);

      _enrolled.clear();
      for (final row in enrollmentRows) {
        final courseId = row['course_id'] as String?;
        if (courseId != null && courseId.isNotEmpty) {
          _enrolled.add(courseId);
        }
      }

      _progress.clear();
      for (final row in progressRows) {
        final courseId = row['course_id'] as String?;
        final value = (row['progress'] as num?)?.toDouble() ?? 0;
        if (courseId != null && courseId.isNotEmpty) {
          _progress[courseId] = value;
          _enrolled.add(courseId);
        }
      }

      for (final courseId in _enrolled) {
        _progress.putIfAbsent(courseId, () => 0);
      }
      notifyListeners();
    } catch (_) {
      // Offline ya network issue hone par app crash na ho
    }
  }

  void selectExam(String exam) {
    if (_selectedExam == exam) return;
    _selectedExam = exam;
    notifyListeners();
  }

  void toggleDarkMode([bool? value]) {
    final next = value ?? !_isDarkMode;
    if (_isDarkMode == next) return;
    _isDarkMode = next;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (_) {}
    _phone = null;
    _email = null;
    _authError = null;
    _selectedExam = null;
    _isDarkMode = false;
    _enrolled.clear();
    _progress.clear();
    notifyListeners();
  }

  void enroll(String courseId) {
    if (_enrolled.add(courseId)) {
      _progress[courseId] = _progress[courseId] ?? 0;
      notifyListeners();
      _saveEnrollmentToSupabase(courseId);
      _saveProgressToSupabase(courseId, _progress[courseId] ?? 0);
    }
  }

  Future<void> updateProgress(String courseId, double value) async {
    final clamped = value.clamp(0.0, 1.0);
    _enrolled.add(courseId);
    _progress[courseId] = clamped;
    notifyListeners();
    await _saveProgressToSupabase(courseId, clamped);
  }

  Future<void> _saveEnrollmentToSupabase(String courseId) async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) return;
    try {
      await SupabaseService.client.from('enrollments').upsert(
        {
          'user_id': user.id,
          'course_id': courseId,
        },
        onConflict: 'user_id,course_id',
      );
    } catch (_) {}
  }

  Future<void> _saveProgressToSupabase(String courseId, double progress) async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) return;
    try {
      await SupabaseService.client.from('course_progress').upsert(
        {
          'user_id': user.id,
          'course_id': courseId,
          'progress': progress,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id,course_id',
      );
    } catch (_) {}
  }

  Future<void> markContentSynced() async {
    if (_isSyncingContent) return;
    _isSyncingContent = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 150));
    _lastSyncedAt = DateTime.now();
    _isSyncingContent = false;
    notifyListeners();
  }
}

class InstituteScope extends InheritedNotifier<InstituteStore> {
  const InstituteScope({
    required InstituteStore store,
    required super.child,
    super.key,
  }) : super(notifier: store);

  static InstituteStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<InstituteScope>();
    assert(scope != null, 'InstituteScope is missing above this widget');
    return scope!.notifier!;
  }
}
