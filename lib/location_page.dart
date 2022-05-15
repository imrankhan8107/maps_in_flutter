import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    // getData();
  }

  void getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    setState(() {
      latitude = _locationData.latitude!;
      longitude = _locationData.longitude!;
    });
    print({latitude, longitude});
  }

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    final LatLng _center = LatLng(28.7041, 77.1025);
    return Scaffold(
      body: Center(
        child: GoogleMap(
          myLocationEnabled: true,
          onTap: (LatLng latlng) {
            setState(() {
              _markers.add(
                Marker(
                  position: latlng,
                  markerId: MarkerId('marker$i'),
                  infoWindow: InfoWindow(
                    title: 'marker$i',
                  ),
                ),
              );
              i++;
            });
            print(_markers);
          },
          onMapCreated: _onMapCreated,
          markers: _markers,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
