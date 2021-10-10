import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/helpers/sqlite_db_helper.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _items = [
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 59.75,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 169.75,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Books',
      amount: 69.5,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Headphone',
      amount: 55.00,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get items {
    return [..._items];
  }

  Future<void> fetchAndSetTransactions() async {
    final dataList = await DBHelper.getData('user_expenses');
    _items = dataList
        .map(
          (item) => Transaction(
            id: item['id'],
            title: item['title'],
            amount: item['amount'],
            date: DateTime.parse(item['date']),
          ),
        )
        .toList();
  }

  List<Transaction> get recentTransactions {
    return _items.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          const Duration(
            days: 7,
          ),
        ),
      );
    }).toList();
  }

  double get totalExpense {
    double sum = 0;
    for (var element in _items) {
      sum += element.amount;
    }
    return sum;
  }

  void addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toIso8601String(),
    );

    //setState method
    _items.add(newTx);
    notifyListeners();
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return NewTransaction(addNewTransaction);

          /// for older flutter versions
          // return GestureDetector(
          //   onTap: () {},
          //   child: NewTransaction(_addNewTransaction),
          //   behavior: HitTestBehavior.opaque,
          // );
        });
  }

  void deleteTransaction(String txId) {
    _items.removeWhere((tx) => tx.id == txId);
    notifyListeners();
  }
}
