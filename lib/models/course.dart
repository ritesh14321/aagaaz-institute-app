enum ExamTrack { upsc, mppsc, testSeries }

class Course {
  const Course({
    required this.id,
    required this.title,
    required this.track,
    required this.summary,
    required this.lengthLabel,
    required this.mode,
    required this.sessionLabel,
    required this.highlights,
  });

  final String id;
  final String title;
  final ExamTrack track;
  final String summary;
  final String lengthLabel;
  final String mode;
  final String sessionLabel;
  final List<String> highlights;

  String get trackLabel => switch (track) {
        ExamTrack.upsc => 'UPSC',
        ExamTrack.mppsc => 'MPPSC',
        ExamTrack.testSeries => 'Test series',
      };
}
