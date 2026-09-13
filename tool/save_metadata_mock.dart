// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  const symbol = '005930';

  final uri = Uri.https(
    'stock.naver.com',
    '/api/securityFe/api/fchart/domestic/stock/$symbol',
  );

  print('네이버 종목 메타데이터 API 요청 중...');

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    print('API 요청 실패: ${response.statusCode}');
    return;
  }

  final file = File('assets/mock/metadata_$symbol.json');

  await file.writeAsString(response.body);

  print('Mock 저장 완료!');
  print(file.path);
}
