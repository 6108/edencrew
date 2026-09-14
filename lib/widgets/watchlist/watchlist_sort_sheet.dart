import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/models/watchlist_item.dart';
import '../../theme/theme.dart';
import 'watchlist_sort_option_row.dart';

/// 관심 화면 정렬 바텀시트입니다. (`01 · 관심_sort`)
///
/// 선택된 항목에는 체크 아이콘이 붙고, 나머지 항목은 `textSecondary`로
/// 표시됩니다.
class WatchlistSortSheet extends StatelessWidget {
  const WatchlistSortSheet({super.key, required this.selected});

  final WatchlistSortOption selected;

  /// 바텀시트를 띄우고 선택 결과를 반환합니다.
  /// 닫기(드래그 다운, 바깥 탭 등)로 아무것도 선택하지 않으면 null을 반환합니다.
  static Future<WatchlistSortOption?> show(
    BuildContext context, {
    required WatchlistSortOption selected,
  }) {
    return showModalBottomSheet<WatchlistSortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => WatchlistSortSheet(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 34),
      decoration: BoxDecoration(
        color: colors.surfaceOverlay,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimens.radiusXl),
          topRight: Radius.circular(dimens.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 64,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: dimens.space6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '정렬',
                  style: context.textStyles.title.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          for (final option in WatchlistSortOption.values)
            WatchlistSortOptionRow(
              option: option,
              isSelected: option == selected,
              onTap: () => Navigator.of(context).pop(option),
            ),
        ],
      ),
    );
  }
}
