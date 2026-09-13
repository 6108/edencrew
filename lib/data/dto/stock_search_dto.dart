class StockSearchResponseDto {
  final String query;
  final List<StockSearchItemDto> items;

  StockSearchResponseDto({required this.query, required this.items});

  factory StockSearchResponseDto.fromJson(Map<String, dynamic> json) {
    return StockSearchResponseDto(
      query: json['query'] as String,
      items: (json['items'] as List)
          .map(
            (item) => StockSearchItemDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class StockSearchItemDto {
  final String code;
  final String name;
  final String typeCode;
  final String typeName;
  final String url;
  final String nationCode;
  final String category;

  StockSearchItemDto({
    required this.code,
    required this.name,
    required this.typeCode,
    required this.typeName,
    required this.url,
    required this.nationCode,
    required this.category,
  });

  factory StockSearchItemDto.fromJson(Map<String, dynamic> json) {
    return StockSearchItemDto(
      code: json['code'] as String,
      name: json['name'] as String,
      typeCode: json['typeCode'] as String,
      typeName: json['typeName'] as String,
      url: json['url'] as String,
      nationCode: json['nationCode'] as String,
      category: json['category'] as String,
    );
  }
}
