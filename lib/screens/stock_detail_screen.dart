import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import '../providers/watchlist_provider.dart';
import '../theme/theme.dart';
import '../widgets/detail/detail_header.dart';

/// 종목상세 화면. (`03 · 종목상세`)
///
/// 지금은 헤더만 연결된 뼈대입니다. 현재가/등락, 기간 탭, 캔들 차트,
/// 요약 카드, 일별 시세 표는 다음 단계에서 붙입니다.
class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.symbol});

  final String symbol;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  final _repository = StockRepository(MockNaverApi());

  // 헤더는 이름·코드·시장만 필요해서 메타데이터만 조회합니다.
  late final Future<Stock> _future = _repository.getStockMetadata(
    widget.symbol,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final watchlistProvider = context.watch<WatchlistProvider>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: FutureBuilder<Stock>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '오류: ${snapshot.error}',
                  style: context.textStyles.caption.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final stock = snapshot.data!;

            return DetailHeader(
              name: stock.name,
              codeAndMarket: '${stock.symbol} · ${stock.market}',
              isFavorite: watchlistProvider.isFavorite(stock.symbol),
              onBackTap: () => Navigator.of(context).pop(),
              onFavoriteTap: () => watchlistProvider.toggle(stock.symbol),
            );
          },
        ),
      ),
    );
  }
}
