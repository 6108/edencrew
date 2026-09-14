# [과제 제출] Flutter 신입 개발자 과제 - 문지현

---

## 실행 방법

- Flutter 버전: `Flutter 3.47.3 / Dart 3.13.3`
- 실행 명령: `flutter pub get && flutter run`
- 확인한 플랫폼 / 기기: `Android / Samsung Galaxy Note 20 / Android 13`
- 폰트 처리: `Noto Sans KR`을 스타터에 등록된 방식 그대로 사용했습니다. `google_fonts` 등으로 바꾸지 않았습니다.

---

## 구현 범위

### 필수 항목
| 화면  | 항목 | 상태 | 근거 |
| --- | --- | --- | --- |
| 관심 | 종목명 / 코드·시장 / 현재가 / 등락액·등락률 표시 | ✓ | `lib/widgets/watchlist/watchlist_row.dart` |
| 관심 | 상승·하락·보합 3색 처리 | ✓ | `lib/widgets/watchlist/watchlist_row.dart` `_changeColor()` — `priceUpText`/`priceDownText`/`priceFlatText` 분기 |
| 관심 | 새로고침 버튼 | ✓ | `lib/widgets/watchlist/watchlist_header.dart` (`onRefreshTap`), `lib/screens/watchlist_screen.dart` `_onRefreshTap()` |
| 관심 | 하단 탭 바 전환 (`navActive`/`navInactive`) | ✓ | `lib/widgets/common/bottom_nav_item.dart` — `selected ? colors.navActive : colors.navInactive` |
| 관심 | 스켈레톤 상태 (`feedbackSkeleton`) | ✓ | `lib/widgets/watchlist/watchlist_row.dart` `_skeletonBar()`, `lib/screens/watchlist_screen.dart` `_loadWatchlist()`에서 `isLoading: true` 생성 |
| 관심 | 빈 상태 (`01 · 관심_empty`) | ✓ | `lib/widgets/watchlist/watchlist_empty.dart`, `lib/screens/watchlist_screen.dart`에서 `items.isEmpty` 시 표시 |
| 관심 | 정렬 바텀시트 3종 + 헤더 칩 반영 (`01 · 관심_sort`) | ✓ | `lib/widgets/watchlist/watchlist_sort_sheet.dart`, `watchlist_sort_option_row.dart`, `lib/screens/watchlist_screen.dart` `_sorted()` / `_onSortTap()` |
| 검색 | 입력창 + 클리어 버튼 | ✓ | `lib/widgets/search/search_field.dart` |
| 검색 | 종목명 하이라이트 (`searchHighlight`) | ✓ | `lib/widgets/search/search_result_row.dart` `_highlightedName()` |
| 검색 | 관심 등록 버튼 (`favoriteActive`/`favoriteInactive`) | ✓ | `lib/widgets/search/search_result_row.dart` — 별 아이콘 색 분기 |
| 검색 | 등록/해제 즉시 반영 + 토스트 2종 | ✓ | `lib/screens/search_screen.dart` `_onFavoriteTap()` → `WatchlistProvider.toggle()` + `AppToast.show()`, `lib/widgets/common/app_toast.dart` |
| 검색 | 결과 행 탭 → 상세 이동 | ✓ | `lib/screens/search_screen.dart` (리팩토링 후 `onTap` 위임 → `StockDetailScreen`) |
| 검색 | 초기 상태 (`02 · 검색_empty`) | ✓ | `lib/widgets/search/search_empty.dart`, `search_screen.dart` `_buildBody()`에서 `_query.isEmpty` 분기 |
| 검색 | 결과 없음 상태, 입력한 검색어 문구 반영 (`02 · 검색결과_empty`) | ✓ | `lib/widgets/search/search_no_results.dart` — `'$query'와 일치하는...` |
| 상세 | 헤더(뒤로가기/종목명/코드·시장/관심버튼) | ✓ | `lib/widgets/detail/detail_header.dart` |
| 상세 | 현재가 + 등락 + 방향 아이콘 | ✓ | `lib/widgets/detail/price_summary.dart` — `▲`/`▼`/`-` + 3색 |
| 상세 | 기간 탭 4종 동작 + 선택 스타일 | ✓ | `lib/widgets/detail/period_tab_bar.dart`, `lib/screens/stock_detail_screen.dart` `_onPeriodSelected()` — `accentDefault`/`accentBg` |
| 상세 | 캔들 차트 (`chartLineUp`/`chartLineDown`) | ✓ | `lib/widgets/detail/candle_chart.dart` |
| 상세 | 요약 카드(시가/고가/저가/거래량/시가총액, 축약 표기) | ✓ | `lib/widgets/detail/quote_summary.dart`/`quote_summary_cell.dart`, `lib/utils/number_format.dart` `formatVolumeAbbreviated`/`formatMarketCapAbbreviated` |
| 상세 | 일별 시세 표(날짜/종가/등락/거래량) | ✓ | `lib/widgets/detail/daily_quote.dart`/`daily_quote_row.dart`, 날짜는 `stock_detail_screen.dart` `_formatDate()`에서 `MM.DD` 변환 |
| 공통 | 관심 상태 3화면 동기화 | ✓ | `lib/providers/watchlist_provider.dart`를 관심/검색/상세 화면 모두 `context.watch<WatchlistProvider>()`로 구독 |
| 공통 | `flutter analyze` 클린 | ✓ | 확인 완료 |


---

## 기술 선택과 이유

### 진행 순서

Flutter가 처음이라 안드로이드 스튜디오 설치부터 시작했습니다. 
최근 주로 다루는 게 React라, 모르는 용어가 나올 때마다 예제를 찾아보면서 React 개념에 대응시켜 이해하려 했습니다 (`Provider`의 구독 ↔ Zustand의 구독, 위젯 ↔ 컴포넌트, 스크린 ↔ 페이지 등). 다만 시간 안에 전부 깊이 이해하진 못했고, 대응되는 개념을 찾아 감을 잡는 선에서 진행한 부분도 있습니다.

화면 하나당 진행한 순서는 다음과 같습니다.
 
1. **API 호출 및 목업 제작** — 실제 Naver endpoint를 호출해보고, 응답을 `assets/mock/`에 저장
2. **DTO와 모델 대응 생성** — 응답 구조를 그대로 옮긴 DTO를 만들고, 화면에서 쓸 모델로 변환하는 지점을 먼저 정리
3. **빈 화면 구현** — 레이아웃 뼈대만 있는 화면을 먼저 만들어 놓고
4. **필요한 위젯을 최소 단위부터 구현** — 행 하나, 버튼 하나처럼 가장 작은 단위 위젯부터 따로 완성
5. **위젯으로 화면 채우기** — 완성된 위젯들을 조합해서 화면을 채움

### 상태관리

`Provider` + `ChangeNotifier` (`WatchlistProvider`)만 사용했습니다. 전역으로 공유해야 하는 상태는 "관심종목 등록 여부" 하나뿐이라, 별도 상태관리 프레임워크를 도입할 만큼 복잡도가 크지 않다고 판단했습니다. 화면별 로컬 상태(검색어, 선택된 기간, 정렬 기준 등)는 각 화면의 `State`가 직접 들고 `setState`로 처리했습니다.

### 폴더 구조 / 아키텍처

```
lib/
  main.dart              앱 진입점, Provider 등록, StockRepository 주입
  screens/                화면 단위. 화면별 상태(State)와 데이터 로딩(FutureBuilder)을 담당
  widgets/
    watchlist/            관심 화면 전용 위젯
    search/                검색 화면 전용 위젯
    detail/                 상세 화면 전용 위젯
    common/                여러 화면에서 재사용하는 위젯 (토스트, 하단 탭바)
  models/                 UI에서 쓰는 모델 (Stock, WatchlistItem, DailyPrice 등)
  providers/              전역 상태 (WatchlistProvider)
  data/
    datasource/            Naver API 실제 호출 / Mock 데이터
    dto/                    API 응답 원본 구조 (파싱 전 단계)
    parser/                 HTML 등 비-JSON 응답 파싱
    repository/             datasource + dto → models 로 변환해 화면에 제공하는 단일 창구
    daily_price_cache.dart  종목별 일별 시세 페이지 캐시 (기간 탭 전환 시 재요청 방지)
  theme/                  디자인 토큰 (색상/간격/서체/텍스트스타일)
  utils/                  포맷팅 등 공용 함수
```

레이어를 `datasource → dto → repository → model → screen`으로 나눈 이유는, Naver API가 JSON/HTML이 섞여 있고 필드명도 화면에서 쓰는 이름과 달라서(`nv`, `pcv` 등) 파싱 책임과 화면 표시 책임을 분리하고 싶었기 때문입니다. `StockRepository`가 이 둘 사이의 유일한 창구 역할을 하고, 화면은 `StockRepository`만 알면 됩니다.

### 주요 패키지

- `provider`: 위 이유로 최소한의 전역 상태 공유용
- `http`: Naver endpoint(검색 자동완성, 실시간 시세, 종목 메타데이터, 일별 시세) 요청
- `html`: 일별 시세 응답(HTML)에서 날짜·종가·시가·고가·저가·거래량 파싱
- `charset`: 일별 시세 응답이 EUC-KR로 내려와서 디코딩할 때 사용

### 차트 처리 방식

`CustomPainter`로 그렸습니다. 캔들 몸통/꼬리만 그리는 최소 구현을 택했습니다.

꼬리는 Figma 이미지에 따라 상승/하락과 무관하게 `chartLineFlat`(회색) 고정으로 처리했습니다.

### 디자인 토큰 추가

`app_dimens.dart`에 `radiusXl`을 추가했습니다. 
Figma 시안에서 정렬 바텀시트 상단 모서리에 쓰인 반경 값이 Figma에는 있지만 theme에는 없어서, Figma 값 그대로 토큰을 하나 늘렸습니다. <br/>
텍스트 스타일도 추가하였습니다. `app_text_styles.dart`

---

## 직접 판단한 부분과 이유

- **토스트 노출 시간 / 사라지는 방식**: `SnackBar` 기반으로 구현했고 `Duration(seconds: 2)` 후 자동으로 사라집니다. 별도 등장/퇴장 애니메이션은 `SnackBar` 기본 동작을 그대로 사용했습니다

- **시세를 못 받은 행(스켈레톤)의 정렬 처리**: 정렬 기준(`현재가순`/`등락률순`/`가나다순`)과 무관하게 항상 목록 맨 뒤에 배치했습니다 (`watchlist_screen.dart`의 `_sorted()`). 로딩 중인 값을 정렬 기준에 섞으면 위치가 매 렌더마다 불안정해질 수 있다고 판단했습니다.
- **로딩 / 에러 / 긴 종목명 오버플로**:
  - 로딩: `FutureBuilder` 대기 중엔 `CircularProgressIndicator`, 관심 화면의 개별 행은 스켈레톤(`feedbackSkeleton`)으로 별도 처리
  - 네트워크 에러: 화면별로 `오류: {message}` 텍스트를 캡션 스타일로 표시.
  - 긴 종목명: `maxLines: 1` + `TextOverflow.ellipsis`로 말줄임 처리 (관심 행, 검색 결과 행 공통)
- **Figma와 다르게 구현한 부분**: `
  - 종목 검색 empty에서 서치 필드에 글자가 없다면 x를 띄우지 않았습니다.

---

## 막혔던 지점과 어떻게 접근했는지

- **일별 시세 HTML 인코딩**: 그대로 UTF-8로 디코딩했더니 한글이 깨졌습니다. 응답의 `charset` 값을 확인해보니 EUC-KR로 내려오고 있어서, 바이트를 EUC-KR로 디코딩한 뒤 파싱하도록 고쳐서 해결했습니다.
- **안드로이드에서 mock 파일을 못 찾는 문제**: `assets/mock/`에 저장해둔 응답 샘플을 안드로이드 빌드에서 파일 시스템 경로로 읽으려 하니 찾지 못했습니다. Flutter 앱에서 `assets/`는 일반 파일 경로가 아니라 앱 번들에 패키징되는 리소스라, `rootBundle`(`rootBundle.loadString`)로 접근하도록 고쳐서 해결했습니다.

