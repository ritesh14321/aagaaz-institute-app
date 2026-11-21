import '../models/course.dart';
import '../models/live_class.dart';

abstract final class Catalog {
  static const courses = <Course>[
    Course(
      id: 'upsc-foundation',
      title: 'UPSC CSE Foundation',
      track: ExamTrack.upsc,
      summary:
          'NCERT foundation, full syllabus coverage, current affairs, and daily answer writing. Offline in Indore or Mandsaur, or live online.',
      lengthLabel: 'Foundation batch',
      mode: 'Offline & live online',
      sessionLabel: 'Daily classes',
      highlights: [
        'NCERT foundation and complete syllabus coverage',
        'Current affairs integrated with the static syllabus',
        'Daily answer writing practice',
        'Offline classrooms and live-online mode',
      ],
    ),
    Course(
      id: 'mppsc-target',
      title: 'MPPSC State Services Target',
      track: ExamTrack.mppsc,
      summary:
          'Madhya Pradesh GK, the updated MPPSC syllabus, and state-specific answer writing with mentor guidance.',
      lengthLabel: 'Target batch',
      mode: 'Offline & live online',
      sessionLabel: 'Full syllabus',
      highlights: [
        'Madhya Pradesh GK specialization',
        'Updated MPPSC syllabus coverage',
        'State-specific answer writing',
        'Guidance from institute mentors',
      ],
    ),
    Course(
      id: 'mppsc-foundation',
      title: 'MPPSC Foundation',
      track: ExamTrack.mppsc,
      summary:
          'A three-year online foundation. Subjects start from the basics, with printed notes, class tests, and personal mentoring.',
      lengthLabel: '3 years',
      mode: 'Online',
      sessionLabel: 'Class tests included',
      highlights: [
        'Every subject taught from the basics',
        'Printed notes and add-on material',
        'Special answer writing classes',
        'Personal mentoring by the faculty',
      ],
    ),
    Course(
      id: 'mppsc-prelims',
      title: 'MPPSC Prelims',
      track: ExamTrack.mppsc,
      summary:
          'Five months of online classes covering Prelims Paper 1 and Paper 2, with class tests and add-on material.',
      lengthLabel: '5 months',
      mode: 'Online',
      sessionLabel: '400+ classes',
      highlights: [
        'Paper 1 and Paper 2, full syllabus',
        '400+ classes',
        'Class tests and add-on material',
        'Online attendance from anywhere',
      ],
    ),
    Course(
      id: 'mppsc-mains',
      title: 'MPPSC Mains',
      track: ExamTrack.mppsc,
      summary:
          'Twelve months of detailed Mains coverage, special answer writing classes, and personal mentoring.',
      lengthLabel: '12 months',
      mode: 'Online',
      sessionLabel: '1500+ classes',
      highlights: [
        'Detailed coverage of the Mains syllabus',
        '1500+ classes',
        'Special answer writing classes',
        'Personal mentoring by the faculty',
      ],
    ),
    Course(
      id: 'mppsc-weekend',
      title: 'MPPSC Weekend',
      track: ExamTrack.mppsc,
      summary:
          'Saturday and Sunday classes for twelve months, with notes after every class and answer writing practice.',
      lengthLabel: '12 months',
      mode: 'Online',
      sessionLabel: 'Saturday & Sunday',
      highlights: [
        'Classes every Saturday and Sunday',
        'Notes for every class',
        'Special answer writing classes',
        'Personal mentoring by the faculty',
      ],
    ),
    Course(
      id: 'test-series',
      title: 'Prelims & Mains Test Series',
      track: ExamTrack.testSeries,
      summary:
          'Exam-style Prelims and Mains tests with copy evaluation, one-on-one feedback, and performance analytics.',
      lengthLabel: 'Ongoing',
      mode: 'Online',
      sessionLabel: 'Evaluated copies',
      highlights: [
        'Exam-simulated Prelims and Mains tests',
        'Detailed copy evaluation',
        'One-on-one feedback',
        'Performance analytics',
      ],
    ),
  ];

  static Course byId(String id) {
    return courses.firstWhere((course) => course.id == id);
  }

  static List<LiveClass> liveClasses() {
    final now = DateTime.now();
    return [
      LiveClass(
        id: 'polity-rights',
        title: 'Fundamental Rights: Articles 12–35',
        subject: 'Indian Polity',
        faculty: 'Polity faculty',
        batch: 'UPSC CSE Foundation',
        startsAt: now.subtract(const Duration(minutes: 22)),
        duration: const Duration(minutes: 90),
        status: LiveStatus.live,
        agenda: [
          'Article 12 and the definition of the State',
          'Equality, freedom, and protections against exploitation',
          'Writs and how they are asked in Prelims',
        ],
      ),
      LiveClass(
        id: 'mp-geography',
        title: 'Rivers and regions of Madhya Pradesh',
        subject: 'MP GK',
        faculty: 'MP GK faculty',
        batch: 'MPPSC State Services',
        startsAt: now.add(const Duration(minutes: 40)),
        duration: const Duration(minutes: 75),
        status: LiveStatus.upcoming,
        agenda: [
          'Narmada, Tapti, Chambal, Betwa, and Son',
          'Plateaus, districts, and map pointers',
          'Questions that repeat in MPPSC Prelims',
        ],
      ),
      LiveClass(
        id: 'answer-writing',
        title: 'Answer writing drill: 10 and 15 markers',
        subject: 'Mains practice',
        faculty: 'Answer writing faculty',
        batch: 'MPPSC Mains',
        startsAt: _atHour(now, 20),
        duration: const Duration(minutes: 60),
        status: LiveStatus.upcoming,
        agenda: [
          'Structure: introduction, body, and close',
          'Using MP examples without losing time',
          'A timed drill and what evaluators mark',
        ],
      ),
      LiveClass(
        id: 'current-affairs',
        title: 'Daily current affairs for Prelims',
        subject: 'Current affairs',
        faculty: 'Current affairs desk',
        batch: 'UPSC CSE Foundation',
        startsAt: _tomorrowAt(now, 7),
        duration: const Duration(minutes: 45),
        status: LiveStatus.upcoming,
        agenda: [
          'Headlines linked to the static syllabus',
          'Places, reports, and schemes in the news',
          'Ten rapid revision questions',
        ],
      ),
    ];
  }

  static DateTime _atHour(DateTime now, int hour) {
    final candidate = DateTime(now.year, now.month, now.day, hour);
    if (candidate.isAfter(now)) return candidate;
    return candidate.add(const Duration(days: 1));
  }

  static DateTime _tomorrowAt(DateTime now, int hour) {
    final tomorrow = DateTime(now.year, now.month, now.day + 1, hour);
    return tomorrow;
  }
}
