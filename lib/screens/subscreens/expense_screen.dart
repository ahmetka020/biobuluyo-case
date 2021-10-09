import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/database/markers_dao.dart';
import 'package:biobuluyo/models/expenses_model.dart';
import 'package:biobuluyo/models/markers_model.dart';
import 'package:biobuluyo/screens/map/add_google_map_screen.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreen();
}

class _ExpenseScreen extends State<ExpenseScreen> {

  late TextEditingController descriptionController;
  late TextEditingController priceController;

  late ExpensesDao expensesDao;
  late MarkersDao markersDao;

  final List<String> _categories = [
    "Sale",
    "Rent",
    "Other"
  ];

  DateTime? selectedDate;

  String selectedCategory = "Sale";

  MarkerModel? markerModel;

  @override
  void initState() {
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    expensesDao = ExpensesDao();
    markersDao = MarkersDao();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 10,top: 100,right: 10),
        child: Column(
          children: [
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            Container(height: 30,),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Price',
              ),
            ),
            Container(height: 30,),
            dateButton(),
            Container(height: 30,),
            categoryDropdown(),
            Container(height: 30,),
            googleMapsButton(),
            Container(height: 150,),
            addExpenseButton(),
          ],
        )
      )
    );
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget addExpenseButton() {
    return SizedBox(
      height: 50,
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
          addExpense();
        },
      ),
    );
  }

  Widget categoryDropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Please select expense',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: selectedCategory.isEmpty,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isDense: true,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  state.didChange(newValue);
                });
              },
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget dateButton() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Text(
          (selectedDate != null) ? selectedDate!.toString().substring(0,10) : "Select Date",
          style: const TextStyle(fontSize: 17),
        ),
        onPressed: () {
          selectDate();
        },
      ),
    );
  }

  Widget googleMapsButton() {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      child: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: const Text(
          "Add Location",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddGoogleMapScreen()));
          if (result != null) {
            markerModel = MarkerModel.fromJson(result);
          }
        },
      ),
    );
  }

  void addExpense() async {
    if (descriptionController.text.isEmpty) {
      showToast("Description cannot be empty!");
      return;
    }
    if (priceController.text.isEmpty) {
      showToast("Price cannot be empty!");
      return;
    } else {
      try {
        print(priceController.text);
        var x = double.parse(priceController.text);
      } catch(e) {
        showToast("Invalid Price");
        return;
      }
    }
    if (selectedDate == null) {
      showToast("Please select a date!");
      return;
    }
    try{
      Expense expense = Expense();
      expense.description = descriptionController.text;
      expense.price = priceController.text;
      expense.map = "";
      expense.category = selectedCategory;
      expense.date = selectedDate!.millisecondsSinceEpoch;
      if (markerModel != null) {
        expense.map = "${markerModel!.lng}${markerModel!.lat}";
        markerModel!.name = expense.map;
        await markersDao.createMarker(markerModel!);
      }
      await expensesDao.createExpense(expense);
      print(expense.toJson());
      showToast("SAVED!");
      Navigator.of(context).pop();
    }catch (e) {
      showToast("Something went wrong!");
      print("exc: $e");
    }
  }

  /*
  ANDROID
  AIzaSyBasnP-7DbEYwJtsQxp9M6-whkLWe0tjzU
  IOS
  AIzaSyCF-peMfU-O6Q_2BgeMZWxupMns9nfjYzo
   */

  void showToast(String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }



}