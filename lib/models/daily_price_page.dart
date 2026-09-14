import 'daily_price.dart';

/// 일별 시세 한 페이지 응답. `lastPage`를 함께 들고 있어야 그 이상 페이지를 요청하지 않도록 막을 수 있습니다.
class DailyPricePage {
  const DailyPricePage({required this.prices, required this.lastPage});

  final List<DailyPrice> prices;
  final int lastPage;
}
