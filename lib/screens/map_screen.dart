import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location_sharing_app/screens/map_screen/map_screen_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';

class MapScreen extends StatefulWidget {
  final String username;

  const MapScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapScreenBloc _bloc = MapScreenBloc();
  final Set<Marker> _markers = <Marker>{};

  GoogleMapController? _mapController;
  bool focusOnMyLocation = true;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  String googleApiKey = "AIzaSyBZ4RG4eWW2h_OdquCjr1_d-6bnoIB6U1E";
  String location = "Search Location";

  // Agile Bridge offices
  LatLng initialLocation = const LatLng(-25.777337119077238, 28.25658729797763);
  LatLng? _userCurrentLocation;
  LatLng? _agentCurrentLocation;
  LatLng? _meetupLocation;
  Timer? timer;

  HubConnection hubConnection = HubConnectionBuilder()
      .withUrl("https://99bb-105-186-246-233.in.ngrok.io/trackinghub")
      .withAutomaticReconnect()
      .build();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetMyCurrentLocation());
    addCustomIcon();

    hubConnection.on("ReceiveMessage", receiveMessage);
    hubConnection.on("ReceiveMeetupLocation", receiveMeetup);

    hubConnection.start();
    var count = 1;
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      _bloc.add(GetMyCurrentLocation());
      final lat = initialLocation.latitude + (0.0002 * count++);
      final long = initialLocation.longitude + (0.0002 * count++);
      _userCurrentLocation = LatLng(lat, long);

      setState(() {
        _markers.removeWhere((element) => element.markerId.value == 'Arno');
        _markers.add(
          Marker(
            markerId: MarkerId("Current location"),
            position: _userCurrentLocation!,
          ),
        );
      });

      if (hubConnection.state == HubConnectionState.Disconnected) {
        await hubConnection.start();
      }

      sendMessage(widget.username, _userCurrentLocation!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _buildMapScreen(),
    );
  }

  Widget _buildMapScreen() {
    return BlocListener(
      bloc: _bloc,
      listener: ((context, state) async {
        if (state is CurrentLocation) {
          setState(() {
            _userCurrentLocation = state.location;

            _markers.add(
              Marker(
                markerId: const MarkerId("Current location"),
                position: _userCurrentLocation!,
              ),
            );
          });

          if (_mapController != null && focusOnMyLocation) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(
              _userCurrentLocation!,
            ));

            focusOnMyLocation = false;
          }
        } else if (state is MeetupLocationShared) {
          await _reInitHub();
          if (hubConnection.state == HubConnectionState.Connected) {
            await hubConnection.invoke("SetMeetupLocation", args: <Object>
                //update accordingly
                [
              state.sharedLocation.latitude.toString(),
              state.sharedLocation.longitude.toString()
            ]);
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
              top: 80,
              child: InkWell(
                  onTap: () async {
                    await hubConnection.stop();

                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApiKey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        onError: (err) {
                          print(err);
                        });

                    if (place != null) {
                      final places = GoogleMapsPlaces(
                        apiKey: googleApiKey,
                        apiHeaders: await const GoogleApiHeaders().getHeaders(),
                      );

                      final detail = await places
                          .getDetailsByPlaceId(place.placeId ?? '0');
                      final geometry = detail.result.geometry!;
                      final newLatLang =
                          LatLng(geometry.location.lat, geometry.location.lng);

                      setState(() {
                        location = place.description.toString();
                      });

                      _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: newLatLang, zoom: 17)));

                      _agentCurrentLocation = newLatLang;
                      updateMarker('meetup', _agentCurrentLocation!);
                      sendMessage('SetMeetupLocation', _userCurrentLocation!);
                      _bloc.add(SendMeetupLocation(newLatLang));
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
    debugPrint('[RECEIVED] message: $parameters');
    if (parameters != null && parameters.length >= 2) {
      final String username = parameters[0] as String;
      final double latitude = parameters[1] as double;
      final double longitude = parameters[2] as double;

      final LatLng userLocation = LatLng(latitude, longitude);

      updateMarker(username, userLocation);
    }
  }

  void receiveMeetup(List<Object?>? parameters) {
    debugPrint('[RECEIVED] Meetup: $parameters');
    if (parameters != null && parameters.isNotEmpty) {
      final double latitude = parameters[1] as double;
      final double longitude = parameters[2] as double;

      final LatLng meetupLocation = LatLng(latitude, longitude);
      updateMarker("meetup", meetupLocation);
    }
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/wbclogo.png")
        .then(
      (icon) => setState(() {
        markerIcon = icon;
      }),
    );
  }

  Future<void> _reInitHub() async {
    hubConnection = HubConnectionBuilder()
        .withUrl("https://db4c-105-186-246-233.in.ngrok.io/trackinghub")
        .withAutomaticReconnect(
      retryDelays: [10, 20, 30],
    ).build();

    hubConnection.on("ReceiveMessage", receiveMessage);
    hubConnection.on("ReceiveMeetupLocation", receiveMeetup);

    await hubConnection.start();
  }

  void updateMarker(String markerId, LatLng location) {
    setState(() {
      _markers.removeWhere((element) => element.markerId.value == "meetup");
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: location,
        ),
      );
    });
  }

  void sendMessage(String name, LatLng location) async {
    await hubConnection.invoke("SendMessage", args: <Object>[
      name,
      location.latitude.toString(),
      location.longitude.toString()
    ]);
  }
}
