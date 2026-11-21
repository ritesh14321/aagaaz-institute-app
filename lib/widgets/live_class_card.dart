import 'package:flutter/material.dart';

import '../models/live_class.dart';
import '../theme/app_colors.dart';
import '../utils/schedule.dart';

class LiveClassCard extends StatelessWidget {
  const LiveClassCard({
    super.key,
    required this.item,
    required this.onOpen,
    this.width = 268,
  });

  final LiveClass item;
  final VoidCallback onOpen;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillHeight = constraints.maxHeight.isFinite;
          return Material(
            color: item.isLive ? AppColors.ink : AppColors.paper,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              key: Key('live-${item.id}'),
              borderRadius: BorderRadius.circular(18),
              onTap: onOpen,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: item.isLive ? AppColors.ink : AppColors.line,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (item.isLive) const _LiveBadge() else const _UpcomingBadge(),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.batch,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: item.isLive ? const Color(0xFFD5DEEA) : AppColors.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        item.subject,
                        style: TextStyle(
                          color: item.isLive ? AppColors.saffron : AppColors.clay,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.isLive ? Colors.white : AppColors.ink,
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (fillHeight) const Spacer() else const SizedBox(height: 16),
                      Text(
                        item.faculty,
                        style: TextStyle(
                          color: item.isLive ? const Color(0xFFD5DEEA) : AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatSchedule(item),
                        style: TextStyle(
                          color: item.isLive ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton(
                          onPressed: onOpen,
                          style: FilledButton.styleFrom(
                            backgroundColor: item.isLive ? AppColors.saffron : AppColors.ink,
                            foregroundColor: item.isLive ? AppColors.inkDeep : Colors.white,
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            textStyle: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          child: Text(item.isLive ? 'Join class' : 'View details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.live,
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: Colors.white),
          SizedBox(width: 6),
          Text(
            'LIVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingBadge extends StatelessWidget {
  const _UpcomingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Text(
        'UPCOMING',
        style: TextStyle(
          color: AppColors.ink,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
