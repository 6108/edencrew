import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/utils/number_format.dart';
import 'package:flutter/material.dart';

/// 상세 화면의 큰 가격 + 등락 표시입니다.
///
/// 관심/검색 행과 표기 형식이 달라 별도 포맷을 씁니다
class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.price,
    required this.changeAmount,
    required this.changeRatePercent,
  });

  final int price;
  final int changeAmount;
  final double changeRatePercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final textStyles = context.textStyles;

    final color = changeAmount > 0
        ? colors.priceUpText
        : changeAmount < 0
        ? colors.priceDownText
        : colors.priceFlatText;
    final arrow = changeAmount > 0 ? '▲' : (changeAmount < 0 ? '▼' : '-');
    final rateSign = changeRatePercent > 0 ? '+' : '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimens.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            formatThousands(price),
            style: textStyles.displayPrice.copyWith(color: colors.textPrimary),
          ),
          SizedBox(width: dimens.space2),
          Text(
            '$arrow ${formatThousands(changeAmount.abs())} ($rateSign${changeRatePercent.toStringAsFixed(2)}%)',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: AppTypography.regular,
            ),
          ),
        ],
      ),
    );
  }
}
