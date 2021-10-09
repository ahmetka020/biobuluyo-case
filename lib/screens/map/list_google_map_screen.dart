import 'package:biobuluyo/database/expenses_dao.dart';
import 'package:biobuluyo/database/markers_dao.dart';
import 'package:biobuluyo/models/expenses_model.dart';
import 'package:biobuluyo/models/markers_model.dart';
import 'package:biobuluyo/screens/details/marker_detail_screen.dart';
import 'package:biobuluyo/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListGoogleMapScreen extends StatefulWidget {
  const ListGoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<ListGoogleMapScreen> createState() => _GoogleMapScreen();
}

class _GoogleMapScreen extends State<ListGoogleMapScreen> {
  final double _originLatitude = 38.392300;
  final double _originLongitude = 27.047840;

  GoogleMapController? _controller;
  late CameraPosition _initialCameraPosition;

  LatLng? clickedPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late MarkersDao markersDao;
  late ExpensesDao expensesDao;

  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(_originLatitude, _originLongitude),
      zoom: 15,
    );
    markersDao = MarkersDao();
    expensesDao = ExpensesDao();
    getMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }


  void addMarker({required String name, required String id,required LatLng latLng, required Expense expense, required MarkerModel markerModel}) {
    var markerId = MarkerId(id);
    var m = Marker(
        infoWindow: InfoWindow(title: name),
        markerId: markerId,
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        onTap: () {
          NavigationUtil.gotoPage(context, MarkerDetailScreen(expense: expense, markerModel: markerModel));
        }
    );
    setState(() {
      markers[markerId] = m;
    });
  }

  void getMarkers() async {
    List<MarkerModel> allMarkers = [];
    List<Expense> allExpenses = [];
    allMarkers = await markersDao.getMarkers();
    allExpenses = await expensesDao.getExpenses();
    for(var m in allMarkers) {
      try {
        var tmp = allExpenses.firstWhere((element) => element.map == m.name);
        setState(() {
          addMarker(name: tmp.description!, id: tmp.map!, latLng: LatLng(m.lat!, m.lng!),expense: tmp, markerModel: m);
        });
      } catch (e) {
        print("EXC: $e");
      }
    }
  }
}