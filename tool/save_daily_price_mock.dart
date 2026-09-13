import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  const symbol = '005930';
  const page = 1;

  final uri = Uri.https('finance.naver.com', '/item/sise_day.naver', {
    'code': symbol,
    'page': '$page',
  });

  print('네이버 일별 시세 HTML 요청 중...');

  final response = await http.get(uri, headers: {'User-Agent': 'Mozilla/5.0'});

  if (response.statusCode != 200) {
    print('API 요청 실패: ${response.statusCode}');
    return;
  }

  final file = File('assets/mock/sise_day_${symbol}_page_$page.html');

  await file.writeAsBytes(response.bodyBytes);

  print('Mock 저장 완료!');
  print(file.path);
}
