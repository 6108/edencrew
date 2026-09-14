import 'package:edencrew_assignment_starter/widgets/common/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.star, label: '관심'),
    (icon: Icons.search, label: '검색'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dimens.tabBarHeight,
      color: context.colors.surfaceBase,
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: BottomNavItem(
                icon: _items[i].icon,
                label: _items[i].label,
                selected: currentIndex == i,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}
