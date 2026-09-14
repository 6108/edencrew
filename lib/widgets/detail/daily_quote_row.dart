import 'package:edencrew_assignment_starter/models/daily_quote_item.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/utils/number_format.dart';
import 'package:flutter/material.dart';

/// 일별 시세 표(`DailyQuoteTable`)의 한 행. 헤더 행도 이 위젯과 컬럼 비율을
/// 맞춰서 같이 그립니다.
class DailyQuoteRow extends StatelessWidget {
  const DailyQuoteRow({super.key, required this.data});

  final DailyQuoteRowItem data;

  Color _changeColor(BuildContext context) {
    final colors = context.colors;
    if (data.changeAmount > 0) return colors.priceUpText;
    if (data.changeAmount < 0) return colors.priceDownText;
    return colors.priceFlatText;
  }

  String get _signedChange {
    if (data.changeAmount == 0) return '0';
    final sign = data.changeAmount > 0 ? '+' : '-';
    return '$sign${formatThousands(data.changeAmount.abs())}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final numStyle = context.textStyles.captionNum;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimens.space2 - 1),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              data.dateLabel,
              style: context.textStyles.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatThousands(data.close),
              textAlign: TextAlign.right,
              style: numStyle.copyWith(color: colors.textPrimary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _signedChange,
              textAlign: TextAlign.right,
              style: numStyle.copyWith(color: _changeColor(context)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              formatThousands(data.volume),
              textAlign: TextAlign.right,
              style: numStyle.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
