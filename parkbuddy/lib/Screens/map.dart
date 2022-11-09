import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapSample extends StatefulWidget {
  final double carLat;
  final double carLong;

  const MapSample({Key? key, required this.carLat, required this.carLong})
      : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final _myBox = Hive.box('mybox2');
  var _indexCar;
  static late double carLong;
  static late double carLat;
  static var _latitude;
  static var _longitude;
  bool changedCam = false;

  Set<Polyline> _polylines = Set<Polyline>();

  int _polylineIdCounter = 1;

  @override
  void initState() {
    carLat = widget.carLat;
    carLong = widget.carLong;
    _indexCar = getCarIndex();
    _updatePosition();
    //getDirections(LatLng(carLat, carLong), LatLng(_latitude, _longitude + 0.1));
    super.initState();
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter++;
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      ));
    });
  }

  Future<int> getCarIndex() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.
    setState(() {
      _indexCar = prefs.getInt('index');
    });
    return _indexCar;
  }

  Future<int> _updatePosition() async {
    Position pos = await _determinePosition();

    _latitude = await pos.latitude;
    _longitude = await pos.longitude;

    return 1;
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _changeCamera() async {
    var carCoord = LatLng(carLat, carLong);
    var meCoord = LatLng(_latitude, _longitude);

    if (changedCam == true) {
      print("1111111111111111");
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(target: carCoord, zoom: 18.4746)));
      changedCam = false;
    } else {
      print("22222222222222");
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(target: meCoord, zoom: 18.4746)));
      changedCam = true;
    }
  }

  Future<Map<String, dynamic>> getDirections(
      LatLng origin, LatLng destination) async {
    var mode = 'walking';
    var originD =
        origin.latitude.toString() + ',' + origin.longitude.toString();
    var destinationD = destination.latitude.toString() +
        ',' +
        destination.longitude.toString();
    print(originD);
    print(destinationD);

    var key = 'AIzaSyCDzvKYkIZ1WSIk-V3uryzZUaNMuG908Jc';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$originD&destination=$destinationD&key=$key&mode=$mode';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    return results;
  }

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(carLat, carLong),
    zoom: 18.4746,
  );

  // fazer um marker
  static final Marker _carMarker = Marker(
      markerId: MarkerId('My Car'),
      infoWindow: InfoWindow(title: 'My Car'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(carLat, carLong));

  static final Marker _personMarker = Marker(
      markerId: MarkerId('Me'),
      infoWindow: InfoWindow(title: 'Me'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(_latitude, _longitude));

// polyline
  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [_carMarker.position, _personMarker.position],
    width: 5,
  );
  // https://youtu.be/tfFByL7F-00?t=472   vou aqki

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Color.fromRGBO(160, 5, 10, 40),
      ),
      body: Container(
        child: FutureBuilder(
          future: _updatePosition(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return (Center(child: CircularProgressIndicator()));
            } else {
              return GoogleMap(
                mapType: MapType.hybrid,
                markers: {
                  _carMarker,
                  _personMarker,
                },
                polylines: _polylines,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              backgroundColor: Color.fromRGBO(160, 5, 10, 40),
              onPressed: () async {
                var directions = await getDirections(
                    LatLng(carLat, carLong), LatLng(_latitude, _longitude));

                _setPolyline(directions['polyline_decoded']);
              },
              label: Text('GET PATH'),
              icon: Icon(Icons.directions_walk),
            ),
            FloatingActionButton.small(
              heroTag: "btn2",
              backgroundColor: Color.fromRGBO(160, 5, 10, 40),
              onPressed: _changeCamera,
              //label: Text("ME/CAR")
              child: Icon(Icons.location_on_sharp),
            )
          ],
        ),
      ),
    );
  }
}
