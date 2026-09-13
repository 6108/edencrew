// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

// 관심 종목 일괄 호출
Future<void> main() async {
  final uri = Uri.https('polling.finance.naver.com', '/api/realtime', {
    'query': 'SERVICE_ITEM:005930,000660',
  });

  print('네이버 실시간 시세 API 요청 중...');

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
