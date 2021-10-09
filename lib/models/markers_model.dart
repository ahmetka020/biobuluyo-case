class MarkerModel {
  int? id;
  String? name;
  String? markerId;
  double? lat;
  double? lng;


  MarkerModel({this.id, this.name, this.markerId, this.lat, this.lng});

  factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
      id: json["id"],
      name: json["name"],
      markerId: json["markerId"],
      lat: json["lat"],
      lng: json["lng"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "markerId": markerId,
    "lat": lat,
    "lng": lng
  };
}