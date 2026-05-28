enum TransactionType { deposit, withdrawal }

class WalletTransaction {
  final int id;
  final TransactionType type;
  final int amount;
  final String date;
  final String note;
  final int? byId;
  final String? byName;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.note,
    this.byId,
    this.byName,
  });
}
