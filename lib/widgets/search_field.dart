import 'package:flutter/material.dart';

import '../theme/theme.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        dimens.space4,
        dimens.space2,
        dimens.space4,
        dimens.space3,
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colors.surfaceSunken,
          border: Border.all(color: colors.borderStrong, width: 1),
          borderRadius: BorderRadius.circular(dimens.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: dimens.iconSm, color: colors.textTertiary),
            SizedBox(width: dimens.space2),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textAlignVertical: TextAlignVertical.center,
                style: context.textStyles.body.copyWith(
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '종목명 또는 종목코드',
                  hintStyle: context.textStyles.body.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) {
                  return const SizedBox.shrink();
                }

                return InkWell(
                  onTap: onClear,
                  child: Icon(
                    Icons.close,
                    size: dimens.iconSm,
                    color: colors.textTertiary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
