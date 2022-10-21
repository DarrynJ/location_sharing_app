import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_sharing_app/screens/map_screen/map_screen_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenBloc _bloc = MapScreenBloc();
  GoogleMapController? _mapController;

  // Agile Bridge offices
  LatLng initialLocation = const LatLng(-25.777337119077238, 28.25658729797763);
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();

    _bloc.add(GetMyCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Location Sharing")),
      ),
      body: _buildMapScreen(),
    );
  }

  Widget _buildMapScreen() {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

    return BlocListener(
      bloc: _bloc,
      listener: ((context, state) {
        if (state is CurrentLocation) {
          setState(() {
            _currentLocation = state.location;
          });

          if (_mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(
              _currentLocation!,
            ));
          }
        } else if (state is MapScreenError) {}
      }),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _mapController = controller;
        },
        markers: {
          if (_currentLocation != null)
            Marker(
              markerId: const MarkerId("marker1"),
              position: _currentLocation!,
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
}
