import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/database/markers_dao.dart';
import 'package:biobuluyo/models/expenses_model.dart';
import 'package:biobuluyo/models/markers_model.dart';
import 'package:biobuluyo/screens/map/add_google_map_screen.dart';
import 'package:flutter/material.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({Key? key,required this.expense}) : super(key: key);

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreen(expense);
}

class _EditExpenseScreen extends State<EditExpenseScreen> {
  final Expense expense;

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

  _EditExpenseScreen(this.expense);

  @override
  void initState() {
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    expensesDao = ExpensesDao();
    markersDao = MarkersDao();
    selectedDate = DateTime.fromMillisecondsSinceEpoch(expense.date!);
    selectedCategory = expense.category!;
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: expense.description,
                  ),
                ),
                Container(height: 30,),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: expense.price,
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
          "Edit Expense",
          style: TextStyle(fontSize: 17),
        ),
        onPressed: () {
          editExpense();
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
          (selectedDate != null) ? selectedDate!.toString().substring(0,11) : "Select Date",
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
          "Edit Location",
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

  void editExpense() async {
    var description = "";
    var price = "";
    if (descriptionController.text.isEmpty) {
      description = expense.description!;
    } else {
      description = descriptionController.text;
    }
    if (priceController.text.isEmpty) {
      price = expense.price!;
    } else {
      try {
        var x = double.parse(priceController.text);
        price = priceController.text;
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
      expense.description = description;
      expense.price = price;
      expense.map = "";
      expense.category = selectedCategory;
      expense.date = selectedDate!.millisecondsSinceEpoch;
      print(expense.toJson());
      if (markerModel != null) {
        expense.map = "${markerModel!.lng}${markerModel!.lat}";
        markerModel!.name = expense.map;
        await markersDao.createMarker(markerModel!);
      }
      await expensesDao.updateExpense(expense);
      showToast("EDIT SUCCESSFUL!");
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