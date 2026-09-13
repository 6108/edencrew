import 'dart:convert';
import 'dart:io';

import 'package:charset/charset.dart';

import '../dto/daily_price_dto.dart';
import '../dto/realtime_stock_dto.dart';
import '../dto/stock_metadata_dto.dart';
import '../dto/stock_search_dto.dart';
import '../parser/daily_price_parser.dart';
import 'stock_data_source.dart';

class MockNaverApi implements StockDataSource {
  @override
  Future<StockSearchResponseDto> getSearchStocks(String query) async {
    final file = File('assets/mock/search.json');

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return StockSearchResponseDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<RealtimeStockResponseDto> getRealtimeStocks(
    List<String> symbols,
  ) async {
    final file = File('assets/mock/realtime.json');

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return RealtimeStockResponseDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<StockMetadataDto> getStockMetadata(String symbol) async {
    final file = File('assets/mock/metadata_$symbol.json');

    final jsonString = await file.readAsString();
    final json = jsonDecode(jsonString);

    return StockMetadataDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<DailyPriceResponseDto> getDailyPrices(String symbol, int page) async {
    final file = File('assets/mock/sise_day_${symbol}_page_$page.html');

    final bytes = await file.readAsBytes();

    // Mock HTML은 EUC-KR로 디코딩
    final html = eucKr.decode(bytes);

    final parser = DailyPriceParser();

    return parser.parse(html);
  }
}
