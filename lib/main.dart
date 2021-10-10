// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:io';

import 'package:personal_expenses/providers/transavtions_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/trasnsaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TransactionsProvider(),
      child: MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          // accentColor: Colors.lightGreen,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  // final List<Transaction> _userTransactions = [];

  // methods

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // // getter
  // List<Transaction> get _recentTransactions {
  //   return _userTransactions.where((tx) {
  //     return tx.date.isAfter(
  //       DateTime.now().subtract(
  //         Duration(
  //           days: 7,
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }

  // void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
  //   final newTx = Transaction(
  //     title: txTitle,
  //     amount: txAmount,
  //     date: txDate,
  //     id: DateTime.now().toString(),
  //   );

  //   //setState method
  //   setState(() {
  //     _userTransactions.add(newTx);
  //   });
  // }

  // void _startAddNewTransaction(BuildContext ctx) {
  //   showModalBottomSheet(
  //       context: ctx,
  //       builder: (bctx) {
  //         return NewTransaction(_addNewTransaction);

  //         /// for older flutter versions
  //         // return GestureDetector(
  //         //   onTap: () {},
  //         //   child: NewTransaction(_addNewTransaction),
  //         //   behavior: HitTestBehavior.opaque,
  //         // );
  //       });
  // }

  // void _deleteTransaction(String txId) {
  //   setState(() {
  //     _userTransactions.removeWhere((tx) => tx.id == txId);
  //   });
  // }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    bool isLandScape,
    Widget txListWidget,
    List recentTransactions,
  ) {
    final chartWidgetHeight = isLandScape ? 0.7 : 0.3;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  chartWidgetHeight,
              child: Chart(recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    bool isLandScape,
    Widget txListWidget,
    List recentTransactions,
  ) {
    final chartWidgetHeight = isLandScape ? 0.7 : 0.3;
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            chartWidgetHeight,
        child: Chart(recentTransactions),
      ),
      txListWidget,
    ];
  }

  Widget _buildAppBar(Function startAddNewTransaction) {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => startAddNewTransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // print("build() MyHomePage");
    TransactionsProvider transactionsProvider =
        Provider.of<TransactionsProvider>(context);

    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar(
      transactionsProvider.startAddNewTransaction,
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactionsProvider.items,
        transactionsProvider.deleteTransaction,
      ),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                isLandScape,
                txListWidget,
                transactionsProvider.recentTransactions,
              ),
            if (!isLandScape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                isLandScape,
                txListWidget,
                transactionsProvider.recentTransactions,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () =>
                        transactionsProvider.startAddNewTransaction(context),
                  ),
          );
  }
}
