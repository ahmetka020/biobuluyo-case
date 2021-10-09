import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/screens/subscreens/categories_screen.dart';
import 'package:biobuluyo/screens/subscreens/expense_screen.dart';
import 'package:biobuluyo/screens/subscreens/list_expenses_screen.dart';
import 'package:biobuluyo/utils/navigation_util.dart';
import 'package:flutter/material.dart';

import 'map/add_google_map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  ExpensesDao expensesDao = ExpensesDao();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Column(
          children: [
            const Spacer(),
            addExpenseButton(),
            const Spacer(),
            listScreenButton(),
            const Spacer(),
            categoriesScreenButton(),
            const Spacer(),
          ],
        ),
      )
    );
  }

  Widget addExpenseButton() {
    return SizedBox(
      height: 100,
      width: 200,
      child: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: const Text(
          "Add Expense",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          NavigationUtil.gotoPage(context, const ExpenseScreen());
        },
      ),
    );
  }

  Widget listScreenButton() {
    return SizedBox(
      height: 100,
      width: 200,
      child: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: const Text(
          "List Expenses",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          NavigationUtil.gotoPage(context, const ListExpensesScreen());
        },
      ),
    );
  }

  Widget categoriesScreenButton() {
    return SizedBox(
      height: 100,
      width: 200,
      child: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: const Text(
          "Categories",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          NavigationUtil.gotoPage(context,const CategoriesScreen());
        },
      ),
    );
  }

}