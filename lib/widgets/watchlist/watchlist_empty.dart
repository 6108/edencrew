import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// 관심종목이 없을 때의 빈 상태입니다.
class WatchlistEmpty extends StatelessWidget {
  const WatchlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 40, color: colors.textTertiary),
            SizedBox(height: dimens.space4),
            Text(
              '관심 종목이 없습니다',
              style: context.textStyles.title.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: dimens.space2),
            Text(
              '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
              textAlign: TextAlign.center,
              style: context.textStyles.caption.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
