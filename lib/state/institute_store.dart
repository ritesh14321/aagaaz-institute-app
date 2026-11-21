import 'package:flutter/widgets.dart';

class InstituteStore extends ChangeNotifier {
  String? _phone;
  String? _selectedExam;
  final Set<String> _enrolled = {};
  final Map<String, double> _progress = {};

  String? get phone => _phone;
  String? get selectedExam => _selectedExam;
  bool get isSignedIn => _phone != null;
  bool get hasSelectedExam => _selectedExam != null;

  bool isEnrolled(String courseId) => _enrolled.contains(courseId);

  double progressFor(String courseId) => _progress[courseId] ?? 0;

  List<String> get enrolledIds => List.unmodifiable(_enrolled);

  void signIn(String phone) {
    _phone = phone;
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

  void selectExam(String exam) {
    if (_selectedExam == exam) return;
    _selectedExam = exam;
    notifyListeners();
  }

  void signOut() {
    _phone = null;
    _selectedExam = null;
    _enrolled.clear();
    _progress.clear();
    notifyListeners();
  }

  void enroll(String courseId) {
    if (_enrolled.add(courseId)) {
      _progress[courseId] = 0;
      notifyListeners();
    }
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
