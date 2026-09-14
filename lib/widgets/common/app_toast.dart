import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// 관심 등록/해제 토스트입니다. (`04 · 관심 등록 토스트` / `05 · 관심 해제 토스트`)
///
/// 검색 화면, 상세 화면 등 관심 등록 액션이 있는 모든 곳에서 재사용합니다.
class AppToast {
  const AppToast._();

  static void show(BuildContext context, {required bool isFavorite}) {
    final colors = context.colors;
    final dimens = context.dimens;
    final textStyles = context.textStyles;
    final message = isFavorite ? '관심이 등록되었습니다' : '관심이 해제되었습니다';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          padding: EdgeInsets.zero,
          margin: EdgeInsets.only(
            left: dimens.space4,
            right: dimens.space4,
            bottom: dimens.space4,
          ),
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.space4,
              vertical: dimens.space3 + 2,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: BorderRadius.circular(dimens.radiusLg),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.55),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  size: 18,
                  color: isFavorite
                      ? colors.favoriteActive
                      : colors.textSecondary,
                ),
                SizedBox(width: dimens.space3 - 2),
                Expanded(
                  child: Text(
                    message,
                    style: textStyles.label.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
