import 'package:biobuluyo/models/markers_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddGoogleMapScreen extends StatefulWidget {
  const AddGoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<AddGoogleMapScreen> createState() => _GoogleMapScreen();
}

class _GoogleMapScreen extends State<AddGoogleMapScreen> {
  final double _originLatitude = 38.392300;
  final double _originLongitude = 27.047840;

  late GoogleMapController _controller;
  late CameraPosition _initialCameraPosition;

  LatLng? clickedPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Marker? m;

  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(_originLatitude, _originLongitude),
      zoom: 15,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onSaveClicked,
        child: const Icon(Icons.save),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
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
        onTap: (latLng) {
          clickedPosition = latLng;
          addMarker(name: "name", id: "id", latLng: clickedPosition!);
        },
      ),
    );
  }


  void addMarker({required String name, required String id,required LatLng latLng}) {
    var markerId = MarkerId(id);
    m = Marker(
        infoWindow: InfoWindow(title: name),
        markerId: markerId,
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
    setState(() {
      markers[markerId] = m!;
    });
  }

  void onSaveClicked() {
    MarkerModel markerModel = MarkerModel();
    if (m == null) {
      Navigator.of(context).pop();
    } else {
      markerModel.lat = m!.position.latitude;
      markerModel.lng = m!.position.longitude;
      markerModel.name = "";
      Navigator.of(context).pop(markerModel.toJson());
    }
  }

}