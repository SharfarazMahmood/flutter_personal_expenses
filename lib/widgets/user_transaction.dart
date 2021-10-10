import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './new_transaction.dart';
import './trasnsaction_list.dart';

class UserTransaction extends StatefulWidget {
  // const UserTransaction({ Key? key }) : super(key: key);

  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  @override
  Widget build(BuildContext context) {
    print("build() User_Transaction");
    return Column(
      children: <Widget>[
        // NewTransaction(_addNewTransaction),
        // TransactionList(_userTransactions),
      ],
    );
  }
}
