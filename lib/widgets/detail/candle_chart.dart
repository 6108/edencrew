import 'package:flutter/material.dart';

import '../../models/daily_price.dart';
import '../../theme/theme.dart';

/// 캔들 차트. (`03 · 종목상세`)
class CandleChart extends StatelessWidget {
  const CandleChart({super.key, required this.prices, this.height = 200});

  final List<DailyPrice> prices;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (prices.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            '차트 데이터가 없습니다.',
            style: context.textStyles.caption.copyWith(
              color: colors.textTertiary,
            ),
          ),
        ),
      );
    }

    final ascending = prices.reversed.toList();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _CandleChartPainter(
          prices: ascending,
          upColor: colors.chartLineUp,
          downColor: colors.chartLineDown,
          flatColor: colors.chartLineFlat,
        ),
      ),
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  _CandleChartPainter({
    required this.prices,
    required this.upColor,
    required this.downColor,
    required this.flatColor,
  });

  final List<DailyPrice> prices;
  final Color upColor;
  final Color downColor;
  final Color flatColor;

  @override
  void paint(Canvas canvas, Size size) {
    final highs = prices.map((p) => p.highPrice);
    final lows = prices.map((p) => p.lowPrice);
    final maxPrice = highs.reduce((a, b) => a > b ? a : b);
    final minPrice = lows.reduce((a, b) => a < b ? a : b);
    final range = (maxPrice - minPrice) == 0 ? 1 : maxPrice - minPrice;

    final slotWidth = size.width / prices.length;
    final candleWidth = (slotWidth * 0.6).clamp(1.0, 12.0);
    final wickWidth = (candleWidth * 0.1);

    double yFor(int price) {
      final ratio = (price - minPrice) / range;
      return size.height - (ratio * size.height);
    }

    for (var i = 0; i < prices.length; i++) {
      final price = prices[i];
      final centerX = slotWidth * i + slotWidth / 2;

      final bodyColor = price.closePrice > price.openPrice
          ? upColor
          : price.closePrice < price.openPrice
          ? downColor
          : flatColor;

      // 꼬리(고가~저가)는 Figma 확인 결과 몸통 색과 무관하게 항상 회색
      // (chartLineFlat) 계열로 표시됩니다.
      final wickPaint = Paint()
        ..color = flatColor
        ..strokeWidth = wickWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(centerX, yFor(price.highPrice)),
        Offset(centerX, yFor(price.lowPrice)),
        wickPaint,
      );

      final bodyTop = yFor(
        price.closePrice > price.openPrice ? price.closePrice : price.openPrice,
      );
      final bodyBottom = yFor(
        price.closePrice > price.openPrice ? price.openPrice : price.closePrice,
      );
      final bodyHeight = (bodyBottom - bodyTop).abs().clamp(
        1.0,
        double.infinity,
      );

      final bodyPaint = Paint()..color = bodyColor;
      canvas.drawRect(
        Rect.fromLTWH(
          centerX - candleWidth / 2,
          bodyTop,
          candleWidth,
          bodyHeight,
        ),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) {
    return oldDelegate.prices != prices;
  }
}
