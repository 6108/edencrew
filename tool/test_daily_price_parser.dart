import 'dart:io';

import 'package:charset/charset.dart';
import 'package:edencrew_assignment_starter/data/parser/daily_price_parser.dart';

Future<void> main() async {
  final file = File('assets/mock/sise_day_005930_page_1.html');

  if (!file.existsSync()) {
    print('Mock 파일을 찾을 수 없습니다.');
    return;
  }

  // HTML 원본 바이트 읽기
  final bytes = await file.readAsBytes();

  // 네이버 HTML은 EUC-KR이므로 EUC-KR로 디코딩
  final html = eucKr.decode(bytes);

  final parser = DailyPriceParser();

  final result = parser.parse(html);

  print('===== 일별 시세 파싱 결과 =====');
  print('데이터 개수: ${result.prices.length}');
  print('마지막 페이지: ${result.lastPage}');

  for (final price in result.prices) {
    print(
      '${price.localDate} | '
      '종가: ${price.closePrice} | '
      '시가: ${price.openPrice} | '
      '고가: ${price.highPrice} | '
      '저가: ${price.lowPrice} | '
      '거래량: ${price.accumulatedTradingVolume}',
    );
  }
}
