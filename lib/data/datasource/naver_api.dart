import 'dart:convert';

import 'package:charset/charset.dart';
import 'package:http/http.dart' as http;

import '../dto/daily_price_dto.dart';
import '../dto/realtime_stock_dto.dart';
import '../dto/stock_metadata_dto.dart';
import '../dto/stock_search_dto.dart';
import '../parser/daily_price_parser.dart';
import 'stock_data_source.dart';

class NaverApi implements StockDataSource {
  @override
  Future<StockSearchResponseDto> getSearchStocks(String query) async {
    final uri = Uri.https('ac.stock.naver.com', '/ac', {
      'q': query,
      'target': 'stock,ipo,index,marketindicator',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('검색 API 요청 실패: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    return StockSearchResponseDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<RealtimeStockResponseDto> getRealtimeStocks(
    List<String> symbols,
  ) async {
    final uri = Uri.https('polling.finance.naver.com', '/api/realtime', {
      'query': 'SERVICE_ITEM:${symbols.join(',')}',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('실시간 시세 API 요청 실패: ${response.statusCode}');
    }

    final json = jsonDecode(eucKr.decode(response.bodyBytes));

    return RealtimeStockResponseDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<StockMetadataDto> getStockMetadata(String symbol) async {
    final uri = Uri.https(
      'stock.naver.com',
      '/api/securityFe/api/fchart/domestic/stock/$symbol',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('종목 메타데이터 API 요청 실패: ${response.statusCode}');
    }

    final json = jsonDecode(response.body);

    return StockMetadataDto.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<DailyPriceResponseDto> getDailyPrices(String symbol, int page) async {
    final uri = Uri.https('finance.naver.com', '/item/sise_day.naver', {
      'code': symbol,
      'page': '$page',
    });

    final response = await http.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    if (response.statusCode != 200) {
      throw Exception('일별 시세 API 요청 실패: ${response.statusCode}');
    }

    final html = eucKr.decode(response.bodyBytes);

    final parser = DailyPriceParser();

    return parser.parse(html);
  }
}
