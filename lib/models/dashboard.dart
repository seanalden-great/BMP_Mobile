class DashboardSummary {
  final String bulan;
  final double persentaseTarget;
  final double pendapatan;
  final double targetPenjualan;
  final double saldoKas;
  final double profitMargin;
  final double pengeluaran;

  DashboardSummary({
    required this.bulan,
    required this.persentaseTarget,
    required this.pendapatan,
    required this.targetPenjualan,
    required this.saldoKas,
    required this.profitMargin,
    required this.pengeluaran,
  });

  // Helper agar nilai progress bar selalu aman di rentang 0.0 - 1.0
  double get targetProgress => (persentaseTarget / 100.0).clamp(0.0, 1.0);

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      bulan: json['bulan']?.toString() ?? 'Bulan Berjalan',
      persentaseTarget:
          double.tryParse(json['persentase_target']?.toString() ?? '0') ?? 0.0,
      pendapatan: double.tryParse(json['pendapatan']?.toString() ?? '0') ?? 0.0,
      targetPenjualan:
          double.tryParse(json['target_penjualan']?.toString() ?? '0') ?? 0.0,
      saldoKas: double.tryParse(json['saldo_kas']?.toString() ?? '0') ?? 0.0,
      profitMargin:
          double.tryParse(json['profit_margin']?.toString() ?? '0') ?? 0.0,
      pengeluaran:
          double.tryParse(json['pengeluaran']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class TopCustomerItem {
  final String name;
  final double totalSpent;

  TopCustomerItem({
    required this.name,
    required this.totalSpent,
  });

  factory TopCustomerItem.fromJson(Map<String, dynamic> json) {
    final contact = json['contact'];
    return TopCustomerItem(
      name: contact != null ? (contact['name']?.toString() ?? 'Umum') : 'Umum',
      totalSpent:
          double.tryParse(json['total_spent']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class LowStockItem {
  final String name;
  final int totalStock;
  final String unit;

  LowStockItem({
    required this.name,
    required this.totalStock,
    required this.unit,
  });

  factory LowStockItem.fromJson(Map<String, dynamic> json) {
    return LowStockItem(
      name: json['name']?.toString() ?? '-',
      totalStock: int.tryParse(json['total_stock']?.toString() ?? '0') ?? 0,
      unit: json['unit']?.toString() ?? '',
    );
  }
}