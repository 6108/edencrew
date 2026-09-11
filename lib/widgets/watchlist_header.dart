import 'package:flutter/material.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key});

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
        children: [
          Text(
            '관심',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: AppTypography.bold,
            ),
          ),
          const Spacer(),
          Text(
            '가나다순',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
          Icon(
            Icons.expand_more,
            size: dimens.iconSm,
            color: colors.textSecondary,
          ),
          SizedBox(width: dimens.space2),
          Icon(Icons.refresh, color: colors.textSecondary),
        ],
      ),
    );
  }
}
