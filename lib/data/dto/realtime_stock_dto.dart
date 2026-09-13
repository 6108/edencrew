class RealtimeStockResponseDto {
  final String resultCode;
  final List<RealtimeStockItemDto> stocks;

  RealtimeStockResponseDto({required this.resultCode, required this.stocks});

  factory RealtimeStockResponseDto.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>;

    final areas = result['areas'] as List;

    final stocks = <RealtimeStockItemDto>[];

    for (final area in areas) {
      final areaMap = area as Map<String, dynamic>;
      final datas = areaMap['datas'] as List;

      for (final data in datas) {
        stocks.add(RealtimeStockItemDto.fromJson(data as Map<String, dynamic>));
      }
    }

    return RealtimeStockResponseDto(
      resultCode: json['resultCode'] as String,
      stocks: stocks,
    );
  }
}

class RealtimeStockItemDto {
  final String cd;
  final int nv;
  final int pcv;
  final int ov;
  final int hv;
  final int lv;
  final int aq;
  final int countOfListedStock;

  RealtimeStockItemDto({
    required this.cd,
    required this.nv,
    required this.pcv,
    required this.ov,
    required this.hv,
    required this.lv,
    required this.aq,
    required this.countOfListedStock,
  });

  factory RealtimeStockItemDto.fromJson(Map<String, dynamic> json) {
    return RealtimeStockItemDto(
      cd: json['cd'] as String,
      nv: json['nv'] as int,
      pcv: json['pcv'] as int,
      ov: json['ov'] as int,
      hv: json['hv'] as int,
      lv: json['lv'] as int,
      aq: json['aq'] as int,
      countOfListedStock: json['countOfListedStock'] as int,
    );
  }
}
