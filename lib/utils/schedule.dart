import '../models/live_class.dart';

String formatClock(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

String formatSchedule(LiveClass item) {
  if (item.isLive) {
    final elapsed = DateTime.now().difference(item.startsAt).inMinutes;
    final shown = elapsed < 1 ? 1 : elapsed;
    return 'Started $shown min ago';
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final startDay = DateTime(
    item.startsAt.year,
    item.startsAt.month,
    item.startsAt.day,
  );
  final dayLabel = switch (startDay.difference(today).inDays) {
    0 => 'Today',
    1 => 'Tomorrow',
    _ => '${item.startsAt.day}/${item.startsAt.month}',
  };
  return '$dayLabel · ${formatClock(item.startsAt)}';
}
