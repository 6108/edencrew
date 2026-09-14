import 'package:flutter/foundation.dart';

/// 관심종목 등록 여부를 전역으로 관리하는 상태입니다.
///
/// 관심 / 검색 / 상세 세 화면이 각자 로컬 상태로 들고 있던 "등록 여부"를하나로 합쳤습니다.
class WatchlistProvider extends ChangeNotifier {
  WatchlistProvider({List<String>? initialSymbols})
    : _symbols = List.of(initialSymbols ?? const []);

  final List<String> _symbols;

  /// 등록 순서를 유지한 종목코드 목록. 관심 화면이 이 목록으로 시세를 조회합니다.
  List<String> get symbols => List.unmodifiable(_symbols);

  bool isFavorite(String symbol) => _symbols.contains(symbol);

  /// 등록돼 있으면 해제, 아니면 등록합니다. 등록 후 상태(`true`/`false`)를
  /// 반환해서 호출한 쪽이 토스트 문구 등을 바로 판단할 수 있게 합니다.
  bool toggle(String symbol) {
    final willBeFavorite = !_symbols.contains(symbol);
    if (willBeFavorite) {
      _symbols.add(symbol);
    } else {
      _symbols.remove(symbol);
    }
    notifyListeners();
    return willBeFavorite;
  }
}
