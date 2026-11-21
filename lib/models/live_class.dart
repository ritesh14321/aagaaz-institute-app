enum LiveStatus { live, upcoming }

class LiveClass {
  const LiveClass({
    required this.id,
    required this.title,
    required this.subject,
    required this.faculty,
    required this.batch,
    required this.startsAt,
    required this.duration,
    required this.status,
    required this.agenda,
  });

  final String id;
  final String title;
  final String subject;
  final String faculty;
  final String batch;
  final DateTime startsAt;
  final Duration duration;
  final LiveStatus status;
  final List<String> agenda;

  bool get isLive => status == LiveStatus.live;
}
