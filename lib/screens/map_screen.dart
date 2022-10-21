import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_sharing_app/screens/map_screen/map_screen_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:location_sharing_app/widgets/app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenBloc _bloc = MapScreenBloc();
  GoogleMapController? _mapController;

  bool focusOnMyLocation = true;

  final Set<Marker> _markers = <Marker>{};

  String googleApikey =
      "AIzaSyCGPG0BidmAmtCvAqm22SpPAqftfH285bg"; //"AIzaSyBZ4RG4eWW2h_OdquCjr1_d-6bnoIB6U1E";
  String location = "Search Location";

  // Agile Bridge offices
  LatLng initialLocation = const LatLng(-25.777337119077238, 28.25658729797763);
  LatLng? _currentLocation;
  Timer? timer;

  final hubConnection = HubConnectionBuilder()
      .withUrl("https://db4c-105-186-246-233.in.ngrok.io/trackinghub")
      .build();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetMyCurrentLocation());
    hubConnection.on("ReceiveMessage", receiveMessage);

    hubConnection.start();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      _bloc.add(GetMyCurrentLocation());

      if (hubConnection.state != HubConnectionState.Connected) {
        await hubConnection.start();
      }

      final result = await hubConnection.invoke("SendMessage", args: <Object>
          //update accordingly
          ["Username", _currentLocation.toString()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _buildMapScreen(),
    );
  }

  Widget _buildMapScreen() {
    return BlocListener(
      bloc: _bloc,
      listener: ((context, state) {
        if (state is CurrentLocation) {
          setState(() {
            _currentLocation = state.location;

            _markers.add(
              Marker(
                markerId: const MarkerId("Current location"),
                position: _currentLocation!,
              ),
            );
          });

          if (_mapController != null && focusOnMyLocation) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(
              _currentLocation!,
            ));

            focusOnMyLocation = false;
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
            markers: _markers,
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

  void receiveMessage(List<Object?>? parameters) {
    if (parameters != null && parameters.length >= 2) {
      final String username = parameters[0] as String;
      final List<String> location = (parameters[1] as String)
          .replaceAll("LatLng(", "")
          .replaceAll(")", "")
          .split(",");

      final LatLng userLocation =
          LatLng(double.parse(location[0]), double.parse(location[1]));

      setState(() {
        _markers.removeWhere((element) => element.markerId.value == username);
        _markers.add(
          Marker(
            markerId: MarkerId(username),
            position: userLocation,
          ),
        );
      });
    }
  }
  //update the marker for other users
}
