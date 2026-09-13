class StockMetadataDto {
  final String symbolCode;
  final String stockName;
  final String stockExchangeNameKor;

  StockMetadataDto({
    required this.symbolCode,
    required this.stockName,
    required this.stockExchangeNameKor,
  });

  factory StockMetadataDto.fromJson(Map<String, dynamic> json) {
    return StockMetadataDto(
      symbolCode: json['symbolCode'] as String,
      stockName: json['stockName'] as String,
      stockExchangeNameKor: json['stockExchangeNameKor'] as String,
    );
  }
}
