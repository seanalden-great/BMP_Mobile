import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'id_ID': {
          // --- Umum & Navigasi ---
          'home': 'Beranda',
          'logout': 'Keluar',
          'logout_confirm_title': 'Konfirmasi Keluar',
          'logout_confirm_msg': 'Anda yakin ingin keluar dari sistem?',
          'cancel': 'Batal',
          'yes_logout': 'Ya, Keluar',
          'session_expired': 'Sesi Berakhir',
          'please_login_again': 'Silakan login kembali.',

          // --- Banner Offline & Sync ---
          'offline_mode_queue': 'Mode Offline (@count antrean tersimpan di HP)',
          'pending_sync_msg': '@count data offline menunggu sinkronisasi',
          'sync': 'Sync',

          // --- Dashboard ---
          'dashboard': 'Dashboard',
          'current_month': 'Bulan Berjalan',
          'sales_target': 'Target Penjualan',
          'cash_bank_balance': 'SALDO KAS & BANK',
          'margin': 'MARGIN',
          'revenue': 'Pendapatan',
          'expenses': 'Pengeluaran',
          'business_insights': 'Wawasan Bisnis',
          'top_customers': 'Pelanggan Terbaik',
          'total_spending': 'Total Pembelanjaan',
          'low_stock': 'Stok Menipis',
          'remaining_stock': 'Sisa Tersedia',
        },
        'en_US': {
          // --- Umum & Navigasi ---
          'home': 'Home',
          'logout': 'Logout',
          'logout_confirm_title': 'Confirm Logout',
          'logout_confirm_msg': 'Are you sure you want to log out?',
          'cancel': 'Cancel',
          'yes_logout': 'Yes, Logout',
          'session_expired': 'Session Expired',
          'please_login_again': 'Please log in again.',

          // --- Banner Offline & Sync ---
          'offline_mode_queue': 'Offline Mode (@count queued on device)',
          'pending_sync_msg': '@count offline items waiting to sync',
          'sync': 'Sync',

          // --- Dashboard ---
          'dashboard': 'Dashboard',
          'current_month': 'Current Month',
          'sales_target': 'Sales Target',
          'cash_bank_balance': 'CASH & BANK BALANCE',
          'margin': 'MARGIN',
          'revenue': 'Revenue',
          'expenses': 'Expenses',
          'business_insights': 'Business Insights',
          'top_customers': 'Top Customers',
          'total_spending': 'Total Spending',
          'low_stock': 'Low Stock',
          'remaining_stock': 'Available Stock',
        },
      };
}