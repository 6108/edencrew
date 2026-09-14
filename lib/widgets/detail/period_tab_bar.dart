import 'package:edencrew_assignment_starter/models/chart_period.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 차트 기간 선택 탭입니다. (`1개월` / `3개월` / `6개월` / `1년`)
class PeriodTabBar extends StatelessWidget {
  const PeriodTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onSelected;

  Widget _chip(BuildContext context, ChartPeriod period) {
    final colors = context.colors;
    final dimens = context.dimens;
    final isSelected = period == selected;

    return InkWell(
      borderRadius: BorderRadius.circular(dimens.radiusMd),
      onTap: () => onSelected(period),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space3,
          vertical: dimens.space1 + 1,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.accentBg : Colors.transparent,
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Text(
          period.label,
          style: TextStyle(
            color: isSelected ? colors.accentDefault : colors.textSecondary,
            fontSize: 13,
            fontWeight: AppTypography.regular,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        for (final period in ChartPeriod.values)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: period == ChartPeriod.values.last ? 0 : dimens.space2,
              ),
              child: _chip(context, period),
            ),
          ),
      ],
    );
  }
}
