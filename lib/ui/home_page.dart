import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/ui/weather.dart';
import 'package:weather_app/ui/weather_data.dart';
import 'package:weather_app/api/map_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherData? _weatherData;
  bool _isLoading = true;
  String? _error;
  final WeatherApi _weatherApi = WeatherApi();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check location permission
      final status = await Permission.location.request();

      if (status.isGranted) {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        setState(() {
          _currentPosition = position;
        });

        // Load weather for current location
        await _loadWeather(
          lat: position.latitude,
          lon: position.longitude,
        );
      } else {
        setState(() {
          _isLoading = false;
          _error = "Location permission denied. Using default location.";
        });
        // Fallback to default location
        await _loadWeather(lat: 37.7749, lon: -122.4194);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = "Failed to get location: ${e.toString()}";
      });
      // Fallback to default location
      await _loadWeather(lat: 37.7749, lon: -122.4194);
    }
  }

  Future<void> _loadWeather({required double lat, required double lon}) async {
    try {
      final weatherData = await _weatherApi.getWeather(lat: lat, lon: lon);
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load weather data: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    if (_weatherData != null) {
      return Column(
        children: [
          if (_currentPosition != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Current Location: '
                    '${_currentPosition!.latitude.toStringAsFixed(4)}, '
                    '${_currentPosition!.longitude.toStringAsFixed(4)}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          Expanded(child: Weather(weatherData: _weatherData!)),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No weather data available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Get Weather'),
          ),
        ],
      ),
    );
  }
}