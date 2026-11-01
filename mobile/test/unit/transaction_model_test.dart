import 'package:flutter_test/flutter_test.dart';
import 'package:peso_plan/features/transactions/domain/transaction_model.dart';

void main() {
  test('expense API amounts are normalized for negative display', () {
    final transaction = TransactionModel.fromJson({
      'id': 7,
      'payee': 'SM Hypermarket',
      'amount_cents': 250000,
      'type': 'expense',
      'category': {'name': 'Groceries'},
      'account': {'name': 'Checking'},
      'date': '2026-10-28',
    });

    expect(transaction.amountCents, -250000);
    expect(transaction.isIncome, isFalse);
  });

  test('income API amounts remain positive', () {
    final transaction = TransactionModel.fromJson({
      'id': 8,
      'payee': 'Salary',
      'amount_cents': 4500000,
      'type': 'income',
      'date': '2026-10-28',
    });

    expect(transaction.amountCents, 4500000);
    expect(transaction.isIncome, isTrue);
  });
}
