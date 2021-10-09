import 'dart:async';
import 'package:biobuluyo/models/markers_model.dart';

import 'database.dart';


class MarkersDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createMarker(MarkerModel marker) async {
    final db = await dbProvider.database;
    var result = db!.insert(markersTable, marker.toJson());
    return result;
  }

  Future<List<MarkerModel>> getMarkers({List<String>? columns, int? query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null) {
      result = await db!.query(markersTable,
          columns: columns, where: 'id LIKE ?', whereArgs: [query]);
    } else {
      result = await db!.query(markersTable, columns: columns);
    }

    List<MarkerModel> markers = result.isNotEmpty
        ? result.map((item) => MarkerModel.fromJson(item)).toList()
        : [];
    return markers;
  }

  Future<int> updateMarker(MarkerModel marker) async {
    final db = await dbProvider.database;
    var result = await db!.update(markersTable, marker.toJson(),
        where: "id = ?", whereArgs: [marker.id]);
    return result;
  }

  Future<int> deleteMarker(int id) async {
    final db = await dbProvider.database;
    var result = await db!.delete(markersTable, where: 'id = ?', whereArgs: [
      id
    ]);
    return result;
  }

  Future deleteAllMarkers() async {
    final db = await dbProvider.database;
    var result = await db!.delete(
      markersTable,
    );
    return result;
  }

  Future<MarkerModel?> getMarkerById(int id) async {
    final db = await dbProvider.database;
    var result = await db!.query("$markersTable WHERE id=$id");
    List<MarkerModel> markers = result.isNotEmpty
        ? result.map((item) => MarkerModel.fromJson(item)).toList()
        : [];
    if (markers.isNotEmpty) {
      return markers[0];
    }
  }
}
