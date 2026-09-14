/// 일별 시세 표(`DailyQuoteTable`) 한 행에 필요한 표시용 데이터입니다.
class DailyQuoteRowItem {
  const DailyQuoteRowItem({
    required this.dateLabel,
    required this.close,
    required this.changeAmount,
    required this.volume,
  });

  /// `MM.DD` 형태로 이미 포맷된 날짜.
  final String dateLabel;
  final int close;
  final int changeAmount;
  final int volume;
}
