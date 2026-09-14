import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

import 'quote_summary_cell.dart';

/// 시가/고가/저가/거래량/시가총액을 보여주는 시세 요약입니다. (`03 · 종목상세`)
class QuoteSummary extends StatelessWidget {
  const QuoteSummary({super.key, required this.rows});

  final List<List<MapEntry<String, String>>> rows;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows)
          Padding(
            padding: EdgeInsets.only(
              bottom: row == rows.last ? 0 : dimens.space2,
            ),
            child: Row(
              children: [
                for (final entry in row) ...[
                  Expanded(
                    child: QuoteSummaryCell(
                      label: entry.key,
                      value: entry.value,
                    ),
                  ),
                  if (entry != row.last) SizedBox(width: dimens.space2),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
