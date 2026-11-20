// class StockAdjustment {
//   final String date;
//   final String type;
//   final String productSku;
//   final String productName;
//   final String productUnit;
//   final String warehouseName;
//   final int quantity;
//   final String reason;

//   StockAdjustment({
//     required this.date,
//     required this.type,
//     required this.productSku,
//     required this.productName,
//     required this.productUnit,
//     required this.warehouseName,
//     required this.quantity,
//     required this.reason,
//   });

//   // Helper praktis untuk UI
//   bool get isAdd => type == 'Penambahan';
//   bool get isTransfer => reason.contains('[MUTASI');

//   factory StockAdjustment.fromJson(Map<String, dynamic> json) {
//     final product = json['product'];
//     final warehouse = json['warehouse'];

//     return StockAdjustment(
//       date: json['date']?.toString() ?? '-',
//       type: json['type']?.toString() ?? '',
//       productSku: json['product_sku']?.toString() ?? '-',
//       productName: product != null
//           ? (product['name']?.toString() ?? 'Produk Dihapus')
//           : 'Produk Dihapus',
//       productUnit: product != null ? (product['unit']?.toString() ?? '') : '',
//       warehouseName: warehouse != null
//           ? (warehouse['name']?.toString() ?? 'Gudang Utama')
//           : 'Gudang Utama',
//       quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
//       reason: json['reason']?.toString() ?? '-',
//     );
//   }
// }

// class Warehouse {
//   final int id;
//   final String code;
//   final String name;

//   Warehouse({
//     required this.id,
//     required this.code,
//     required this.name,
//   });

//   factory Warehouse.fromJson(Map<String, dynamic> json) {
//     return Warehouse(
//       id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       code: json['code']?.toString() ?? '-',
//       name: json['name']?.toString() ?? '-',
//     );
//   }
// }

// class InventoryProductOption {
//   final String sku;
//   final String name;

//   InventoryProductOption({
//     required this.sku,
//     required this.name,
//   });

//   factory InventoryProductOption.fromJson(Map<String, dynamic> json) {
//     return InventoryProductOption(
//       sku: json['sku']?.toString() ?? '-',
//       name: json['name']?.toString() ?? '-',
//     );
//   }
// }

class StockAdjustment {
  final String date;
  final String type;
  final String productSku;
  final String productName;
  final String productUnit;
  final String warehouseName;
  final int quantity;
  final String reason;
  final bool isPendingSync;

  StockAdjustment({
    required this.date,
    required this.type,
    required this.productSku,
    required this.productName,
    required this.productUnit,
    required this.warehouseName,
    required this.quantity,
    required this.reason,
    this.isPendingSync = false,
  });

  bool get isAdd => type == 'Penambahan';
  bool get isTransfer => reason.contains('[MUTASI');

  factory StockAdjustment.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final warehouse = json['warehouse'];

    return StockAdjustment(
      date: json['date']?.toString() ?? '-',
      type: json['type']?.toString() ?? '',
      productSku: json['product_sku']?.toString() ?? '-',
      productName: product != null
          ? (product['name']?.toString() ?? 'Produk Dihapus')
          : 'Produk Dihapus',
      productUnit: product != null ? (product['unit']?.toString() ?? '') : '',
      warehouseName: warehouse != null
          ? (warehouse['name']?.toString() ?? 'Gudang Utama')
          : 'Gudang Utama',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      reason: json['reason']?.toString() ?? '-',
      isPendingSync: json['is_pending_sync'] == true,
    );
  }
}

class Warehouse {
  final int id;
  final String code;
  final String name;

  Warehouse({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? '-',
      name: json['name']?.toString() ?? '-',
    );
  }
}

class InventoryProductOption {
  final String sku;
  final String name;

  InventoryProductOption({
    required this.sku,
    required this.name,
  });

  factory InventoryProductOption.fromJson(Map<String, dynamic> json) {
    return InventoryProductOption(
      sku: json['sku']?.toString() ?? '-',
      name: json['name']?.toString() ?? '-',
    );
  }
}