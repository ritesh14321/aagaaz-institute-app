import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../theme/app_colors.dart';
import '../utils/schedule.dart';

class ClassroomScreen extends StatelessWidget {
  const ClassroomScreen({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    final item = Catalog.liveClasses().firstWhere((entry) => entry.id == classId);

    return Scaffold(
      backgroundColor: AppColors.inkDeep,
      appBar: AppBar(
        backgroundColor: AppColors.inkDeep,
        foregroundColor: Colors.white,
        title: Text(item.subject),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF18283F),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2C415F)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.isLive ? Icons.play_circle_fill : Icons.schedule,
                    color: AppColors.saffron,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.isLive ? 'Live classroom' : 'Scheduled session',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.isLive
                        ? 'Video plays here when the batch stream is connected.'
                        : 'Opens when the class goes live.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFD5DEEA)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.faculty} · ${item.batch}',
            style: const TextStyle(color: Color(0xFFD5DEEA)),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatSchedule(item)} · ${item.duration.inMinutes} min',
            style: const TextStyle(
              color: AppColors.saffron,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'In this class',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          for (final point in item.agenda)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(color: AppColors.saffron)),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
