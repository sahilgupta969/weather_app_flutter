import 'dart:convert';

class WeatherData {
  final String name;
  final double temp;  // Changed from String to double
  final String main;
  final String icon;

  WeatherData({
    required this.name,
    required this.temp,
    required this.main,
    required this.icon,
  });

  factory WeatherData.deserialize(String jsonString) {
    final Map<String, dynamic> map = jsonDecode(jsonString);

    return WeatherData(
      name: map['name']?.toString() ?? 'Unknown',
      temp: (map['main']['temp'] as num?)?.toDouble() ?? 0.0,
      main: map['weather'][0]['main']?.toString() ?? '',
      icon: map['weather'][0]['icon']?.toString() ?? '',
    );
  }
}