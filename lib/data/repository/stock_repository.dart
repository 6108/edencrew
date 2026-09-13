import 'package:edencrew_assignment_starter/models/daily_price.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';

import '../datasource/stock_data_source.dart';

class StockRepository {
  final StockDataSource dataSource;

  StockRepository(this.dataSource);

  Future<List<Stock>> searchStocks(String query) async {
    final response = await dataSource.getSearchStocks(query);

    return response.items
        .where(
          (item) =>
              item.nationCode == 'KOR' &&
              RegExp(r'^\d{6}$').hasMatch(item.code) &&
              (item.name.toLowerCase().contains(query.toLowerCase()) ||
                  item.code.contains(query)),
        )
        .map(
          (item) => Stock(
            symbol: item.code,
            name: item.name,
            market: '',
            currentPrice: 0,
            previousClose: 0,
            openPrice: 0,
            highPrice: 0,
            lowPrice: 0,
            tradingVolume: 0,
            listedStockCount: 0,
          ),
        )
        .toList();
  }

  Future<Map<String, Stock>> getRealtimeStocks(List<String> symbols) async {
    final response = await dataSource.getRealtimeStocks(symbols);

    return {
      for (final item in response.stocks)
        item.cd: Stock(
          symbol: item.cd,
          name: '',
          market: '',
          currentPrice: item.nv,
          previousClose: item.pcv,
          openPrice: item.ov,
          highPrice: item.hv,
          lowPrice: item.lv,
          tradingVolume: item.aq,
          listedStockCount: item.countOfListedStock,
        ),
    };
  }

  Future<Stock> getStockMetadata(String symbol) async {
    final metadata = await dataSource.getStockMetadata(symbol);

    return Stock(
      symbol: metadata.symbolCode,
      name: metadata.stockName,
      market: metadata.stockExchangeNameKor,
      currentPrice: 0,
      previousClose: 0,
      openPrice: 0,
      highPrice: 0,
      lowPrice: 0,
      tradingVolume: 0,
      listedStockCount: 0,
    );
  }

  Future<List<DailyPrice>> getDailyPrices(String symbol, int page) async {
    final response = await dataSource.getDailyPrices(symbol, page);

    return response.prices.map((item) {
      return DailyPrice(
        date: item.localDate,
        closePrice: item.closePrice,
        openPrice: item.openPrice,
        highPrice: item.highPrice,
        lowPrice: item.lowPrice,
        tradingVolume: item.accumulatedTradingVolume,
      );
    }).toList();
  }
}
