import 'package:flutter/material.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({
    super.key,
    required this.sortLabel,
    required this.onSortTap,
    required this.onRefreshTap,
  });

  /// 현재 정렬 기준 문구. 예: `가나다순`, `현재가순`, `등락률순`.
  final String sortLabel;

  /// 정렬 칩(문구 + 화살표)을 눌렀을 때. 정렬 바텀시트를 엽니다.
  final VoidCallback onSortTap;

  /// 새로고침 아이콘을 눌렀을 때. 시세를 다시 조회합니다.
  final VoidCallback onRefreshTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;
    final textStyles = context.textStyles;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dimens.space4,
        vertical: dimens.space3,
      ),
      child: Row(
        children: [
          Text(
            '관심',
            style: textStyles.title.copyWith(color: colors.textPrimary),
          ),
          const Spacer(),
          InkWell(
            onTap: onSortTap,
            child: Row(
              children: [
                Text(
                  sortLabel,
                  style: textStyles.label.copyWith(color: colors.textSecondary),
                ),
                Icon(
                  Icons.expand_more,
                  size: dimens.iconSm,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
          SizedBox(width: dimens.space2),
          InkWell(
            onTap: onRefreshTap,
            child: Icon(Icons.refresh, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
