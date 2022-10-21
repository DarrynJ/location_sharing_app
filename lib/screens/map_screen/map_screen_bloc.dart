import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'map_screen_event.dart';
part 'map_screen_state.dart';

class MapScreenBloc extends Bloc<MapScreenEvent, MapScreenState> {
  MapScreenBloc() : super(MapScreenInitial()) {
    on<MapScreenEvent>((event, emit) {});
    on<GetMyCurrentLocation>(_getMyCurrentLocation);
    on<ShareLocation>(_shareCurrentLocation);
    on<SendMeetupLocation>(_sendMeetupLocation);
  }

  _getMyCurrentLocation(
      GetMyCurrentLocation event, Emitter<MapScreenState> emit) async {
    try {
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

      emit(CurrentLocation(
          LatLng(_locationData.latitude!, _locationData.longitude!)));
    } catch (e) {
      print(e);
      emit(MapScreenError(MapScreenErrors.GET_CURRENT_LOCATION_ERROR));
    }
  }

  _shareCurrentLocation(ShareLocation event, Emitter<MapScreenState> emit) {
    try {
      emit(SharedCurrentLocation());
    } catch (e) {
      print(e);
      emit(MapScreenError(MapScreenErrors.LOCATION_SHARING_ERROR));
    }
  }

  _sendMeetupLocation(
      SendMeetupLocation event, Emitter<MapScreenState> emit) async {
    try {
      emit(MeetupLocationShared(event.location));
    } catch (e) {
      print(e);
      emit(MapScreenError(MapScreenErrors.DEFAULT));
    }
  }
}

enum MapScreenErrors {
  DEFAULT,
  GET_CURRENT_LOCATION_ERROR,
  LOCATION_SHARING_ERROR,
}
