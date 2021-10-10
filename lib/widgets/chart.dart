import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/chat_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransaectionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpendng {
    return groupedTransaectionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransaectionValues);
    // print("build() Chart");
    return Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Container(
          padding: const  EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransaectionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpendng == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpendng,
                ),
              );
            }).toList(),
          ),
        ));
  }
}
