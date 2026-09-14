import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 시세 요약의 개별 항목입니다. (`03 · 종목상세`)
class QuoteSummaryCell extends StatelessWidget {
  const QuoteSummaryCell({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space3 - 2,
        vertical: dimens.space2 + 1,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceSunken,
        borderRadius: BorderRadius.circular(dimens.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyles.caption.copyWith(
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: dimens.space1),
          Text(
            value,
            style: context.textStyles.bodyNum.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
