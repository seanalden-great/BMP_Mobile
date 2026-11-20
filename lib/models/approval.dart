// class Approval {
//   final String docTypeCode;
//   final String docType;
//   final String date;
//   final String referenceNo;
//   final String person;
//   final double amount;
//   final String approveUrl;
//   final String rejectUrl;

//   Approval({
//     required this.docTypeCode,
//     required this.docType,
//     required this.date,
//     required this.referenceNo,
//     required this.person,
//     required this.amount,
//     required this.approveUrl,
//     required this.rejectUrl,
//   });

//   // Helper praktis untuk mengecek apakah dokumen ini Sales Order
//   bool get isSO => docTypeCode == 'SO';

//   // Konversi dari JSON API Laravel ke Object Dart
//   factory Approval.fromJson(Map<String, dynamic> json) {
//     return Approval(
//       docTypeCode: json['doc_type_code']?.toString() ?? '',
//       docType: json['doc_type']?.toString() ?? '-',
//       date: json['date']?.toString() ?? '',
//       referenceNo: json['reference_no']?.toString() ?? '-',
//       person: json['person']?.toString() ?? '-',
//       amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
//       approveUrl: json['approve_url']?.toString() ?? '',
//       rejectUrl: json['reject_url']?.toString() ?? '',
//     );
//   }

//   // Konversi kembali ke JSON (opsional, berguna jika perlu cache lokal)
//   Map<String, dynamic> toJson() {
//     return {
//       'doc_type_code': docTypeCode,
//       'doc_type': docType,
//       'date': date,
//       'reference_no': referenceNo,
//       'person': person,
//       'amount': amount,
//       'approve_url': approveUrl,
//       'reject_url': rejectUrl,
//     };
//   }
// }

class Approval {
  final String docTypeCode;
  final String docType;
  final String date;
  final String referenceNo;
  final String person;
  final double amount;
  final String approveUrl;
  final String rejectUrl;
  final String? pendingStatus; // 'Disetujui' / 'Ditolak' jika menunggu sync offline

  Approval({
    required this.docTypeCode,
    required this.docType,
    required this.date,
    required this.referenceNo,
    required this.person,
    required this.amount,
    required this.approveUrl,
    required this.rejectUrl,
    this.pendingStatus,
  });

  bool get isSO => docTypeCode == 'SO';
  bool get isPendingSync => pendingStatus != null;

  Approval copyWith({String? pendingStatus}) {
    return Approval(
      docTypeCode: docTypeCode,
      docType: docType,
      date: date,
      referenceNo: referenceNo,
      person: person,
      amount: amount,
      approveUrl: approveUrl,
      rejectUrl: rejectUrl,
      pendingStatus: pendingStatus ?? this.pendingStatus,
    );
  }

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      docTypeCode: json['doc_type_code']?.toString() ?? '',
      docType: json['doc_type']?.toString() ?? '-',
      date: json['date']?.toString() ?? '',
      referenceNo: json['reference_no']?.toString() ?? '-',
      person: json['person']?.toString() ?? '-',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      approveUrl: json['approve_url']?.toString() ?? '',
      rejectUrl: json['reject_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_type_code': docTypeCode,
      'doc_type': docType,
      'date': date,
      'reference_no': referenceNo,
      'person': person,
      'amount': amount,
      'approve_url': approveUrl,
      'reject_url': rejectUrl,
    };
  }
}