import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import 'package:edencrew_assignment_starter/models/watchlist_item.dart';
import 'package:edencrew_assignment_starter/screens/stock_detail_screen.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist/watchlist_empty.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist/watchlist_header.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist/watchlist_row.dart';
import 'package:edencrew_assignment_starter/widgets/watchlist/watchlist_sort_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watchlist_provider.dart';
import '../theme/theme.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  final _repository = StockRepository(MockNaverApi());

  Future<List<WatchlistItem>>? _future;
  // null이면 "아직 한 번도 로드 안 함"을 뜻합니다. 빈 리스트([])와 구분하기
  // 위해 nullable로 둡니다 — 안 그러면 관심종목이 원래 0개일 때
  // listEquals([], [])가 true가 돼서 최초 로드가 아예 트리거되지 않습니다.
  List<String>? _loadedSymbols;

  WatchlistSortOption _sortOption = WatchlistSortOption.nameAsc;

  Future<void> _onSortTap() async {
    final selected = await WatchlistSortSheet.show(
      context,
      selected: _sortOption,
    );
    if (selected != null && selected != _sortOption) {
      setState(() => _sortOption = selected);
    }
  }

  void _onRefreshTap() {
    setState(() {
      _future = _loadWatchlist(_loadedSymbols ?? const []);
    });
  }

  Future<List<WatchlistItem>> _loadWatchlist(List<String> symbols) async {
    if (symbols.isEmpty) return [];

    // 메타데이터(이름·시장)는 종목마다 따로, 시세는 한 번에 요청.
    final metadataList = await Future.wait(
      symbols.map(_repository.getStockMetadata),
    );
    final realtimeBySymbol = await _repository.getRealtimeStocks(symbols);

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

  // 시세를 아직 못 받은 행(스켈레톤)은 정렬 기준과 무관하게 항상 맨 뒤에
  List<WatchlistItem> _sorted(List<WatchlistItem> items) {
    final sorted = List.of(items);
    sorted.sort((a, b) {
      if (a.isLoading != b.isLoading) {
        return a.isLoading ? 1 : -1;
      }
      switch (_sortOption) {
        case WatchlistSortOption.priceDesc:
          return (b.price ?? 0).compareTo(a.price ?? 0);
        case WatchlistSortOption.changeRateDesc:
          return (b.changeRatePercent ?? 0.0).compareTo(
            a.changeRatePercent ?? 0.0,
          );
        case WatchlistSortOption.nameAsc:
          return a.name.compareTo(b.name);
      }
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // 검색/상세 화면에서 등록·해제하면 여기도 자동으로 다시 그려집니다.
    final symbols = context.watch<WatchlistProvider>().symbols;

    if (_loadedSymbols == null || !listEquals(_loadedSymbols, symbols)) {
      _loadedSymbols = List.of(symbols);
      _future = _loadWatchlist(_loadedSymbols!);
    }

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

                  final items = _sorted(snapshot.data!);

                  if (items.isEmpty) {
                    return const WatchlistEmpty();
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: colors.borderSubtle),
                    itemBuilder: (context, index) => WatchlistRow(
                      item: items[index],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StockDetailScreen(),
                          ),
                        );
                      },
                    ),
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
