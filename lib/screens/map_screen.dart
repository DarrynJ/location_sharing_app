import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? initialLocation = const LatLng(
      -25.777337119077238, 28.25658729797763); // Agile Bridge offices

  @override
  void initState() {
    super.initState();

    _initLocation().then((value) => {
          if (value != null)
            {
              setState(() {
                initialLocation = LatLng(value.latitude!, value.longitude!);
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation!,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("marker1"),
            position: initialLocation!,
            draggable: true,
            onDragEnd: (value) {
              // value is the new position
            },
            icon: markerIcon,
          ),
        },
      ),
    );
  }

  Future<LocationData?> _initLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }
}
