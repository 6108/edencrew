/// 상세 화면 차트 기간 탭. (`1개월` / `3개월` / `6개월` / `1년`)
enum ChartPeriod {
  oneMonth('1개월', 2),
  threeMonths('3개월', 6),
  sixMonths('6개월', 12),
  oneYear('1년', 25);

  const ChartPeriod(this.label, this.pageCount);

  final String label;
  final int pageCount;
}
