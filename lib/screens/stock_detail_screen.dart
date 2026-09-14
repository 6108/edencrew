import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/chart_period.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import '../providers/watchlist_provider.dart';
import '../theme/theme.dart';
import '../widgets/detail/detail_header.dart';
import '../widgets/detail/period_tab_bar.dart';
import '../widgets/detail/price_summary.dart';

/// 종목상세 화면. (`03 · 종목상세`)
///
/// 지금은 헤더 + 현재가/등락까지만 연결된 뼈대입니다. 기간 탭, 캔들 차트,
/// 요약 카드(시가/고가/저가/거래량/시가총액), 일별 시세 표는 다음 단계에서
/// 붙입니다.
class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  final _repository = StockRepository(MockNaverApi());

  late final Future<Stock> _future = _loadStock();

  ChartPeriod _period = ChartPeriod.oneMonth;

  Future<Stock> _loadStock() async {
    // 관심/검색 화면과 같은 패턴: 메타데이터(이름·시장)와 시세를 각각 조회해서 하나로 합칩니다.
    final meta = await _repository.getStockMetadata(widget.symbol);
    final realtimeBySymbol = await _repository.getRealtimeStocks([
      widget.symbol,
    ]);
    final realtime = realtimeBySymbol[widget.symbol];

    if (realtime == null) return meta;

    return Stock(
      symbol: meta.symbol,
      name: meta.name,
      market: meta.market,
      currentPrice: realtime.currentPrice,
      previousClose: realtime.previousClose,
      openPrice: realtime.openPrice,
      highPrice: realtime.highPrice,
      lowPrice: realtime.lowPrice,
      tradingVolume: realtime.tradingVolume,
      listedStockCount: realtime.listedStockCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final watchlistProvider = context.watch<WatchlistProvider>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: FutureBuilder<Stock>(
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

            final stock = snapshot.data!;
            final isFavorite = watchlistProvider.isFavorite(stock.symbol);

            return ListView(
              children: [
                DetailHeader(
                  name: stock.name,
                  codeAndMarket: '${stock.symbol} · ${stock.market}',
                  isFavorite: isFavorite,
                  onBackTap: () => Navigator.of(context).pop(),
                  onFavoriteTap: () => watchlistProvider.toggle(stock.symbol),
                ),
                PriceSummary(
                  price: stock.currentPrice,
                  changeAmount: stock.changeAmount,
                  changeRatePercent: stock.changeRate * 100,
                ),
                PeriodTabBar(
                  selected: _period,
                  onSelected: (period) => setState(() => _period = period),
                ),
                // TODO: CandleChart, StatGrid, DailyQuoteTable
              ],
            );
          },
        ),
      ),
    );
  }
}
