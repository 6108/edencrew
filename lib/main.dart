import 'package:edencrew_assignment_starter/data/datasource/naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/providers/watchlist_provider.dart';
import 'package:edencrew_assignment_starter/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme.dart';

void main() {
  runApp(const EdencrewAssignmentApp());
}

class EdencrewAssignmentApp extends StatelessWidget {
  const EdencrewAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 여기 한 곳만 바꾸면 앱 전체가 목데이터/실제 API 중 하나로 통일됩니다.
    final repository = StockRepository(NaverApi());

    return MultiProvider(
      providers: [
        Provider<StockRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
      ],
      child: MaterialApp(
        title: '이든크루 평가 과제',
        theme: AppTheme.dark,
        home: const MainScreen(),
      ),
    );
  }
}
