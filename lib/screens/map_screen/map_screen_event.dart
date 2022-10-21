part of 'map_screen_bloc.dart';

@immutable
abstract class MapScreenEvent {}

class ShareLocation extends MapScreenEvent {
  final LatLng location;

  ShareLocation(this.location);
}

class GetMyCurrentLocation extends MapScreenEvent {}

class SendMeetupLocation extends MapScreenEvent {
  final LatLng location;

  SendMeetupLocation(this.location);
}
