// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  const symbols = [
    '005930', // 삼성전자
    '000660', // SK하이닉스
    '005380', // 현대차
    '035420', // NAVER
    '035720', // 카카오
  ];

  for (final symbol in symbols) {
    final uri = Uri.https(
      'stock.naver.com',
      '/api/securityFe/api/fchart/domestic/stock/$symbol',
    );

    print('$symbol 메타데이터 API 요청 중...');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      print('$symbol API 요청 실패: ${response.statusCode}');
      continue;
    }

    final file = File('assets/mock/metadata_$symbol.json');

    await file.writeAsString(response.body);

    print('$symbol Mock 저장 완료!');
  }

  print('모든 메타데이터 Mock 저장 완료!');
}
