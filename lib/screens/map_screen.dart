import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_sharing_app/screens/map_screen/map_screen_bloc.dart';
import 'package:location_sharing_app/widgets/app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenBloc _bloc = MapScreenBloc();
  GoogleMapController? _mapController;

  String googleApikey = "AIzaSyBZ4RG4eWW2h_OdquCjr1_d-6bnoIB6U1E";
  String location = "Search Location";

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
      appBar: const CustomAppBar(),
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
      child: Stack(
        children: [
          GoogleMap(
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
          Positioned(
              top: 10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.fullscreen,
                        types: [],
                        strictbounds: false,
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      final places = GoogleMapsPlaces(
                        apiKey: googleApikey,
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
                      );

                      final detail = await places
                          .getDetailsByPlaceId(place.placeId ?? '0');
                      final geometry = detail.result.geometry!;
                      final newlatlang =
                          LatLng(geometry.location.lat, geometry.location.lng);

                      setState(() {
                        location = place.description.toString();
                        _currentLocation = newlatlang;
                      });

                      _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newlatlang, zoom: 17)));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 5,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: const Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  )))
        ],
      ),
    );
  }
}
