/// 1000 단위 콤마. 예: `1234567` → `1,234,567`, `-400` → `-400`
///
/// 관심/상세/일별 시세 표에서 공통으로 쓰는 순수 숫자 포맷 함수입니다.
String formatThousands(int value) {
  final isNegative = value < 0;
  final digits = value.abs().toString();

  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }

  return isNegative ? '-${buffer.toString()}' : buffer.toString();
}

/// 거래량 축약 표기. 천 단위로 나눠 반올림하고 `천`을 붙입니다.
/// 예: `29113456` → `29,113천`
String formatVolumeAbbreviated(int volume) {
  return '${formatThousands((volume / 1000).round())}천';
}

/// 시가총액 축약 표기. 조(10^12) 단위로 나눠 반올림하고 `조`를 붙입니다.
/// 예: `1063200000000000` → `1,063,200조`
String formatMarketCapAbbreviated(int marketCap) {
  return '${formatThousands((marketCap / 1000000000000).round())}조';
}
