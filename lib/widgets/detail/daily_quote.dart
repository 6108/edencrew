import 'package:edencrew_assignment_starter/models/daily_quote_item.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

import 'daily_quote_row.dart';

/// 일별 시세 표입니다. (`03 · 종목상세`)
class DailyQuote extends StatelessWidget {
  const DailyQuote({super.key, required this.rows});

  final List<DailyQuoteRowItem> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final headerStyle = context.textStyles.caption.copyWith(
      color: colors.textSecondary,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '일별 시세',
            style: context.textStyles.label.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: dimens.space2),
          Padding(
            padding: EdgeInsets.symmetric(vertical: dimens.space2 - 1),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('날짜', style: headerStyle)),
                Expanded(
                  flex: 3,
                  child: Text(
                    '종가',
                    textAlign: TextAlign.right,
                    style: headerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '등락',
                    textAlign: TextAlign.right,
                    style: headerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '거래량',
                    textAlign: TextAlign.right,
                    style: headerStyle,
                  ),
                ),
              ],
            ),
          ),
          for (final row in rows) DailyQuoteRow(data: row),
        ],
      ),
    );
  }
}
