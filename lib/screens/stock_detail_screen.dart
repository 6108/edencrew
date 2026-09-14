import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_price_cache.dart';
import '../data/datasource/mock_naver_api.dart';
import '../data/repository/stock_repository.dart';
import '../models/chart_period.dart';
import '../models/daily_price.dart';
import '../models/daily_quote_item.dart';
import '../models/stock.dart';
import '../providers/watchlist_provider.dart';
import '../theme/theme.dart';
import '../utils/number_format.dart';
import '../widgets/detail/candle_chart.dart';
import '../widgets/detail/daily_quote.dart';
import '../widgets/detail/detail_header.dart';
import '../widgets/detail/period_tab_bar.dart';
import '../widgets/detail/price_summary.dart';
import '../widgets/detail/quote_summary.dart';

/// 종목상세 화면. (`03 · 종목상세`)
///
/// 헤더, 현재가/등락, 기간 탭, 캔들 차트, 시세 요약, 일별 시세를 보여줍니다.
/// 차트/표는 같은 `DailyPriceCache`를 공유해서, 기간 탭을 바꿔도 이미 받은
/// 페이지는 다시 요청하지 않습니다.
class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final _repository = StockRepository(MockNaverApi());
  late final _priceCache = DailyPriceCache(_repository, widget.symbol);

  late final Future<Stock> _stockFuture = _loadStock();

  ChartPeriod _period = ChartPeriod.oneMonth;
  late Future<List<DailyPrice>> _pricesFuture = _loadPrices();

  Future<Stock> _loadStock() async {
    final meta = await _repository.getStockMetadata(widget.symbol);

    final realtimeBySymbol = await _repository.getRealtimeStocks([
      widget.symbol,
    ]);

    final realtime = realtimeBySymbol[widget.symbol];

    if (realtime == null) {
      return meta;
    }

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

  Future<List<DailyPrice>> _loadPrices() {
    return _priceCache.loadUpToPage(_period.pageCount);
  }

  void _onPeriodSelected(ChartPeriod period) {
    if (period == _period) return;

    setState(() {
      _period = period;
      _pricesFuture = _loadPrices();
    });
  }

  List<DailyQuoteRowItem> _toRowItems(List<DailyPrice> prices) {
    return [
      for (var i = 0; i < prices.length; i++)
        DailyQuoteRowItem(
          dateLabel: _formatDate(prices[i].date),
          close: prices[i].closePrice,
          changeAmount: _changeAmountAt(prices, i),
          volume: prices[i].tradingVolume,
        ),
    ];
  }

  int _changeAmountAt(List<DailyPrice> prices, int index) {
    if (index >= prices.length - 1) return 0;

    return prices[index].closePrice - prices[index + 1].closePrice;
  }

  String _formatDate(String date) {
    if (date.contains('-')) {
      final parts = date.split('-');

      if (parts.length >= 3) {
        return '${parts[1]}.${parts[2]}';
      }
    }

    if (date.length >= 8) {
      return '${date.substring(4, 6)}.${date.substring(6, 8)}';
    }

    return date;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final watchlistProvider = context.watch<WatchlistProvider>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: FutureBuilder<Stock>(
          future: _stockFuture,
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
                  onFavoriteTap: () {
                    watchlistProvider.toggle(stock.symbol);
                  },
                ),

                // 헤더 아래 콘텐츠는 전체 가로 16
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.space4,
                  ),
                  child: Column(
                    spacing: context.dimens.space6,
                    children: [
                      PriceSummary(
                        price: stock.currentPrice,
                        changeAmount: stock.changeAmount,
                        changeRatePercent: stock.changeRate * 100,
                      ),

                      PeriodTabBar(
                        selected: _period,
                        onSelected: _onPeriodSelected,
                      ),

                      FutureBuilder<List<DailyPrice>>(
                        future: _pricesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Padding(
                              padding: EdgeInsets.all(context.dimens.space4),
                              child: Text(
                                '차트를 불러오지 못했습니다.',
                                style: context.textStyles.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return CandleChart(prices: snapshot.data!);
                        },
                      ),

                      QuoteSummary(
                        rows: [
                          [
                            MapEntry('시가', formatThousands(stock.openPrice)),
                            MapEntry('고가', formatThousands(stock.highPrice)),
                            MapEntry('저가', formatThousands(stock.lowPrice)),
                          ],
                          [
                            MapEntry(
                              '거래량',
                              formatVolumeAbbreviated(stock.tradingVolume),
                            ),
                            MapEntry(
                              '시가총액',
                              formatMarketCapAbbreviated(stock.marketCap),
                            ),
                          ],
                        ],
                      ),

                      FutureBuilder<List<DailyPrice>>(
                        future: _pricesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Padding(
                              padding: EdgeInsets.all(context.dimens.space4),
                              child: Text(
                                '일별 시세를 불러오지 못했습니다.',
                                style: context.textStyles.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return DailyQuote(rows: _toRowItems(snapshot.data!));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
