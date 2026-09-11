import 'package:flutter/material.dart';
import '../theme/theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Container(
      height: dimens.tabBarHeight,
      color: colors.surfaceBase,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: colors.navActive),
                Text(
                  '관심',
                  style: TextStyle(color: colors.navActive, fontSize: 11),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, color: colors.navInactive),
                Text(
                  '검색',
                  style: TextStyle(color: colors.navInactive, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
