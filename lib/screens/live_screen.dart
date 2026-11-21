import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/live_class.dart';
import '../theme/app_colors.dart';
import '../widgets/live_class_card.dart';
import 'classroom_screen.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = Catalog.liveClasses();
    final live = classes.where((item) => item.isLive).toList();
    final upcoming = classes.where((item) => !item.isLive).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text(
            'Live classes',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Join a class in progress, or open an upcoming session.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          if (live.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _GroupLabel('On air'),
            const SizedBox(height: 12),
            for (final item in live) ...[
              _FullWidthClass(item: item),
              const SizedBox(height: 12),
            ],
          ],
          const SizedBox(height: 8),
          const _GroupLabel('Later'),
          const SizedBox(height: 12),
          for (var i = 0; i < upcoming.length; i++) ...[
            _FullWidthClass(item: upcoming[i]),
            if (i != upcoming.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _FullWidthClass extends StatelessWidget {
  const _FullWidthClass({required this.item});

  final LiveClass item;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LiveClassCard(
          item: item,
          width: constraints.maxWidth,
          onOpen: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ClassroomScreen(classId: item.id),
              ),
            );
          },
        );
      },
    );
  }
}
