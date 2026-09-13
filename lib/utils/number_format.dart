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
