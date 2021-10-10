import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.mediaQuery,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const avaiableColors = [
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
    ];

    _bgColor = avaiableColors[Random().nextInt(5)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text(
                '\$${widget.transaction.amount}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMEd().format(widget.transaction.date) +
              DateFormat("  hh:mm a").format(widget.transaction.date),
          // style: Theme.of(context).textTheme,
        ),
        trailing: widget.mediaQuery.size.width > 400
            ? FlatButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                textColor: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
