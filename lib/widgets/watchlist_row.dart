import 'package:flutter/material.dart';

import '../models/watchlist_item.dart';
import '../theme/theme.dart';
import '../utils/number_format.dart';

/// 관심 목록의 행 하나입니다. (`01 · 관심` / `01 · 관심_sort` 프레임의 리스트 아이템)
///
/// 시세를 아직 받지 못한 경우(`item.isLoading`) `feedbackSkeleton` 색상의
/// 스켈레톤 바로 대체합니다.
class WatchlistRow extends StatelessWidget {
  const WatchlistRow({super.key, required this.item, this.onTap});

  final WatchlistItem item;
  final VoidCallback? onTap;

  Color _changeColor(AppColors colors) {
    switch (item.direction) {
      case PriceDirection.up:
        return colors.priceUpText;
      case PriceDirection.down:
        return colors.priceDownText;
      case PriceDirection.flat:
        return colors.priceFlatText;
    }
  }

  Widget _skeletonBar(
    AppColors colors,
    AppDimens dimens,
    double width,
    double height,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.feedbackSkeleton,
        borderRadius: BorderRadius.circular(dimens.radiusSm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final textStyles = context.textStyles;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dimens.space4,
            vertical: dimens.space3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyles.body.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: dimens.space1),
                    Text(
                      item.codeAndMarket,
                      style: textStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: dimens.space4),
              if (item.isLoading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _skeletonBar(colors, dimens, 64, 16),
                    SizedBox(height: dimens.space1),
                    _skeletonBar(colors, dimens, 48, 12),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatThousands(item.price ?? 0),
                      style: textStyles.bodyNum.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: dimens.space1),
                    Text(
                      _formatChange(
                        item.changeAmount ?? 0,
                        item.changeRatePercent ?? 0,
                      ),
                      style: textStyles.captionNum.copyWith(
                        color: _changeColor(colors),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 등락 표기. 예: `-400 (-0.22%)`, `+9,500 (+2.36%)`, `0 (0.00%)`
String _formatChange(int changeAmount, double changeRatePercent) {
  final amountText = changeAmount > 0
      ? '+${formatThousands(changeAmount)}'
      : formatThousands(changeAmount); // 0, 음수는 그대로 (음수는 이미 '-' 포함)
  final rateSign = changeRatePercent > 0 ? '+' : '';
  final rateText = '$rateSign${changeRatePercent.toStringAsFixed(2)}%';
  return '$amountText ($rateText)';
}
