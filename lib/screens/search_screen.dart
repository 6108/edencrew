import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import '../providers/watchlist_provider.dart';
import '../theme/theme.dart';
import '../widgets/common/app_toast.dart';
import '../widgets/search/search_empty.dart';
import '../widgets/search/search_field.dart';
import '../widgets/search/search_no_results.dart';
import '../widgets/search/search_result_row.dart';

/// 검색 화면. (`02 · 검색` / `02 · 검색_empty` / `02 · 검색결과_empty`)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  //final _repository = StockRepository(MockNaverApi());
  late final _repository = context.read<StockRepository>();

  final _controller = TextEditingController();
  String _query = '';
  Future<List<Stock>>? _resultsFuture;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final trimmed = value.trim();
    setState(() {
      _query = trimmed;
      _resultsFuture = trimmed.isEmpty
          ? null
          : _repository.searchStocks(trimmed);
    });
  }

  void _onClear() {
    _controller.clear();
    setState(() {
      _query = '';
      _resultsFuture = null;
    });
  }

  void _onFavoriteTap(Stock stock) {
    final provider = context.read<WatchlistProvider>();
    final willBeFavorite = provider.toggle(stock.symbol);
    AppToast.show(context, isFavorite: willBeFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // 관심 등록 여부가 바뀔 때 별 아이콘이 다시 그려지도록 구독.
    final watchlistProvider = context.watch<WatchlistProvider>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            SearchField(
              controller: _controller,
              onChanged: _onChanged,
              onClear: _onClear,
            ),
            Expanded(child: _buildBody(watchlistProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(WatchlistProvider watchlistProvider) {
    if (_query.isEmpty) return const SearchEmpty();

    return FutureBuilder<List<Stock>>(
      future: _resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '오류: ${snapshot.error}',
              style: context.textStyles.caption.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          );
        }

        final results = snapshot.data ?? const <Stock>[];

        if (results.isEmpty) {
          return SearchNoResults(query: _query);
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final stock = results[index];
            return SearchResultRow(
              stock: stock,
              query: _query,
              isFavorite: watchlistProvider.isFavorite(stock.symbol),
              onTap: () {
                // TODO: 종목 상세 화면 이동 (StockDetailScreen으로 Navigator.push)
              },
              onFavoriteTap: () => _onFavoriteTap(stock),
            );
          },
        );
      },
    );
  }
}
