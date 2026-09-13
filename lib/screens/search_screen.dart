import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/search_empty.dart';
import '../widgets/search_field.dart';

/// 검색 화면
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value.trim());
  }

  void _onClear() {
    _controller.clear();
    setState(() => _query = '');
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

    // TODO: 검색 자동완성 endpoint 연동 + 결과 목록 / 결과 없음(SearchNoResults) 분기.
    return const SizedBox.shrink();
  }
}
