import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double? _heading;
  Position? _currentPosition;

  final double tokoLatitude = -7.7797;
  final double tokoLongitude = 110.4159;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading;
      });
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    var lat1Rad = _toRadians(lat1);
    var lat2Rad = _toRadians(lat2);
    var deltaLonRad = _toRadians(lon2 - lon1);

    var y = math.sin(deltaLonRad) * math.cos(lat2Rad);
    var x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLonRad);
    var bearingRad = math.atan2(y, x);

    return (_toDegrees(bearingRad) + 360) % 360;
  }

  double _toRadians(double degree) => degree * math.pi / 180;
  double _toDegrees(double rad) => rad * 180 / math.pi;

  @override
  Widget build(BuildContext context) {
    double? bearing;

    if (_currentPosition != null) {
      bearing = calculateBearing(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        tokoLatitude,
        tokoLongitude,
      );
    }

    double? direction;

    if (_heading != null && bearing != null) {
      direction = (bearing - _heading!) % 360;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Compass to Nearest Makeup Store"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: (_currentPosition == null || _heading == null)
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Position: ${_currentPosition!.latitude.toStringAsFixed(5)}, ${_currentPosition!.longitude.toStringAsFixed(5)}',
                  ),
                  const SizedBox(height: 16),
                  Text('Direction to Store: ${bearing!.toStringAsFixed(1)}°'),
                  const SizedBox(height: 16),
                  Transform.rotate(
                    angle: (direction ?? 0) * (math.pi / 180) * -1,
                    child: const Icon(
                      Icons.navigation,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Arrow points to the nearest makeup store",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
