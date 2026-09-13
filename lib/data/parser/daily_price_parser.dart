import 'package:html/parser.dart' as html_parser;

import '../dto/daily_price_dto.dart';

class DailyPriceParser {
  DailyPriceResponseDto parse(String html) {
    final document = html_parser.parse(html);

    final prices = _parsePrices(document);
    final lastPage = _parseLastPage(document);

    return DailyPriceResponseDto(prices: prices, lastPage: lastPage);
  }

  List<DailyPriceDto> _parsePrices(dynamic document) {
    final prices = <DailyPriceDto>[];

    final rows = document.querySelectorAll('table.type2 tr');

    for (final row in rows) {
      final columns = row.querySelectorAll('td');

      if (columns.length < 7) {
        continue;
      }

      final date = columns[0].text.trim();

      if (date.isEmpty) {
        continue;
      }

      final closePrice = _parseNumber(columns[1].text);
      final openPrice = _parseNumber(columns[3].text);
      final highPrice = _parseNumber(columns[4].text);
      final lowPrice = _parseNumber(columns[5].text);
      final volume = _parseNumber(columns[6].text);

      prices.add(
        DailyPriceDto(
          localDate: date.replaceAll('.', ''),
          closePrice: closePrice,
          openPrice: openPrice,
          highPrice: highPrice,
          lowPrice: lowPrice,
          accumulatedTradingVolume: volume,
        ),
      );
    }

    return prices;
  }

  int _parseNumber(String value) {
    return int.parse(value.replaceAll(',', '').trim());
  }

  int _parseLastPage(dynamic document) {
    final links = document.querySelectorAll('table.Nnavi a');

    var lastPage = 1;

    for (final link in links) {
      final href = link.attributes['href'];

      if (href == null) {
        continue;
      }

      final match = RegExp(r'page=(\d+)').firstMatch(href);

      if (match == null) {
        continue;
      }

      final page = int.parse(match.group(1)!);

      if (page > lastPage) {
        lastPage = page;
      }
    }

    return lastPage;
  }
}
