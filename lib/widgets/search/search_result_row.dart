import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/models/stock.dart';
import '../../theme/theme.dart';

/// 검색 결과 행 하나입니다. (`02 · 검색`)
///
/// 관심 등록 여부(`isFavorite`)는 이 위젯이 직접 들고 있지 않고, 화면이
/// 넘겨줍니다 (전역 상태는 한 곳에서만 구독하는 게 좋아서 위젯 자체는
/// 상태를 모르게 뒀습니다).
class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    super.key,
    required this.stock,
    required this.query,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Stock stock;
  final String query;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  /// 종목명에서 검색어와 일치하는 부분을 `searchHighlight` 색으로 강조
  /// 대소문자 무시, 첫 번째 일치 구간만 강조
  Widget _highlightedName(BuildContext context) {
    final colors = context.colors;
    final style = context.textStyles.body.copyWith(color: colors.textPrimary);

    if (query.isEmpty) return Text(stock.name, style: style);

    final matchIndex = stock.name.toLowerCase().indexOf(query.toLowerCase());
    if (matchIndex < 0) return Text(stock.name, style: style);

    final matchEnd = matchIndex + query.length;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: stock.name.substring(0, matchIndex)),
          TextSpan(
            text: stock.name.substring(matchIndex, matchEnd),
            style: style.copyWith(color: colors.searchHighlight),
          ),
          TextSpan(text: stock.name.substring(matchEnd)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

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
                    _highlightedName(context),
                    SizedBox(height: dimens.space1),
                    Text(
                      '${stock.symbol} · ${stock.market}',
                      style: context.textStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: dimens.space4),
              InkWell(
                onTap: onFavoriteTap,
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  size: dimens.iconMd + 2,
                  color: isFavorite
                      ? colors.favoriteActive
                      : colors.favoriteInactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
