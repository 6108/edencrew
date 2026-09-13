// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

// 관심 종목 일괄 호출
Future<void> main() async {
  const symbols = [
    '005930', // 삼성전자
    '000660', // SK하이닉스
    '005380', // 현대차
    '035420', // NAVER
    '035720', // 카카오
  ];

  final uri = Uri.https('polling.finance.naver.com', '/api/realtime', {
    'query': 'SERVICE_ITEM:${symbols.join(',')}',
  });

  print('네이버 실시간 시세 API 요청 중...');
  print('종목: ${symbols.join(', ')}');

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    print('API 요청 실패: ${response.statusCode}');
    return;
  }

  final file = File('assets/mock/realtime.json');

  await file.writeAsString(response.body);

  print('Mock 저장 완료!');
  print(file.path);
}
