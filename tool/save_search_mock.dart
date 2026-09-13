// ignore_for_file: avoid_print
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final uri = Uri.https('ac.stock.naver.com', '/ac', {
    'q': '삼성전자',
    'target': 'stock,ipo,index,marketindicator',
  });

  print('네이버 API 요청 중...');

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    print('API 요청 실패: ${response.statusCode}');
    return;
  }

  final file = File('assets/mock/search.json');

  await file.writeAsString(response.body);

  print('Mock 저장 완료!');
  print(file.path);
}
