/// 관심 화면 UI 상태를 표현하는 모델입니다.
/// 등락 방향. 상승/하락 색상은 국내 시장 관행(상승=빨강, 하락=파랑)을 따릅니다.
enum PriceDirection { up, down, flat }

class WatchlistItem {
  const WatchlistItem({
    required this.symbol,
    required this.name,
    required this.market,
    this.price,
    this.changeAmount,
    this.changeRatePercent,
    this.direction = PriceDirection.flat,
    this.isLoading = false,
  });

  /// 6자리 종목코드.
  final String symbol;
  final String name;

  /// 예: `코스피`, `코스닥`.
  final String market;

  /// 시세를 아직 받지 못했다면(`isLoading`) null 입니다.
  final int? price;
  final int? changeAmount;
  final double? changeRatePercent;
  final PriceDirection direction;

  /// 아직 시세를 받지 못한 행. `feedbackSkeleton` 스타일로 표시합니다.
  final bool isLoading;

  /// `005930 · 코스피` 형태.
  String get codeAndMarket => '$symbol · $market';
}

/// 정렬 바텀시트(`01 · 관심_sort`)의 세 가지 기준입니다.
enum WatchlistSortOption {
  priceDesc('현재가순'),
  changeRateDesc('등락률순'),
  nameAsc('가나다순');

  const WatchlistSortOption(this.label);

  /// 헤더 칩과 바텀시트에 그대로 노출되는 문구입니다.
  final String label;
}
