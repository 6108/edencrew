import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import 'package:edencrew_assignment_starter/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist_empty.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist_header.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist_row.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

const List<String> _watchedSymbols = [
  '005930', // 삼성전자
  '000660', // SK하이닉스
  '005380', // 현대차
  '035420', // NAVER
  '035720', // 카카오
];

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  final _repository = StockRepository(MockNaverApi());

  late Future<List<WatchlistItem>> _future;

  // TODO: 정렬 바텀시트(WatchlistSortSheet) 연결 시 실제 옵션 전환 로직으로 교체.
  WatchlistSortOption _sortOption = WatchlistSortOption.nameAsc;

  void _onSortTap() {
    // TODO: WatchlistSortSheet.show(context, selected: _sortOption) 연결.
  }

  void _onRefreshTap() {
    // TODO: 시세 재조회 로직 연결 (NAVER_API.md 실시간 시세 endpoint 참고).
  }

  @override
  void initState() {
    super.initState();
    _future = _loadWatchlist();
  }

  Future<List<WatchlistItem>> _loadWatchlist() async {
    if (_watchedSymbols.isEmpty) return [];

    // 메타데이터(이름·시장)는 종목마다 따로, 시세는 한 번에 요청.
    final metadataList = await Future.wait(
      _watchedSymbols.map(_repository.getStockMetadata),
    );
    final realtimeBySymbol = await _repository.getRealtimeStocks(
      _watchedSymbols,
    );

    return metadataList.map((meta) {
      final realtime = realtimeBySymbol[meta.symbol];

      if (realtime == null) {
        return WatchlistItem(
          symbol: meta.symbol,
          name: meta.name,
          market: meta.market,
          isLoading: true,
        );
      }

      return WatchlistItem(
        symbol: meta.symbol,
        name: meta.name,
        market: meta.market,
        price: realtime.currentPrice,
        changeAmount: realtime.changeAmount,
        changeRatePercent: realtime.changeRate * 100,
        direction: _directionOf(realtime),
      );
    }).toList();
  }

  PriceDirection _directionOf(Stock stock) {
    if (stock.changeAmount > 0) return PriceDirection.up;
    if (stock.changeAmount < 0) return PriceDirection.down;
    return PriceDirection.flat;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            WatchlistHeader(
              sortLabel: _sortOption.label,
              onSortTap: _onSortTap,
              onRefreshTap: _onRefreshTap,
            ),
            Expanded(
              child: FutureBuilder<List<WatchlistItem>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '오류: ${snapshot.error}',
                        style: context.textStyles.caption.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;

                  if (items.isEmpty) {
                    return const WatchlistEmpty();
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colors.borderSubtle),
                    itemBuilder: (context, index) =>
                        WatchlistRow(item: items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
