import '../dto/daily_price_dto.dart';
import '../dto/realtime_stock_dto.dart';
import '../dto/stock_metadata_dto.dart';
import '../dto/stock_search_dto.dart';

abstract class StockDataSource {
  Future<StockSearchResponseDto> getSearchStocks(String query);

  Future<RealtimeStockResponseDto> getRealtimeStocks(List<String> symbols);

  Future<StockMetadataDto> getStockMetadata(String symbol);

  Future<DailyPriceResponseDto> getDailyPrices(String symbol, int page);
}
