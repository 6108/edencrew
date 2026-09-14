import '../models/daily_price.dart';
import 'repository/stock_repository.dart';

/// 종목 하나의 일별 시세 페이지를 캐싱합니다.
///
/// 기간 탭이 요구하는 페이지 수만큼만 요청하고, 이미 받은 페이지는
/// 재사용합니다. 예를 들어 `1개월`(2페이지)을 본 다음 `3개월`(6페이지)로
/// 바꾸면, 이미 있는 1~2페이지는 다시 요청하지 않고 3~6페이지만 받아옵니다.
/// `lastPage`를 넘는 페이지는 요청하지 않습니다.
class DailyPriceCache {
  DailyPriceCache(this._repository, this.symbol);

  final StockRepository _repository;
  final String symbol;

  final Map<int, List<DailyPrice>> _pages = {};
  int? _lastPage;

  /// [pageCount] 페이지까지의 일별 시세를 최신순(1페이지가 맨 앞)으로
  /// 이어붙여 반환합니다.
  Future<List<DailyPrice>> loadUpToPage(int pageCount) async {
    final targetPage = _lastPage == null
        ? pageCount
        : pageCount.clamp(1, _lastPage!);

    for (var page = 1; page <= targetPage; page++) {
      if (_pages.containsKey(page)) continue;

      final response = await _repository.getDailyPrices(symbol, page);
      _pages[page] = response.prices;
      _lastPage = response.lastPage;

      // 방금 받은 lastPage가 원래 목표보다 작으면 그 이상은 못 받으니 멈춥니다.
      if (page >= _lastPage!) break;
    }

    final maxAvailablePage = _lastPage == null
        ? targetPage
        : targetPage.clamp(1, _lastPage!);

    return [
      for (var page = 1; page <= maxAvailablePage; page++) ...?_pages[page],
    ];
  }
}
