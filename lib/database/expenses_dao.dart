import 'dart:async';
import 'package:biobuluyo/models/expenses_model.dart';
import 'database.dart';


class ExpensesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createExpense(Expense expense) async {
    final db = await dbProvider.database;
    var result = db!.insert(expensesTable, expense.toJson());
    return result;
  }

  Future<List<Expense>> getExpenses({List<String>? columns, int? query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null) {
      result = await db!.query(expensesTable,
          columns: columns, where: 'id LIKE ?', whereArgs: [query]);
    } else {
      result = await db!.query(expensesTable, columns: columns);
    }

    List<Expense> expenses = result.isNotEmpty
        ? result.map((item) => Expense.fromJson(item)).toList()
        : [];
    return expenses;
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await dbProvider.database;
    var result = await db!.update(expensesTable, expense.toJson(),
        where: "id = ?", whereArgs: [expense.id]);
    return result;
  }

  Future<int> deleteExpense(int id) async {
    final db = await dbProvider.database;
    var result = await db!.delete(expensesTable, where: 'id = ?', whereArgs: [
      id
    ]);
    return result;
  }

  Future deleteAllExpenses() async {
    final db = await dbProvider.database;
    var result = await db!.delete(
      expensesTable,
    );
    return result;
  }

  Future<Expense?> getExpenseById(int id) async {
    final db = await dbProvider.database;
    var result = await db!.query("$expensesTable WHERE id=$id");
    List<Expense> expenses = result.isNotEmpty
        ? result.map((item) => Expense.fromJson(item)).toList()
        : [];
    if (expenses.isNotEmpty) {
      return expenses[0];
    }
  }
}
