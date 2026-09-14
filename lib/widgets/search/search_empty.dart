import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// 검색어를 입력하기 전 빈 화면
class SearchEmpty extends StatelessWidget {
  const SearchEmpty({super.key});

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
            Icon(Icons.search, size: 40, color: colors.textTertiary),
            SizedBox(height: dimens.space4),
            Text(
              '종목을 검색해 보세요',
              style: context.textStyles.title.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: dimens.space2),
            Text(
              '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
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
