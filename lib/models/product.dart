class Product {
  final int id;
  final String sku;
  final String name;
  final String category;
  final String unit;
  final double buyPrice;
  final double sellPrice;
  final double hpp;
  final int totalStock;
  final bool isPendingSync;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.unit,
    required this.buyPrice,
    required this.sellPrice,
    required this.hpp,
    required this.totalStock,
    this.isPendingSync = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      sku: json['sku']?.toString() ?? '-',
      name: json['name']?.toString() ?? '-',
      category: json['category']?.toString() ?? '-',
      unit: json['unit']?.toString() ?? 'Pcs',
      buyPrice: double.tryParse(json['buy_price']?.toString() ?? '0') ?? 0.0,
      sellPrice: double.tryParse(json['sell_price']?.toString() ?? '0') ?? 0.0,
      hpp: double.tryParse(json['hpp']?.toString() ?? '0') ?? 0.0,
      totalStock: int.tryParse(json['total_stock']?.toString() ?? '0') ?? 0,
      isPendingSync: json['is_pending_sync'] == true,
    );
  }
}

class ProductStockItem {
  final String warehouseName;
  final int quantity;

  ProductStockItem({
    required this.warehouseName,
    required this.quantity,
  });

  factory ProductStockItem.fromJson(Map<String, dynamic> json) {
    return ProductStockItem(
      warehouseName: json['warehouse']?['name']?.toString() ?? 'Gudang Utama',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class ProductTransactionItem {
  final String contactName;
  final String date;
  final String referenceNo;
  final int quantity;
  final double price;

  ProductTransactionItem({
    required this.contactName,
    required this.date,
    required this.referenceNo,
    required this.quantity,
    required this.price,
  });

  factory ProductTransactionItem.fromSaleJson(Map<String, dynamic> json) {
    final sale = json['sale'];
    return ProductTransactionItem(
      contactName: sale?['contact']?['name']?.toString() ?? '-',
      date: sale?['date']?.toString() ?? '-',
      referenceNo: sale?['reference_no']?.toString() ?? '-',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }

  factory ProductTransactionItem.fromPurchaseJson(Map<String, dynamic> json) {
    final purchase = json['purchase'];
    return ProductTransactionItem(
      contactName: purchase?['contact']?['name']?.toString() ?? '-',
      date: purchase?['date']?.toString() ?? '-',
      referenceNo: purchase?['reference_no']?.toString() ?? '-',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class ProductAdjustmentItem {
  final String warehouseName;
  final String date;
  final String reason;
  final String type;
  final int quantity;

  ProductAdjustmentItem({
    required this.warehouseName,
    required this.date,
    required this.reason,
    required this.type,
    required this.quantity,
  });

  bool get isAddition => type == 'Penambahan';

  factory ProductAdjustmentItem.fromJson(Map<String, dynamic> json) {
    return ProductAdjustmentItem(
      warehouseName: json['warehouse']?['name']?.toString() ?? '-',
      date: json['date']?.toString() ?? '-',
      reason: json['reason']?.toString() ?? '-',
      type: json['type']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
    );
  }
}

class ProductDetail {
  final Product product;
  final List<ProductStockItem> stocks;
  final List<ProductTransactionItem> saleHistory;
  final List<ProductTransactionItem> purchaseHistory;
  final List<ProductAdjustmentItem> adjustments;

  ProductDetail({
    required this.product,
    required this.stocks,
    required this.saleHistory,
    required this.purchaseHistory,
    required this.adjustments,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final rawStocks = (json['stocks'] as List?) ?? [];
    final rawSales = (json['sale_history'] as List?) ?? [];
    final rawPurchases = (json['purchase_history'] as List?) ?? [];
    final rawAdjustments = (json['adjustments'] as List?) ?? [];

    return ProductDetail(
      product: Product.fromJson(json['product'] ?? {}),
      stocks: rawStocks.map((e) => ProductStockItem.fromJson(e)).toList(),
      saleHistory: rawSales.map((e) => ProductTransactionItem.fromSaleJson(e)).toList(),
      purchaseHistory: rawPurchases.map((e) => ProductTransactionItem.fromPurchaseJson(e)).toList(),
      adjustments: rawAdjustments.map((e) => ProductAdjustmentItem.fromJson(e)).toList(),
    );
  }
}