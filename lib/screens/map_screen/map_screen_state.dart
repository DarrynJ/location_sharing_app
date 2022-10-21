part of 'map_screen_bloc.dart';

@immutable
abstract class MapScreenState {}

class MapScreenInitial extends MapScreenState {}

class CurrentLocation extends MapScreenState {
  final LatLng location;

  CurrentLocation(this.location);
}

class LocationShared extends MapScreenState {
  final LatLng sharedLocation;

  LocationShared(this.sharedLocation);
}

class SharedCurrentLocation extends MapScreenState {}

class MapScreenError extends MapScreenState {
  final MapScreenErrors error;

  MapScreenError(this.error);
}
