import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AagaazMark extends StatelessWidget {
  const AagaazMark({
    super.key,
    this.size = 56,
    this.onDark = false,
  });

  final double size;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Aagaaz Institute',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onDark ? AppColors.saffron : AppColors.ink,
          borderRadius: BorderRadius.circular(size * 0.28),
        ),
        alignment: Alignment.center,
        child: Text(
          'Aa',
          style: TextStyle(
            color: onDark ? AppColors.ink : AppColors.saffron,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}
