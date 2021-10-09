import 'package:biobuluyo/models/expenses_model.dart';
import 'package:biobuluyo/models/markers_model.dart';
import 'package:flutter/material.dart';

class MarkerDetailScreen extends StatefulWidget {
  final Expense expense;
  final MarkerModel markerModel;

  const MarkerDetailScreen({Key? key, required this.expense, required this.markerModel})
      : super(key: key);

  @override
  State<MarkerDetailScreen> createState() => _MarkerDetailScreen(expense,markerModel);
}

class _MarkerDetailScreen extends State<MarkerDetailScreen> {
  final Expense expense;
  final MarkerModel markerModel;

  _MarkerDetailScreen(this.expense, this.markerModel);

  @override
  void initState() {
    print(expense.toJson());
    print(markerModel.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Container(height: 200,),
            insideDividerWidget("DESCRIPTION: ${expense.description}"),
            insideDividerWidget("PRICE: ${expense.price}"),
            insideDividerWidget("DATE: ${DateTime.fromMillisecondsSinceEpoch(expense.date!).toString().substring(0,10)}"),
            insideDividerWidget("CATEGORY: ${expense.category}"),
            insideDividerWidget("LANTITUDE: ${markerModel.lat}"),
            insideDividerWidget("LONGITUDE: ${markerModel.lng}"),
            const Divider(thickness: 2,),
          ],
        )
    );
  }

  Widget insideDividerWidget(String text) {
    return Column(
      children: [
        const Divider(thickness: 2,),
        Container(height: 30,),
        Text(text),
        Container(height: 30,),
      ],
    );
  }
}
