// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

/// 005930 종목의 일별 시세 mock 데이터 일괄 수집 스크립트.
Future<void> main() async {
  const symbol = '005930';
  const pageCount = 25; // 1년 탭까지 확인하려면 25페이지 필요

  for (var page = 1; page <= pageCount; page++) {
    final file = File('assets/mock/sise_day_${symbol}_page_$page.html');

    if (await file.exists()) {
      print('page $page: 이미 있음, 건너뜀');
      continue;
    }

    final uri = Uri.https('finance.naver.com', '/item/sise_day.naver', {
      'code': symbol,
      'page': '$page',
    });

    print('page $page 요청 중...');

    final response = await http.get(
      uri,
      headers: {'User-Agent': 'Mozilla/5.0'},
    );

    if (response.statusCode != 200) {
      print('page $page 요청 실패: ${response.statusCode}');
      continue;
    }

    await file.writeAsBytes(response.bodyBytes);
    print('page $page 저장 완료 → ${file.path}');

    // 너무 빠르게 연속 요청하지 않도록 살짝 텀
    await Future.delayed(const Duration(milliseconds: 300));
  }

  print('전체 완료!');
}
