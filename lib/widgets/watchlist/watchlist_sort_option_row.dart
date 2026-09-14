import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/models/watchlist_item.dart';
import '../../theme/theme.dart';

class WatchlistSortOptionRow extends StatelessWidget {
  const WatchlistSortOptionRow({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final WatchlistSortOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: dimens.rowMinHeight),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: dimens.space6),
          child: Row(
            children: [
              Text(
                option.label,
                style: context.textStyles.body.copyWith(
                  color: isSelected ? colors.textPrimary : colors.textSecondary,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: colors.textPrimary,
                  size: dimens.iconMd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
