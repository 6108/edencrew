import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:flutter/material.dart';

/// 상세 화면 상단 헤더입니다. (`03 · 종목상세`)
///
/// 뒤로가기, 종목명, `종목코드 · 시장`, 관심 등록 별 아이콘.
class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.name,
    required this.codeAndMarket,
    required this.isFavorite,
    required this.onBackTap,
    required this.onFavoriteTap,
  });

  final String name;
  final String codeAndMarket;
  final bool isFavorite;
  final VoidCallback onBackTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dimens.space1),
            child: InkWell(
              onTap: onBackTap,
              child: Icon(
                Icons.arrow_back,
                size: dimens.iconMd,
                color: colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: dimens.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textStyles.body.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  codeAndMarket,
                  style: context.textStyles.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: dimens.space1),
            child: InkWell(
              onTap: onFavoriteTap,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                size: dimens.iconMd + 2,
                color: isFavorite
                    ? colors.favoriteActive
                    : colors.favoriteInactive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
