class Expense {
  int? id;
  String? description;
  String? price;
  int? date;
  String? category;
  String? map;

  Expense({this.id, this.description, this.price, this.date, this.category, this.map});

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
      id: json["id"],
      description: json["description"],
      price: json["price"],
      date: json["date"],
      category: json["category"],
      map: json["map"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "price": price,
    "date": date,
    "category": category,
    "map": map
  };
}
