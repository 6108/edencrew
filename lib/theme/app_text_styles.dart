import 'package:flutter/material.dart';

import 'app_typography.dart';

// Figma 텍스트 스타일(자간·행간 포함 타입 스케일)을 옮긴 토큰입니다.

@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.title,
    required this.body,
    required this.label,
    required this.caption,
    required this.displayPrice,
    required this.bodyNum,
    required this.captionNum,
  });

  const AppTextStyles.standard()
    : title = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 19,
        fontWeight: AppTypography.bold,
        letterSpacing: -0.2,
        height: 22 / 19,
      ),
      body = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        fontWeight: AppTypography.medium,
        letterSpacing: -0.1,
        height: 20 / 15,
      ),
      label = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        fontWeight: AppTypography.bold,
        height: 18 / 13,
      ),
      caption = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 11,
        fontWeight: AppTypography.regular,
        height: 14 / 11,
      ),
      displayPrice = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 30,
        fontWeight: AppTypography.bold,
        letterSpacing: -0.4,
        height: 36 / 30,
      ),
      // Figma에서 body / body__num, caption / caption__num은 수치상 완전히
      // 동일합니다 (숫자용은 아마 그리드 정렬 등 별도 처리를 염두에 둔
      // 이름 분리로 보입니다). 값이 같아도 의미가 다르므로 토큰은 나눠 두고,
      // 화면 코드에서는 숫자를 표시할 때 `bodyNum`/`captionNum`을 쓰는
      // 식으로 구분해서 쓰시면 됩니다.
      bodyNum = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 15,
        fontWeight: AppTypography.medium,
        letterSpacing: -0.1,
        height: 20 / 15,
      ),
      captionNum = const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 11,
        fontWeight: AppTypography.regular,
        height: 14 / 11,
      );

  /// `19 / Bold` — 화면·섹션 타이틀. (예: "관심", "정렬", 빈 상태 타이틀)
  final TextStyle title;

  /// `15 / Medium` — 본문 텍스트. (예: 종목명, 입력창 텍스트)
  final TextStyle body;

  /// `13 / Bold` — 라벨. (예: 정렬 칩, 토스트 메시지, 섹션 소제목)
  final TextStyle label;

  /// `11 / Regular` — 캡션. (예: 종목코드·시장, 안내 문구)
  final TextStyle caption;

  /// `30 / Bold` — 큰 가격 표시. (상세 화면 현재가)
  final TextStyle displayPrice;

  /// `15 / Medium`, 숫자 전용. (예: 관심/검색 행의 가격)
  final TextStyle bodyNum;

  /// `11 / Regular`, 숫자 전용. (예: 등락폭, 거래량)
  final TextStyle captionNum;

  @override
  AppTextStyles copyWith({
    TextStyle? title,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? displayPrice,
    TextStyle? bodyNum,
    TextStyle? captionNum,
  }) {
    return AppTextStyles(
      title: title ?? this.title,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
      displayPrice: displayPrice ?? this.displayPrice,
      bodyNum: bodyNum ?? this.bodyNum,
      captionNum: captionNum ?? this.captionNum,
    );
  }

  @override
  AppTextStyles lerp(covariant AppTextStyles? other, double t) {
    if (other == null) return this;
    return AppTextStyles(
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      displayPrice: TextStyle.lerp(displayPrice, other.displayPrice, t)!,
      bodyNum: TextStyle.lerp(bodyNum, other.bodyNum, t)!,
      captionNum: TextStyle.lerp(captionNum, other.captionNum, t)!,
    );
  }
}
