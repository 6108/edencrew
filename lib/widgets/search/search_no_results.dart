import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// 검색 결과가 없을 때의 빈 상태입니다. (`02 · 검색결과_empty`)
///
/// 안내 문구에 사용자가 입력한 검색어가 그대로 들어갑니다.
class SearchNoResults extends StatelessWidget {
  const SearchNoResults({super.key, required this.query});

  final String query;

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
            Icon(Icons.search_off, size: 40, color: colors.textTertiary),
            SizedBox(height: dimens.space4),
            Text(
              '검색 결과가 없습니다',
              style: context.textStyles.title.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: dimens.space2),
            Text(
              "'$query'와 일치하는 검색 결과를 찾지 못했습니다.",
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
