import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/data/datasource/mock_naver_api.dart';
import 'package:edencrew_assignment_starter/data/repository/stock_repository.dart';
import 'package:edencrew_assignment_starter/models/stock.dart';
import '../theme/theme.dart';
import '../widgets/app_toast.dart';
import '../widgets/search_empty.dart';
import '../widgets/search_field.dart';
import '../widgets/search_no_results.dart';
import '../widgets/search_result_row.dart';

/// 검색 화면. (`02 · 검색` / `02 · 검색_empty` / `02 · 검색결과_empty`)
///
/// 결과 없음 상태(`SearchNoResults`)와 관심 등록/해제 토스트, 관심 화면과의
/// 상태 동기화는 다음 단계에서 붙입니다. 지금 관심 등록 여부는 이 화면
/// 로컬 `Set`으로만 관리해서, 관심 화면에는 아직 반영되지 않습니다.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 실제 실행 시엔 NaverApi()로 교체. 개발 중엔 assets/mock/*.json 사용.
  final _repository = StockRepository(MockNaverApi());

  final _controller = TextEditingController();
  String _query = '';
  Future<List<Stock>>? _resultsFuture;

  // TODO: WatchlistProvider(또는 동등한 전역 상태)로 교체해 관심/검색/상세
  // 화면 간 등록 여부를 동기화해야 합니다. 지금은 이 화면만의 임시 상태입니다.
  final _favoriteSymbols = <String>{};

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
    final willBeFavorite = !_favoriteSymbols.contains(stock.symbol);
    setState(() {
      if (willBeFavorite) {
        _favoriteSymbols.add(stock.symbol);
      } else {
        _favoriteSymbols.remove(stock.symbol);
      }
    });
    AppToast.show(context, isFavorite: willBeFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
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
              isFavorite: _favoriteSymbols.contains(stock.symbol),
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
