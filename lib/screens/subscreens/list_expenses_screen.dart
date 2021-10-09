import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/models/expenses_model.dart';
import 'package:biobuluyo/screens/details/edit_expenses_screen.dart';
import 'package:biobuluyo/screens/map/list_google_map_screen.dart';
import 'package:biobuluyo/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListExpensesScreen extends StatefulWidget {
  const ListExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ListExpensesScreen> createState() => _ListExpensesScreen();
}

class _ListExpensesScreen extends State<ListExpensesScreen> {
  late ExpensesDao expensesDao;
  List<Expense> expenses = [];

  @override
  void initState() {
    expensesDao = ExpensesDao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDataFromDatabase();
    return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 100, bottom: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: expenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return expenseCard(expenses[index]);
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: 200,
              child: FloatingActionButton(
                heroTag: null,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: const Text(
                  "SHOW ALL IN MAPS",
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  NavigationUtil.gotoPage(context, const ListGoogleMapScreen());
                },
              ),
            )
      ],
    ));
  }

  Widget expenseCard(Expense expense) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text((expenses.indexOf(expense) + 1).toString()),
            foregroundColor: Colors.white,
          ),
          title: Text("PRICE : ${expense.price ?? ""}"),
          subtitle: Text("DESCRIPTION : ${expense.description ?? ""}"),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => editClicked(expense),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteClicked(expense),
        ),
      ],
    );
  }

  void getDataFromDatabase() async {
    expensesDao.getExpenses().then((allExpenses) => {
          setState(() {
            expenses = allExpenses;
          })
        });
  }

  Future<void> editClicked(Expense expense) async {

    Navigator.push(context, MaterialPageRoute(builder: (context) => EditExpenseScreen(expense: expense))).whenComplete(() => print("completed"));

  }

  void deleteClicked(Expense expense) {
    expensesDao.deleteExpense(expense.id!).whenComplete(() => {
          setState(() {
            expenses.remove(expense);
          })
        });
  }
}
