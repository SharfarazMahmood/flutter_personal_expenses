import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    // print("Constructor NewTransaction Widget");
  }

  @override
  State<NewTransaction> createState() {
    // print("createState NewTransaction Widget");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    // print("Constructor NewTransactionState Widget");
  }

  @override
  void initState() {
    super.initState();
    // print("initState called");
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print("didUpdateWidget called");
  }

  @override
  void dispose() {
    super.dispose();
    // print("dispose called");
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    DateTime d = DateTime.now();

    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      d = pickedDate;
      setState(() {
        _selectedDate = DateTime(
          d.year,
          d.month,
          d.day,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("build() New_transaction");

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) => titleInput = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Ammount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) => ammountInput = value,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen"
                          : "Picked Date: " +
                              DateFormat.yMMMEd().format(_selectedDate) +
                              DateFormat("  hh:mm a").format(_selectedDate)),
                    ),
                  ],
                ),
              ),
              AdaptiveFlatButton(
                text: "Chose Date",
                handler: _presentDatePicker,
              ),
              RaisedButton(
                child: const Text("Add Transaction"),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
