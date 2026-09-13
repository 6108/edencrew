class Stock {
  final String symbol;
  final String name;
  final String market;

  final int currentPrice;
  final int previousClose;
  final int openPrice;
  final int highPrice;
  final int lowPrice;
  final int tradingVolume;
  final int listedStockCount;

  Stock({
    required this.symbol,
    required this.name,
    required this.market,
    required this.currentPrice,
    required this.previousClose,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.tradingVolume,
    required this.listedStockCount,
  });

  int get changeAmount {
    return currentPrice - previousClose;
  }

  double get changeRate {
    if (previousClose == 0) {
      return 0;
    }

    return changeAmount / previousClose;
  }

  int get marketCap {
    return currentPrice * listedStockCount;
  }
}
