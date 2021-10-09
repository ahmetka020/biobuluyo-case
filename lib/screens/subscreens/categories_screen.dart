import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/models/expenses_model.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreen();
}

class _CategoriesScreen extends State<CategoriesScreen> {

  List<String> categories = [];
  List<Expense> expenses = [];

  late ExpensesDao expensesDao;

  @override
  void initState() {
    expensesDao = ExpensesDao();
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return itemCard(categories[index]);
        },

      ),
    );
  }

  Future<void> getCategories()  async {
    expenses = await expensesDao.getExpenses();
    for (var element in expenses) {
      if (!categories.contains(element.category)) {
        setState(() {
          categories.add(element.category!);
        });
      }
    }
  }

  Widget itemCard(String category) {
    double average = 0.0;
    int count = 0;
    int sum = 0;

    for (var expense in expenses) {
      if (expense.category == category) {
        count++;
        sum = sum + int.parse(expense.price!);
      }
    }
    average = sum / count;

    return SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: Colors.white,
        child: ListTile(
          trailing: Text(category, style: TextStyle(fontSize: 19),),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text((count).toString()),
            foregroundColor: Colors.white,
          ),
          title: Text("TOTAL : $sum"),
          subtitle: Text("AVERAGE : $average"),
        ),
      ),
    );
  }

}